import 'package:flutter/material.dart';

import '../../../../l10n/generated/app_localizations.dart';
import '../../models/reading_content.dart';
import '../../theme/reader_theme.dart';
import 'reader_sheet_header.dart';

class ReaderNavigationSheet extends StatefulWidget {
  const ReaderNavigationSheet({
    required this.content,
    required this.selectedId,
    super.key,
  });
  final ReadingContent content;
  final String selectedId;
  @override
  State<ReaderNavigationSheet> createState() => _ReaderNavigationSheetState();
}

class _ReaderNavigationSheetState extends State<ReaderNavigationSheet> {
  final GlobalKey _selectedKey = GlobalKey();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final BuildContext? selectedContext = _selectedKey.currentContext;
      if (mounted && selectedContext != null) {
        Scrollable.ensureVisible(selectedContext, alignment: .35);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ReaderTheme colors = ReaderTheme.of(context);
    final AppLocalizations strings = AppLocalizations.of(context);
    return SafeArea(
      top: false,
      child: Column(
        children: <Widget>[
          ReaderSheetHeader(title: widget.content.title),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Divider(),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  for (final (int index, ReadingGroup group)
                      in widget.content.groups.indexed) ...<Widget>[
                    if (index > 0)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Divider(),
                      ),
                    if (group.title != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Text(
                          group.title!,
                          style: TextStyle(
                            color: colors.heading,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: <Widget>[
                        for (final ReadingUnit unit in group.units)
                          Semantics(
                            selected: unit.id == widget.selectedId,
                            child: OutlinedButton(
                              key: unit.id == widget.selectedId
                                  ? _selectedKey
                                  : ValueKey<String>(unit.id),
                              onPressed: () =>
                                  Navigator.of(context).pop(unit.id),
                              style: OutlinedButton.styleFrom(
                                minimumSize: const Size(48, 48),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                backgroundColor: unit.id == widget.selectedId
                                    ? colors.selectedBackground
                                    : colors.surface,
                                foregroundColor: unit.id == widget.selectedId
                                    ? colors.selectedForeground
                                    : colors.heading,
                                side: BorderSide(
                                  color: unit.id == widget.selectedId
                                      ? colors.selectedBackground
                                      : colors.border,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Semantics(
                                label:
                                    unit.title ?? strings.question(unit.number),
                                child: ExcludeSemantics(
                                  child: Text(
                                    unit.question == null
                                        ? unit.title ?? '${unit.number}'
                                        : '${unit.number}',
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
