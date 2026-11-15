import 'package:flutter/material.dart';

import '../../../../l10n/generated/app_localizations.dart';
import '../../theme/reader_theme.dart';

class ReaderSheetHeader extends StatelessWidget {
  const ReaderSheetHeader({required this.title, super.key});
  final String title;
  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      const SizedBox(height: 10),
      Container(
        width: 32,
        height: 4,
        decoration: BoxDecoration(
          color:
              Theme.of(context).extension<ReaderTheme>()?.border ??
              Theme.of(context).colorScheme.outlineVariant,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 20, right: 4, top: 4),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color:
                      Theme.of(context).extension<ReaderTheme>()?.heading ??
                      Theme.of(context).colorScheme.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            IconButton(
              tooltip: AppLocalizations.of(context).readerClose,
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.close, size: 20),
            ),
          ],
        ),
      ),
    ],
  );
}
