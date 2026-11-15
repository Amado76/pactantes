import 'package:flutter/material.dart';

import '../../../../design_system/theme/app_theme.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../core/library/models/reading_document.dart';
import '../../models/home_reading_item.dart';
import '../../../../core/reading_progress/models/reading_progress.dart';
import 'home_action.dart';

class ReadingSection extends StatefulWidget {
  const ReadingSection({
    required this.items,
    required this.title,
    this.onOpen,
    super.key,
  });
  final String title;
  final ValueChanged<HomeReadingItem>? onOpen;
  final List<HomeReadingItem> items;
  @override
  State<ReadingSection> createState() => _ReadingSectionState();
}

class _ReadingSectionState extends State<ReadingSection> {
  static const double _viewportFraction = .72;

  int _page = 0;

  @override
  void didUpdateWidget(ReadingSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(oldWidget.items, widget.items)) _page = 0;
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations strings = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.medium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if (widget.items.length > 1) ...<Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                widget.title.toUpperCase(),
                style: const TextStyle(fontSize: 12, color: AppColors.softRed),
              ),
            ),
            const SizedBox(height: 8),
          ],
          if (widget.items.length == 1)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _ReadingCard(
                item: widget.items.single,
                heading: widget.title,
                onOpen: widget.onOpen,
              ),
            )
          else if (widget.items.length > 1) ...<Widget>[
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final double itemWidth =
                    constraints.maxWidth * _viewportFraction;
                return NotificationListener<ScrollUpdateNotification>(
                  key: const Key('reading-carousel'),
                  onNotification: (ScrollUpdateNotification notification) {
                    final int page = (notification.metrics.pixels / itemWidth)
                        .round()
                        .clamp(0, widget.items.length - 1);
                    if (_page != page) setState(() => _page = page);
                    return false;
                  },
                  child: SingleChildScrollView(
                    key: ObjectKey(widget.items),
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        for (final (int index, HomeReadingItem item)
                            in widget.items.indexed)
                          SizedBox(
                            width: itemWidth,
                            child: Padding(
                              padding: EdgeInsets.only(
                                left: index == 0 ? AppSpacing.page : 12,
                                right: 2,
                                bottom: 4,
                              ),
                              child: _ReadingCard(
                                item: item,
                                onOpen: widget.onOpen,
                              ),
                            ),
                          ),
                        SizedBox(width: constraints.maxWidth - itemWidth),
                      ],
                    ),
                  ),
                );
              },
            ),
            Semantics(
              label: strings.readingPage(_page + 1, widget.items.length),
              child: Padding(
                key: const Key('reading-pagination'),
                padding: const EdgeInsets.only(top: AppSpacing.small),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    for (int index = 0; index < widget.items.length; index++)
                      Container(
                        width: 5,
                        height: 5,
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: index == _page
                              ? AppColors.softRed
                              : AppColors.border,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ReadingCard extends StatelessWidget {
  const _ReadingCard({required this.item, this.onOpen, this.heading});
  final HomeReadingItem item;
  final ValueChanged<HomeReadingItem>? onOpen;
  final String? heading;
  @override
  Widget build(BuildContext context) {
    final AppLocalizations strings = AppLocalizations.of(context);
    final AppLocalizations sourceStrings = item.languageCode == null
        ? strings
        : lookupAppLocalizations(Locale(item.languageCode!));
    final String? excerpt = item.unit?.question ?? item.unit?.body;
    return HomeAction(
      onTap: item.document.isAvailable && onOpen != null
          ? () => onOpen!(item)
          : null,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (heading != null) ...<Widget>[
              Text(
                heading!.toUpperCase(),
                style: const TextStyle(fontSize: 12, color: AppColors.softRed),
              ),
              const SizedBox(height: 14),
            ],
            Text(
              item.sourceTitle ?? item.document.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.navy,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              item.unit == null
                  ? _subtitle(item, strings)
                  : <String>[
                      if (item.unit!.parentTitle != null)
                        item.unit!.parentTitle!,
                      item.unit!.title ??
                          sourceStrings.question(item.unit!.number),
                    ].join(' · '),
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.mutedInk,
                height: 1.4,
              ),
            ),
            if (excerpt != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: DecoratedBox(
                  decoration: const BoxDecoration(
                    border: Border(left: BorderSide(color: AppColors.softRed)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    child: Text(
                      '“$excerpt”',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        height: 1.5,
                        color: AppColors.mutedInk,
                      ),
                    ),
                  ),
                ),
              ),
            if (item.unit == null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      item.progress == null
                          ? _documentInfo(item.document, strings)
                          : strings.completed(item.progress!.percentage),
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.mutedInk,
                      ),
                    ),
                    if (item.progress != null)
                      Text(
                        strings.paragraph(item.progress!.paragraph),
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.mutedInk,
                        ),
                      ),
                  ],
                ),
              ),
            if (item.progress != null)
              Padding(
                padding: const EdgeInsets.only(top: 2, bottom: 8),
                child: LinearProgressIndicator(
                  value: item.progress!.fraction,
                  minHeight: 3,
                  borderRadius: BorderRadius.circular(4),
                  color: AppColors.softRed,
                  backgroundColor: AppColors.border,
                  semanticsLabel: item.sourceTitle ?? item.document.title,
                  semanticsValue: item.progress!.percentage.toString(),
                ),
              ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                if (item.progress != null && item.unit != null)
                  Expanded(
                    child: Text(
                      strings.completed(item.progress!.percentage),
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.mutedInk,
                      ),
                    ),
                  ),
                Flexible(
                  child: Text(
                    item.progress == null
                        ? strings.homeBeginStudy
                        : strings.homeResumeStudy,
                    style: const TextStyle(
                      color: AppColors.softRed,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.chevron_right,
                  size: 18,
                  color: AppColors.softRed,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

String _subtitle(HomeReadingItem item, AppLocalizations strings) {
  final ReadingProgress? progress = item.progress;
  if (progress != null) {
    return progress.sectionTitle.isNotEmpty
        ? progress.sectionTitle
        : strings.paragraph(progress.paragraph);
  }
  return item.document.type == DocumentType.catechism
      ? strings.question(1)
      : strings.documentBeginning;
}

String _documentInfo(ReadingDocument document, AppLocalizations strings) {
  final int? count = document.totalUnits;
  if (document.type == DocumentType.catechism && count != null) {
    return strings.questionCount(count);
  }
  return switch (document.type) {
    DocumentType.confession => strings.documentConfession,
    DocumentType.catechism => strings.documentCatechism,
    DocumentType.creed => strings.documentCreed,
    DocumentType.document => strings.documentHistorical,
    DocumentType.collection => strings.documentCollection,
  };
}
