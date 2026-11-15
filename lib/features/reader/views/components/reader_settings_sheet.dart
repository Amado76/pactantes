import 'package:flutter/material.dart';

import '../../../../l10n/generated/app_localizations.dart';
import '../../models/reader_preferences.dart';
import '../../theme/reader_theme.dart';
import 'reader_sheet_header.dart';

class ReaderSettingsSheet extends StatelessWidget {
  const ReaderSettingsSheet({
    required this.preferences,
    required this.onChanged,
    super.key,
  });
  final ReaderPreferences preferences;
  final ValueChanged<ReaderPreferences> onChanged;
  @override
  Widget build(BuildContext context) {
    final AppLocalizations strings = AppLocalizations.of(context);
    final ReaderTheme colors = ReaderTheme.of(context);
    final List<String> themes = <String>[
      strings.readerLight,
      strings.readerPaper,
      strings.readerDark,
    ];
    final List<String> spacings = <String>[
      strings.readerCompact,
      strings.readerNormal,
      strings.readerWide,
    ];
    final Widget spacingOptions = SegmentedButton<ReadingSpacing>(
      showSelectedIcon: false,
      style: SegmentedButton.styleFrom(
        visualDensity: VisualDensity.compact,
        selectedBackgroundColor: colors.surface,
        selectedForegroundColor: colors.heading,
        side: BorderSide.none,
        padding: const EdgeInsets.symmetric(horizontal: 8),
      ),
      segments: <ButtonSegment<ReadingSpacing>>[
        for (final ReadingSpacing spacing in ReadingSpacing.values)
          ButtonSegment<ReadingSpacing>(
            value: spacing,
            label: Text(spacings[spacing.index]),
          ),
      ],
      selected: <ReadingSpacing>{preferences.spacing},
      onSelectionChanged: (Set<ReadingSpacing> value) =>
          onChanged(preferences.copyWith(spacing: value.single)),
    );
    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ReaderSheetHeader(title: strings.readerSettings),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(child: Text(strings.readerTextSize)),
                      _SizeButton(
                        label: 'A−',
                        tooltip: strings.readerDecreaseSize,
                        onPressed: preferences.textSize <= 14
                            ? null
                            : () => onChanged(
                                preferences.copyWith(
                                  textSize: preferences.textSize - 1,
                                ),
                              ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text('${preferences.textSize.round()}'),
                      ),
                      _SizeButton(
                        label: 'A+',
                        tooltip: strings.readerIncreaseSize,
                        onPressed: preferences.textSize >= 36
                            ? null
                            : () => onChanged(
                                preferences.copyWith(
                                  textSize: preferences.textSize + 1,
                                ),
                              ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(strings.readerTheme),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      for (final ReaderPalette palette
                          in ReaderPalette.values) ...<Widget>[
                        if (palette.index > 0) const SizedBox(width: 8),
                        Expanded(
                          child: Semantics(
                            selected: preferences.palette == palette,
                            child: InkWell(
                              onTap: () => onChanged(
                                preferences.copyWith(palette: palette),
                              ),
                              borderRadius: BorderRadius.circular(8),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    height: 42,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: ReaderTheme(palette).background,
                                      border: Border.all(
                                        color: preferences.palette == palette
                                            ? colors.accent
                                            : colors.border,
                                        width: preferences.palette == palette
                                            ? 2
                                            : 1,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      'Aa',
                                      style: TextStyle(
                                        color: ReaderTheme(palette).primaryText,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 4,
                                      bottom: 4,
                                    ),
                                    child: Text(
                                      themes[palette.index],
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: colors.secondaryText,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 8),
                  LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
                          if (constraints.maxWidth >=
                              340 *
                                  MediaQuery.textScalerOf(context).scale(14) /
                                  14) {
                            return Row(
                              children: <Widget>[
                                Expanded(child: Text(strings.readerSpacing)),
                                spacingOptions,
                              ],
                            );
                          }
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(strings.readerSpacing),
                              const SizedBox(height: 4),
                              spacingOptions,
                            ],
                          );
                        },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SizeButton extends StatelessWidget {
  const _SizeButton({
    required this.label,
    required this.tooltip,
    required this.onPressed,
  });
  final String label;
  final String tooltip;
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) => Tooltip(
    message: tooltip,
    child: SizedBox(
      width: 48,
      height: 48,
      child: Center(
        child: OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(48, 32),
            padding: EdgeInsets.zero,
            tapTargetSize: MaterialTapTargetSize.padded,
          ),
          child: Text(label),
        ),
      ),
    ),
  );
}
