import 'dart:async';

import 'package:flutter/material.dart';

import '../../../design_system/theme/app_theme.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../models/home_reading_item.dart';
import '../view_models/home_view_model.dart';
import 'components/reading_section.dart';
import 'components/home_action.dart';

class HomeView extends StatefulWidget {
  const HomeView({required this.viewModel, super.key});

  final HomeViewModel viewModel;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    unawaited(widget.viewModel.initialize());
  }

  @override
  void didUpdateWidget(HomeView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.viewModel != widget.viewModel) {
      unawaited(widget.viewModel.initialize());
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations strings = AppLocalizations.of(context);
    final TextTheme text = Theme.of(context).textTheme;
    return Scaffold(
      bottomNavigationBar: DecoratedBox(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: BottomNavigationBar(
          currentIndex: 0,
          // Destinations are intentionally presentational in this phase.
          onTap: (int index) {},
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: const Icon(Icons.home_outlined),
              activeIcon: const Icon(Icons.home),
              label: strings.home,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.import_contacts_outlined),
              label: strings.bible,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.book_outlined),
              label: strings.library,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.search),
              label: strings.search,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.people_outline),
              label: strings.community,
            ),
          ],
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: CustomScrollView(
              slivers: <Widget>[
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.page,
                    12,
                    AppSpacing.page,
                    0,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 48,
                                vertical: 12,
                              ),
                              child: Center(
                                child: Column(
                                  children: <Widget>[
                                    Image.asset(
                                      'assets/logo/pactantes.png',
                                      width: 88,
                                      height: 30,
                                      excludeFromSemantics: true,
                                      filterQuality: FilterQuality.high,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Pactantes',
                                      style: text.headlineLarge,
                                    ),
                                    Text(
                                      strings.brandSubtitle,
                                      style: text.bodyLarge?.copyWith(
                                        color: AppColors.mutedInk,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              right: 0,
                              top: 0,
                              child: IconButton(
                                tooltip: strings.moreOptions,
                                onPressed: () {},
                                color: AppColors.ink,
                                icon: const Icon(Icons.more_vert, size: 22),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.small),
                        Text(strings.introTitle, style: text.headlineSmall),
                        const SizedBox(height: 4),
                        Text(strings.introDescription, style: text.bodyMedium),
                        const SizedBox(height: AppSpacing.medium),
                        _BibleEntry(strings: strings),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: ListenableBuilder(
                    listenable: widget.viewModel,
                    builder: (BuildContext context, Widget? child) {
                      if (widget.viewModel.readingState ==
                          HomeReadingState.loading) {
                        return Padding(
                          padding: const EdgeInsets.all(AppSpacing.section),
                          child: Center(
                            child: CircularProgressIndicator(
                              semanticsLabel: strings.loadingReadingProgress,
                            ),
                          ),
                        );
                      }
                      if (widget.viewModel.readingState ==
                          HomeReadingState.error) {
                        return Padding(
                          padding: const EdgeInsets.all(AppSpacing.page),
                          child: Column(
                            children: <Widget>[
                              Text(strings.readingProgressError),
                              TextButton(
                                onPressed: () =>
                                    unawaited(widget.viewModel.initialize()),
                                child: Text(strings.retry),
                              ),
                            ],
                          ),
                        );
                      }
                      final List<HomeReadingItem> items =
                          widget.viewModel.readingItems;
                      return ReadingSection(
                        items: items,
                        title: widget.viewModel.hasReadingProgress
                            ? strings.continueReading
                            : strings.startReading,
                      );
                    },
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.page,
                    AppSpacing.section,
                    AppSpacing.page,
                    AppSpacing.section,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: _LibrarySection(strings: strings),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BibleEntry extends StatelessWidget {
  const _BibleEntry({required this.strings});
  final AppLocalizations strings;

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;
    return HomeAction(
      decoration: BoxDecoration(
        color: AppColors.navy,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.page,
          vertical: AppSpacing.medium,
        ),
        child: Row(
          children: <Widget>[
            const Icon(
              Icons.import_contacts_outlined,
              size: 30,
              color: Colors.white,
            ),
            Container(
              height: 36,
              width: 1,
              margin: const EdgeInsets.symmetric(horizontal: AppSpacing.medium),
              color: Colors.white30,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    strings.bibleTitle,
                    style: text.titleLarge?.copyWith(color: Colors.white),
                  ),
                  Text(
                    strings.bibleEdition,
                    style: text.bodyLarge?.copyWith(
                      color: Colors.white.withValues(alpha: .85),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, size: 20, color: Colors.white70),
          ],
        ),
      ),
    );
  }
}

class _LibrarySection extends StatelessWidget {
  const _LibrarySection({required this.strings});
  final AppLocalizations strings;

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;
    final List<(IconData, String)> categories = <(IconData, String)>[
      (Icons.description_outlined, strings.confessions),
      (Icons.import_contacts_outlined, strings.catechisms),
      (Icons.shield_outlined, strings.creeds),
      (Icons.account_balance_outlined, strings.documents),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Text(strings.exploreLibrary, style: text.titleLarge),
            ),
            const SizedBox(width: AppSpacing.small),
            HomeAction(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 4,
                ),
                child: Text(
                  strings.seeAll,
                  style: text.bodyLarge?.copyWith(
                    color: AppColors.softRed,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
        for (final (int index, (IconData, String) category)
            in categories.indexed)
          Column(
            children: <Widget>[
              HomeAction(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: AppSpacing.small,
                  ),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        category.$1,
                        size: 22,
                        color: index == 0 ? AppColors.softRed : AppColors.navy,
                      ),
                      const SizedBox(width: AppSpacing.medium),
                      Expanded(child: Text(category.$2, style: text.bodyLarge)),
                      const SizedBox(width: AppSpacing.small),
                      const Icon(
                        Icons.chevron_right,
                        size: 20,
                        color: AppColors.mutedInk,
                      ),
                    ],
                  ),
                ),
              ),
              if (index < categories.length - 1)
                const Padding(
                  padding: EdgeInsets.only(left: 46),
                  child: Divider(),
                ),
            ],
          ),
      ],
    );
  }
}
