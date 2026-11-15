import 'package:flutter/material.dart';

import '../../../../l10n/generated/app_localizations.dart';
import '../../models/reader_preferences.dart';
import 'reader_sheet_header.dart';

class ReaderTranslationSheet extends StatelessWidget {
  const ReaderTranslationSheet({required this.selected, this.title, super.key});
  final ReaderTranslation selected;
  final String? title;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations strings = AppLocalizations.of(context);
    final Map<ReaderTranslation, String> labels = <ReaderTranslation, String>{
      ReaderTranslation.device: strings.readerDeviceLanguage,
      ReaderTranslation.english: strings.readerEnglish,
      ReaderTranslation.portuguese: strings.readerPortuguese,
      ReaderTranslation.spanish: strings.readerSpanish,
    };
    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ReaderSheetHeader(title: title ?? strings.readerTranslation),
            for (final ReaderTranslation translation
                in ReaderTranslation.values)
              ListTile(
                title: Text(labels[translation]!),
                selected: selected == translation,
                trailing: selected == translation
                    ? const Icon(Icons.check)
                    : null,
                onTap: () => Navigator.of(context).pop(translation),
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
