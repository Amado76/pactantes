import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pactantes/core/library/repository/document_catalog_local_repository.dart';
import 'package:pactantes/core/preferences/shared_preferences_reader.dart';
import 'package:pactantes/design_system/theme/app_theme.dart';
import 'package:pactantes/core/reading_progress/models/reading_progress.dart';
import 'package:pactantes/features/home/repository/reading_progress_local_repository.dart';
import 'package:pactantes/features/home/view_models/home_view_model.dart';
import 'package:pactantes/features/home/views/home_view.dart';
import 'package:pactantes/features/reader/models/reader_preferences.dart';
import 'package:pactantes/features/reader/models/reading_content.dart';
import 'package:pactantes/features/reader/repository/reader_content_local_repository.dart';
import 'package:pactantes/features/reader/repository/reader_preferences_local_repository.dart';
import 'package:pactantes/l10n/generated/app_localizations.dart';

class EmptyProgress implements ReadingProgressLocalRepository {
  @override
  Future<List<ReadingProgress>> read() async => <ReadingProgress>[];
}

class SavedProgress extends EmptyProgress {
  @override
  Future<List<ReadingProgress>> read() async => <ReadingProgress>[
    ReadingProgress(
      documentId: 'heidelberg-catechism',
      sectionId: 'question-1',
      paragraph: 1,
      progress: .42,
      lastReadAt: DateTime.utc(2026, 11, 14),
    ),
  ];
}

class FailingPreferences implements ReaderPreferencesLocalRepository {
  @override
  Future<ReaderPreferences> read() async =>
      const ReaderPreferences(translation: ReaderTranslation.english);
  @override
  Future<void> save(ReaderPreferences preferences) async =>
      throw Exception('Storage unavailable');
}

class PreviewContent implements ReaderContentLocalRepository {
  @override
  Future<ReadingContent> read(
    String documentId, {
    String languageCode = 'es',
  }) async => ReadingContent(
    documentId: documentId,
    title: 'Source $languageCode',
    languageCode: languageCode,
    units: <ReadingUnit>[
      ReadingUnit(
        id: 'question-1',
        number: 1,
        question: 'Question $languageCode?',
        body: 'Answer $languageCode.',
      ),
    ],
  );
}

class PendingPreviewContent extends PreviewContent {
  final Completer<void> started = Completer<void>();
  final Completer<ReadingContent> pending = Completer<ReadingContent>();

  @override
  Future<ReadingContent> read(String documentId, {String languageCode = 'es'}) {
    if (languageCode == 'es') {
      started.complete();
      return pending.future;
    }
    return super.read(documentId, languageCode: languageCode);
  }
}

void main() {
  for (final bool staleFailure in <bool>[false, true]) {
    test(
      'new translation survives a stale load (failure: $staleFailure)',
      () async {
        SharedPreferences.setMockInitialValues(<String, Object>{});
        final PendingPreviewContent content = PendingPreviewContent();
        final HomeViewModel model = HomeViewModel(
          EmptyProgress(),
          const DocumentCatalogLocalRepositoryImpl(),
          readerPreferencesRepository: ReaderPreferencesLocalRepositoryImpl(
            SharedPreferencesReader(SharedPreferences.getInstance),
          ),
          readerContentRepository: content,
        );
        addTearDown(model.dispose);
        final Future<void> initial = model.initialize(languageCode: 'es');
        await content.started.future;
        expect(
          await model.changeTranslation(ReaderTranslation.english),
          isTrue,
        );
        expect(model.readingItems.single.languageCode, 'en');
        if (staleFailure) {
          content.pending.completeError(const FormatException('Stale content'));
        } else {
          content.pending.complete(
            await PreviewContent().read('heidelberg-catechism'),
          );
        }
        await initial;
        expect(model.readingState, HomeReadingState.ready);
        expect(model.readingItems.single.languageCode, 'en');
      },
    );
  }

  test('a device language change supersedes an in-flight Home load', () async {
    final PendingPreviewContent content = PendingPreviewContent();
    final HomeViewModel model = HomeViewModel(
      EmptyProgress(),
      const DocumentCatalogLocalRepositoryImpl(),
      readerContentRepository: content,
    );
    addTearDown(model.dispose);
    final Future<void> initial = model.initialize(languageCode: 'es');
    await content.started.future;
    await model.initialize(languageCode: 'pt');
    content.pending.complete(
      await PreviewContent().read('heidelberg-catechism'),
    );
    await initial;
    expect(model.readingState, HomeReadingState.ready);
    expect(model.readingItems.single.languageCode, 'pt');
  });

  testWidgets(
    'Home language menu persists the shared choice and preserves reader settings',
    (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final ReaderPreferencesLocalRepository repository =
          ReaderPreferencesLocalRepositoryImpl(
            SharedPreferencesReader(SharedPreferences.getInstance),
          );
      await repository.save(
        const ReaderPreferences(
          palette: ReaderPalette.dark,
          textSize: 25,
          spacing: ReadingSpacing.wide,
        ),
      );
      final HomeViewModel model = HomeViewModel(
        EmptyProgress(),
        const DocumentCatalogLocalRepositoryImpl(),
        readerPreferencesRepository: repository,
      );
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
      await tester.tap(find.byTooltip('Más opciones'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Idioma'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Portugués'));
      await tester.pumpAndSettle();
      final ReaderPreferences saved = await repository.read();
      expect(saved.translation, ReaderTranslation.portuguese);
      expect(saved.palette, ReaderPalette.dark);
      expect(saved.textSize, 25);
      expect(saved.spacing, ReadingSpacing.wide);
      await repository.save(
        saved.copyWith(translation: ReaderTranslation.english),
      );
      await tester.tap(find.byTooltip('Más opciones'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Idioma'));
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<ListTile>(find.widgetWithText(ListTile, 'Inglés'))
            .selected,
        isTrue,
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'Home preview follows the saved edition and opens the actual document',
    (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final ReaderPreferencesLocalRepository repository =
          ReaderPreferencesLocalRepositoryImpl(
            SharedPreferencesReader(SharedPreferences.getInstance),
          );
      await repository.save(
        const ReaderPreferences(translation: ReaderTranslation.portuguese),
      );
      final HomeViewModel model = HomeViewModel(
        SavedProgress(),
        const DocumentCatalogLocalRepositoryImpl(),
        readerPreferencesRepository: repository,
        readerContentRepository: PreviewContent(),
      );
      addTearDown(model.dispose);
      String? opened;
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: HomeView(
            viewModel: model,
            onOpenReading: (item) => opened = item.document.id,
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Source pt'), findsOneWidget);
      expect(find.text('42% COMPLETED'), findsOneWidget);
      expect(find.text('“Question pt?”'), findsOneWidget);
      await tester.tap(find.text('Resume study'));
      await tester.pumpAndSettle();
      expect(opened, 'heidelberg-catechism');
      await model.changeTranslation(ReaderTranslation.english);
      await tester.pumpAndSettle();
      expect(find.text('Source en'), findsOneWidget);
      expect(find.text('“Question en?”'), findsOneWidget);
    },
  );

  test(
    'Home reports persistence failure without changing its selected language',
    () async {
      final HomeViewModel model = HomeViewModel(
        EmptyProgress(),
        const DocumentCatalogLocalRepositoryImpl(),
        readerPreferencesRepository: FailingPreferences(),
      );
      addTearDown(model.dispose);
      expect(await model.loadTranslation(), isTrue);
      expect(await model.changeTranslation(ReaderTranslation.spanish), isFalse);
      expect(model.selectedTranslation, ReaderTranslation.english);
    },
  );
}
