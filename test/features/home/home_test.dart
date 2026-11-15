import 'dart:async';
import 'dart:convert';

import '../../core/library/fake_document_catalog.dart';

import 'package:pactantes/core/library/repository/document_catalog_local_repository.dart';
import 'package:pactantes/features/home/models/home_reading_item.dart';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pactantes/core/preferences/preferences_reader.dart';
import 'package:pactantes/design_system/theme/app_theme.dart';
import 'package:pactantes/core/reading_progress/models/reading_progress.dart';
import 'package:pactantes/features/home/repository/reading_progress_local_repository.dart';
import 'package:pactantes/features/home/view_models/home_view_model.dart';
import 'package:pactantes/features/home/views/home_view.dart';
import 'package:pactantes/l10n/generated/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pactantes/core/preferences/shared_preferences_reader.dart';

class FakeRepository implements ReadingProgressLocalRepository {
  FakeRepository(this.items, {this.fail = false});
  final List<ReadingProgress> items;
  bool fail;
  @override
  Future<List<ReadingProgress>> read() async {
    if (fail) throw Exception('Unavailable');
    return items;
  }
}

class DeferredRepository implements ReadingProgressLocalRepository {
  final Completer<List<ReadingProgress>> result =
      Completer<List<ReadingProgress>>();
  int readCount = 0;

  @override
  Future<List<ReadingProgress>> read() {
    readCount++;
    return result.future;
  }
}

class FakePreferences implements PreferencesReader {
  FakePreferences(this.value);
  final String? value;
  @override
  Future<String?> readString(String key) async => value;
}

ReadingProgress item({
  String id = 'westminster-confession',
  double progress = .68,
}) => ReadingProgress(
  documentId: id,
  sectionId: 'chapter-1',
  sectionTitle: 'Capítulo I • De las Santas Escrituras',
  paragraph: 6,
  progress: progress,
  lastReadAt: DateTime.utc(2026, 11, 8),
);

Map<String, Object?> record({Object? progress = .68}) => <String, Object?>{
  'documentId': 'westminster-confession',
  'sectionId': 'chapter-1',
  'documentTitle': 'Confesión de Fe de Westminster',
  'sectionTitle': 'Capítulo I • De las Santas Escrituras',
  'paragraph': 6,
  'progress': progress,
  'lastReadAt': '2026-11-08T15:30:00Z',
};

FakeDocumentCatalog readableCatalog() => FakeDocumentCatalog(
  availableIds: <String>{'westminster-confession', 'heidelberg-catechism'},
);

Future<void> render(WidgetTester tester, List<ReadingProgress> items) async {
  await renderModel(
    tester,
    HomeViewModel(FakeRepository(items), readableCatalog()),
  );
}

Future<void> renderModel(WidgetTester tester, HomeViewModel model) async {
  addTearDown(model.dispose);
  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light,
      locale: const Locale('es'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: HomeView(viewModel: model),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  test(
    'repository ignores missing, malformed and incomplete records',
    () async {
      for (final String? value in <String?>[
        null,
        '',
        '{',
        'null',
        '42',
        '{}',
        '[null,{}]',
      ]) {
        expect(
          await ReadingProgressLocalRepositoryImpl(FakePreferences(value))
              .read(),
          isEmpty,
        );
      }
      final List<ReadingProgress> items =
          await ReadingProgressLocalRepositoryImpl(
            FakePreferences(
              jsonEncode(<Object?>[null, record(), record(progress: 'bad')]),
            ),
          ).read();
      expect(items, hasLength(1));
      expect(items.single.percentage, 68);
    },
  );

  test(
    'SharedPreferences adapter reads saved data and tolerates wrong types',
    () async {
      SharedPreferences.setMockInitialValues(<String, Object>{
        'reading_progress': jsonEncode(record()),
      });
      final SharedPreferencesReader reader = SharedPreferencesReader(
        SharedPreferences.getInstance,
      );
      expect(
        await ReadingProgressLocalRepositoryImpl(reader).read(),
        hasLength(1),
      );
      SharedPreferences.setMockInitialValues(<String, Object>{
        'reading_progress': 4,
      });
      expect(await ReadingProgressLocalRepositoryImpl(reader).read(), isEmpty);
    },
  );

  test(
    'model rejects incomplete identities, invalid positions and timestamps',
    () {
      for (final Map<String, Object?> invalid in <Map<String, Object?>>[
        <String, Object?>{...record(), 'documentId': ' '},
        <String, Object?>{...record(), 'sectionTitle': 3},
        <String, Object?>{...record(), 'paragraph': 0},
        <String, Object?>{...record(), 'lastReadAt': 'bad'},
        <String, Object?>{...record(), 'progress': double.nan},
      ]) {
        expect(ReadingProgress.fromJson(invalid), isNull);
      }
    },
  );

  test('progress is constrained and ViewModel filters invalid data', () async {
    expect(item(progress: -1).percentage, 0);
    expect(item(progress: 2).percentage, 100);
    expect(item(progress: .68).fraction, .68);
    final HomeViewModel model = HomeViewModel(
      FakeRepository(<ReadingProgress>[
        item(),
        item(progress: double.infinity),
      ]),
      readableCatalog(),
    );
    addTearDown(model.dispose);
    expect(model.hasReadingProgress, isFalse);
    await model.initialize();
    expect(model.readingItems, hasLength(1));
    expect(() => model.readingItems.clear(), throwsUnsupportedError);
    final HomeViewModel failing = HomeViewModel(
      FakeRepository(<ReadingProgress>[], fail: true),
      readableCatalog(),
    );
    addTearDown(failing.dispose);
    await failing.initialize();
    expect(failing.hasReadingProgress, isFalse);
    expect(failing.readingItems, hasLength(2));
  });

  test(
    'loading prevents duplicate reads and completes with saved progress',
    () async {
      final DeferredRepository repository = DeferredRepository();
      final HomeViewModel model = HomeViewModel(repository, readableCatalog());
      addTearDown(model.dispose);
      expect(model.readingState, HomeReadingState.initial);
      final Future<void> loading = model.initialize();
      expect(model.readingState, HomeReadingState.loading);
      await model.initialize();
      expect(repository.readCount, 1);
      repository.result.complete(<ReadingProgress>[item()]);
      await loading;
      expect(model.readingState, HomeReadingState.ready);
      expect(model.hasReadingProgress, isTrue);
    },
  );

  test('adapter failures stay distinguishable from missing progress', () async {
    final SharedPreferencesReader reader = SharedPreferencesReader(
      () async => throw Exception('Storage unavailable'),
    );
    await expectLater(
      ReadingProgressLocalRepositoryImpl(reader).read(),
      throwsA(isA<PreferencesReadException>()),
    );
  });

  testWidgets('failed progress can be retried on the same screen', (
    WidgetTester tester,
  ) async {
    final FakeRepository repository = FakeRepository(<ReadingProgress>[
      item(),
    ], fail: true);
    await renderModel(tester, HomeViewModel(repository, readableCatalog()));
    expect(
      find.text('No se pudo cargar el progreso de lectura.'),
      findsOneWidget,
    );
    expect(find.text('Comenzar a leer'), findsNothing);
    repository.fail = false;
    await tester.ensureVisible(find.text('Reintentar'));
    await tester.tap(find.text('Reintentar'));
    await tester.pumpAndSettle();
    expect(find.text('Continuar leyendo'), findsOneWidget);
    expect(find.text('68% COMPLETADO'), findsOneWidget);
    expect(find.text('Reintentar'), findsNothing);
  });

  testWidgets(
    'static sections render with only Inicio selected and inert entries',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 1000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await render(tester, <ReadingProgress>[]);
      for (final String label in <String>[
        'Pactantes',
        'Recursos Reformados',
        'Creciendo en Gracia y Verdad',
        'Biblia Santa',
        'Explorar la biblioteca',
        'Confesiones de fe',
        'Catecismos',
        'Credos históricos',
        'Documentos reformados',
      ]) {
        expect(find.text(label), findsOneWidget);
      }
      expect(find.text('Continuar leyendo'), findsNothing);
      expect(find.text('Comenzar a leer'), findsOneWidget);
      for (final String label in <String>[
        'Biblia Santa',
        'Ver todo',
        'Confesiones de fe',
        'Catecismos',
        'Credos históricos',
        'Documentos reformados',
        'Biblia',
        'Biblioteca',
        'Buscar',
        'Comunidad',
      ]) {
        await tester.tap(find.text(label));
        await tester.pump();
        expect(
          tester
              .widget<BottomNavigationBar>(find.byType(BottomNavigationBar))
              .currentIndex,
          0,
        );
        expect(find.byType(HomeView), findsOneWidget);
      }
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('persisted valid data appears and corrupt data stays hidden', (
    WidgetTester tester,
  ) async {
    final ReadingProgressLocalRepositoryImpl repository =
        ReadingProgressLocalRepositoryImpl(
          FakePreferences(jsonEncode(record())),
        );
    await renderModel(tester, HomeViewModel(repository, readableCatalog()));
    expect(find.text('Continuar leyendo'), findsOneWidget);
    await renderModel(
      tester,
      HomeViewModel(
        ReadingProgressLocalRepositoryImpl(FakePreferences('{invalid')),
        readableCatalog(),
      ),
    );
    expect(find.text('Continuar leyendo'), findsNothing);
    expect(find.text('Comenzar a leer'), findsOneWidget);
    expect(find.byType(LinearProgressIndicator), findsNothing);
    expect(find.text('Biblia Santa'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  test(
    'suggestions use only readable documents when any are integrated',
    () async {
      final HomeViewModel model = HomeViewModel(
        FakeRepository(<ReadingProgress>[]),
        readableCatalog(),
      );
      addTearDown(model.dispose);
      await model.initialize();
      expect(model.readingItems, hasLength(2));
      expect(
        model.readingItems.every(
          (HomeReadingItem item) =>
              item.document.isAvailable && item.progress == null,
        ),
        isTrue,
      );
      expect(model.hasReadingProgress, isFalse);
    },
  );

  test(
    'registered catalog previews are shown without claiming availability',
    () async {
      final HomeViewModel model = HomeViewModel(
        FakeRepository(<ReadingProgress>[]),
        const DocumentCatalogLocalRepositoryImpl(),
      );
      addTearDown(model.dispose);
      await model.initialize();
      expect(model.readingItems, hasLength(4));
      expect(
        model.readingItems.every(
          (HomeReadingItem item) =>
              !item.document.isAvailable && item.progress == null,
        ),
        isTrue,
      );
      expect(
        model.readingItems.map((HomeReadingItem item) => item.document.id),
        isNot(contains('three-forms-of-unity')),
      );
    },
  );

  test(
    'unknown, unavailable and collection progress is ignored safely',
    () async {
      final HomeViewModel model = HomeViewModel(
        FakeRepository(<ReadingProgress>[
          item(),
          item(id: 'unknown'),
          item(id: 'canons-of-dort'),
          item(id: 'three-forms-of-unity'),
        ]),
        FakeDocumentCatalog(
          availableIds: <String>{
            'westminster-confession',
            'three-forms-of-unity',
          },
        ),
      );
      addTearDown(model.dispose);
      await model.initialize();
      expect(model.readingItems, hasLength(1));
      expect(model.readingItems.single.document.id, 'westminster-confession');
      expect(
        model.readingItems.single.document.title,
        'Confesión de Fe de Westminster',
      );
      expect(model.readingItems.single.progress?.percentage, 68);
      expect(model.hasReadingProgress, isTrue);
    },
  );

  test('progress without stored titles resolves through catalog', () async {
    final Map<String, Object?> saved = record()
      ..remove('documentTitle')
      ..remove('sectionTitle');
    final HomeViewModel model = HomeViewModel(
      ReadingProgressLocalRepositoryImpl(FakePreferences(jsonEncode(saved))),
      readableCatalog(),
    );
    addTearDown(model.dispose);
    await model.initialize();
    expect(model.hasReadingProgress, isTrue);
    expect(
      model.readingItems.single.document.title,
      'Confesión de Fe de Westminster',
    );
    expect(model.readingItems.single.progress?.paragraph, 6);
  });

  testWidgets(
    'start reading reuses cards and shows metadata without progress',
    (WidgetTester tester) async {
      await render(tester, <ReadingProgress>[]);
      expect(find.text('Comenzar a leer'), findsOneWidget);
      expect(find.byType(LinearProgressIndicator), findsNothing);
      expect(find.textContaining('COMPLETADO'), findsNothing);
      await tester.drag(
        find.byKey(const Key('reading-carousel')),
        const Offset(-600, 0),
      );
      await tester.pumpAndSettle();
      expect(find.text('Catecismo de Heidelberg'), findsOneWidget);
      expect(find.text('Pregunta 1'), findsOneWidget);
      expect(find.text('129 preguntas'), findsOneWidget);
      await tester.tap(find.text('Catecismo de Heidelberg'));
      await tester.pumpAndSettle();
      expect(find.byType(HomeView), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('one reading card has no pagination', (
    WidgetTester tester,
  ) async {
    await render(tester, <ReadingProgress>[item()]);
    expect(find.text('Continuar leyendo'), findsOneWidget);
    expect(find.text('68% COMPLETADO'), findsOneWidget);
    expect(find.text('Párrafo 6'), findsOneWidget);
    expect(find.byKey(const Key('reading-pagination')), findsNothing);
  });

  testWidgets('multiple reading cards scroll and update pagination', (
    WidgetTester tester,
  ) async {
    await render(tester, <ReadingProgress>[
      item(),
      item(id: 'heidelberg-catechism'),
    ]);
    expect(find.byKey(const Key('reading-pagination')), findsOneWidget);
    await tester.drag(
      find.byKey(const Key('reading-carousel')),
      const Offset(-600, 0),
    );
    await tester.pumpAndSettle();
    expect(find.text('Catecismo de Heidelberg'), findsOneWidget);
    expect(find.bySemanticsLabel('Lectura 2 de 2'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'compact screens and large text stay scrollable without overflow',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(320, 640);
      tester.view.devicePixelRatio = 1;
      tester.platformDispatcher.textScaleFactorTestValue = 2;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      await render(tester, <ReadingProgress>[
        item(),
        item(id: 'heidelberg-catechism'),
      ]);
      await tester.scrollUntilVisible(
        find.text('Documentos reformados'),
        250,
        scrollable: find
            .descendant(
              of: find.byType(CustomScrollView),
              matching: find.byType(Scrollable),
            )
            .first,
      );
      await tester.pumpAndSettle();
      expect(find.text('Documentos reformados'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
