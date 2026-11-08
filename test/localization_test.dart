import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pactantes/main.dart';

void main() {
  final Map<Locale, String> greetings = <Locale, String>{
    const Locale('pt', 'BR'): 'Olá, mundo!',
    const Locale('pt', 'PT'): 'Olá, mundo!',
    const Locale('en', 'US'): 'Hello World!',
    const Locale('en', 'GB'): 'Hello World!',
    const Locale('es', 'ES'): '¡Hola, mundo!',
    const Locale('es', 'PY'): '¡Hola, mundo!',
    const Locale('fr', 'FR'): 'Olá, mundo!',
  };

  for (final MapEntry<Locale, String> entry in greetings.entries) {
    testWidgets('resolves device locale ${entry.key}', (
      WidgetTester tester,
    ) async {
      tester.platformDispatcher.localesTestValue = <Locale>[entry.key];
      addTearDown(tester.platformDispatcher.clearLocalesTestValue);
      await tester.pumpWidget(const MainApp());
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
    await tester.pumpWidget(const MainApp());
    await tester.pumpAndSettle();
    expect(find.text('¡Hola, mundo!'), findsOneWidget);
  });

  testWidgets('updates when the device language changes', (
    WidgetTester tester,
  ) async {
    tester.platformDispatcher.localesTestValue = const <Locale>[Locale('pt')];
    addTearDown(tester.platformDispatcher.clearLocalesTestValue);
    await tester.pumpWidget(const MainApp());
    await tester.pumpAndSettle();
    expect(find.text('Olá, mundo!'), findsOneWidget);
    tester.platformDispatcher.localesTestValue = const <Locale>[Locale('en')];
    await tester.pumpAndSettle();
    expect(find.text('Hello World!'), findsOneWidget);
  });
}
