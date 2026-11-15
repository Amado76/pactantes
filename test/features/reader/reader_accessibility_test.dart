import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pactantes/features/reader/models/reader_preferences.dart';
import 'package:pactantes/features/reader/theme/reader_theme.dart';
import 'package:pactantes/features/reader/views/components/reader_settings_sheet.dart';
import 'package:pactantes/l10n/generated/app_localizations.dart';

void main() {
  testWidgets(
    'settings fit a narrow screen with large accessible text and bounded size controls',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(320, 700);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      ReaderPreferences preferences = const ReaderPreferences(textSize: 14);
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('es'),
          theme: const ReaderTheme(ReaderPalette.light).data(ThemeData()),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: MediaQuery(
            data: const MediaQueryData(textScaler: TextScaler.linear(2)),
            child: Scaffold(
              body: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) =>
                    ReaderSettingsSheet(
                      preferences: preferences,
                      onChanged: (ReaderPreferences value) =>
                          setState(() => preferences = value),
                    ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      final OutlinedButton decrease = tester.widget<OutlinedButton>(
        find.widgetWithText(OutlinedButton, 'A−'),
      );
      expect(decrease.onPressed, isNull);
      await tester.tap(find.text('A+'));
      await tester.pumpAndSettle();
      expect(preferences.textSize, 15);
      expect(tester.takeException(), isNull);
    },
  );
}
