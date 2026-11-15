import 'package:flutter/material.dart';

import '../../../../l10n/generated/app_localizations.dart';
import '../../theme/reader_theme.dart';

class ReaderBottomNavigation extends StatelessWidget {
  const ReaderBottomNavigation({
    required this.position,
    required this.total,
    required this.onPrevious,
    required this.onNext,
    super.key,
  });
  final int position;
  final int total;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;
  @override
  Widget build(BuildContext context) {
    final AppLocalizations strings = AppLocalizations.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const Divider(),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  tooltip: strings.readerPrevious,
                  onPressed: onPrevious,
                  icon: const Icon(Icons.chevron_left),
                ),
                Semantics(
                  label: strings.readingPage(position, total),
                  child: ExcludeSemantics(
                    child: Text(
                      '$position / $total',
                      style: TextStyle(
                        color: ReaderTheme.of(context).secondaryText,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  tooltip: strings.readerNext,
                  onPressed: onNext,
                  icon: const Icon(Icons.chevron_right),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
