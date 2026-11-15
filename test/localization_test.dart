import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pactantes/main.dart';
import 'package:pactantes/core/library/repository/document_catalog_local_repository.dart';

import 'package:pactantes/features/home/repository/reading_progress_local_repository.dart';

import 'package:pactantes/core/reading_progress/models/reading_progress.dart';
import 'package:pactantes/features/home/view_models/home_view_model.dart';

void main() {
  final Map<Locale, String> homeHeadings = <Locale, String>{
    const Locale('pt', 'BR'): 'Crescendo em Graça e Verdade',
    const Locale('pt', 'PT'): 'Crescendo em Graça e Verdade',
    const Locale('en', 'US'): 'Growing in Grace and Truth',
    const Locale('en', 'GB'): 'Growing in Grace and Truth',
    const Locale('es', 'ES'): 'Creciendo en Gracia y Verdad',
    const Locale('es', 'PY'): 'Creciendo en Gracia y Verdad',
    const Locale('fr', 'FR'): 'Crescendo em Graça e Verdade',
  };

  for (final MapEntry<Locale, String> entry in homeHeadings.entries) {
    testWidgets('resolves device locale ${entry.key}', (
      WidgetTester tester,
    ) async {
      tester.platformDispatcher.localesTestValue = <Locale>[entry.key];
      addTearDown(tester.platformDispatcher.clearLocalesTestValue);
      await tester.pumpWidget(
        MainApp(
          createHomeViewModel: () => HomeViewModel(
            _EmptyRepository(),
            const DocumentCatalogLocalRepositoryImpl(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text(entry.value), findsOneWidget);
      final BuildContext context = tester.element(find.byType(Scaffold));
      final String languageCode = entry.key.languageCode == 'fr'
          ? 'pt'
          : entry.key.languageCode;
      expect(Localizations.localeOf(context).languageCode, languageCode);
      expect(
        MaterialLocalizations.of(context).backButtonTooltip,
        <String, String>{
          'pt': 'Voltar',
          'en': 'Back',
          'es': 'Atrás',
        }[languageCode],
      );
    });
  }

  testWidgets('uses the first supported preferred language', (
    WidgetTester tester,
  ) async {
    tester.platformDispatcher.localesTestValue = const <Locale>[
      Locale('fr', 'FR'),
      Locale('es', 'MX'),
      Locale('en', 'US'),
    ];
    addTearDown(tester.platformDispatcher.clearLocalesTestValue);
    await tester.pumpWidget(
      MainApp(
        createHomeViewModel: () => HomeViewModel(
          _EmptyRepository(),
          const DocumentCatalogLocalRepositoryImpl(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Creciendo en Gracia y Verdad'), findsOneWidget);
  });

  testWidgets('updates when the device language changes', (
    WidgetTester tester,
  ) async {
    tester.platformDispatcher.localesTestValue = const <Locale>[Locale('pt')];
    addTearDown(tester.platformDispatcher.clearLocalesTestValue);
    await tester.pumpWidget(
      MainApp(
        createHomeViewModel: () => HomeViewModel(
          _EmptyRepository(),
          const DocumentCatalogLocalRepositoryImpl(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Crescendo em Graça e Verdade'), findsOneWidget);
    tester.platformDispatcher.localesTestValue = const <Locale>[Locale('en')];
    await tester.pumpAndSettle();
    expect(find.text('Growing in Grace and Truth'), findsOneWidget);
  });
}

class _EmptyRepository implements ReadingProgressLocalRepository {
  @override
  Future<List<ReadingProgress>> read() async => const <ReadingProgress>[];
}
