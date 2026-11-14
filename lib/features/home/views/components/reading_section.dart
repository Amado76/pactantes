import 'package:flutter/material.dart';

import '../../../../design_system/theme/app_theme.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../core/library/models/reading_document.dart';
import '../../models/home_reading_item.dart';
import '../../models/reading_progress.dart';
import 'home_action.dart';

class ReadingSection extends StatefulWidget {
  const ReadingSection({required this.items, required this.title, super.key});
  final String title;
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.page),
            child: Text(
              widget.title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const SizedBox(height: AppSpacing.small),
          if (widget.items.length == 1)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.page),
              child: _ReadingCard(item: widget.items.single),
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
                              child: _ReadingCard(item: item),
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
  const _ReadingCard({required this.item});
  final HomeReadingItem item;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations strings = AppLocalizations.of(context);
    final TextTheme text = Theme.of(context).textTheme;
    final int maxLines = MediaQuery.textScalerOf(context).scale(14) > 19
        ? 2
        : 1;
    return HomeAction(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.medium,
          vertical: 12,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    item.document.title,
                    maxLines: maxLines,
                    overflow: TextOverflow.ellipsis,
                    style: text.titleMedium?.copyWith(fontSize: 14),
                  ),
                ),
                const Icon(
                  Icons.chevron_right,
                  size: 16,
                  color: AppColors.mutedInk,
                ),
              ],
            ),
            const SizedBox(height: 3),
            Text(
              _subtitle(item, strings),
              maxLines: maxLines,
              overflow: TextOverflow.ellipsis,
              style: text.bodySmall,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.small),
              child: Divider(),
            ),
            SizedBox(
              width: double.infinity,
              child: Wrap(
                alignment: WrapAlignment.spaceBetween,
                spacing: AppSpacing.small,
                runSpacing: 4,
                children: <Widget>[
                  Text(
                    item.progress == null
                        ? _documentInfo(item.document, strings)
                        : strings.completed(item.progress!.percentage),
                    style: text.labelSmall?.copyWith(
                      color: item.progress == null
                          ? AppColors.mutedInk
                          : AppColors.softRed,
                    ),
                  ),
                  if (item.progress != null)
                    Text(
                      strings.paragraph(item.progress!.paragraph),
                      style: text.labelSmall,
                    ),
                ],
              ),
            ),
            const SizedBox(height: 5),
            if (item.progress == null)
              const SizedBox(height: 3)
            else
              LinearProgressIndicator(
                value: item.progress!.fraction,
                minHeight: 3,
                borderRadius: BorderRadius.circular(4),
                color: AppColors.softRed,
                backgroundColor: AppColors.border,
                semanticsLabel: item.document.title,
                semanticsValue: item.progress!.percentage.toString(),
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
