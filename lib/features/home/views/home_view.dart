import 'dart:async';

import 'package:flutter/material.dart';

import '../../../design_system/theme/app_theme.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../reader/models/reader_preferences.dart';
import '../../reader/views/components/reader_translation_sheet.dart';
import '../models/home_reading_item.dart';
import '../view_models/home_view_model.dart';
import 'components/reading_section.dart';
import 'components/home_action.dart';

class HomeView extends StatefulWidget {
  const HomeView({required this.viewModel, this.onOpenReading, super.key});

  final HomeViewModel viewModel;
  final ValueChanged<HomeReadingItem>? onOpenReading;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(HomeView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.viewModel != widget.viewModel) {
      unawaited(widget.viewModel.initialize());
    }
  }

  String? _deviceLanguage;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final String language = Localizations.localeOf(context).languageCode;
    if (_deviceLanguage == language) return;
    _deviceLanguage = language;
    unawaited(
      widget.viewModel.initialize(refresh: true, languageCode: language),
    );
  }

  Future<void> _translations() async {
    final bool loaded = await widget.viewModel.loadTranslation();
    if (!mounted) return;
    if (!loaded) {
      _translationError();
      return;
    }
    final ReaderTranslation? selected =
        await showModalBottomSheet<ReaderTranslation>(
          context: context,
          isScrollControlled: true,
          useSafeArea: true,
          builder: (BuildContext context) => ReaderTranslationSheet(
            title: AppLocalizations.of(context).language,
            selected: widget.viewModel.selectedTranslation,
          ),
        );
    if (!mounted || selected == null) return;
    final bool saved = await widget.viewModel.changeTranslation(selected);
    if (mounted && !saved) _translationError();
  }

  void _translationError() => ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(AppLocalizations.of(context).readerActionError)),
  );

  @override
  Widget build(BuildContext context) {
    final AppLocalizations strings = AppLocalizations.of(context);
    final TextTheme text = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        toolbarHeight: 48,
        backgroundColor: AppColors.paper,
        surfaceTintColor: AppColors.paper,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Image.asset(
          'assets/logo/pactantes.png',
          width: 72,
          height: 26,
          excludeFromSemantics: true,
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: PopupMenuButton<bool>(
              tooltip: strings.moreOptions,
              icon: const Icon(Icons.more_vert, size: 20),
              position: PopupMenuPosition.under,
              onSelected: (_) => unawaited(_translations()),
              itemBuilder: (_) => <PopupMenuEntry<bool>>[
                PopupMenuItem<bool>(
                  value: true,
                  enabled: widget.viewModel.canChangeTranslation,
                  child: Row(
                    children: <Widget>[
                      const Icon(Icons.translate_outlined),
                      const SizedBox(width: 12),
                      Flexible(child: Text(strings.language)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: DecoratedBox(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: BottomNavigationBar(
          currentIndex: 0,
          onTap: (_) {},
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: const Icon(Icons.home_outlined),
              label: strings.home,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.import_contacts_outlined),
              label: strings.bible,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.menu_book_outlined),
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
        top: false,
        bottom: false,
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: CustomScrollView(
              slivers: <Widget>[
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 2, bottom: 4),
                          child: Column(
                            children: <Widget>[
                              Text(
                                'Pactantes',
                                style: text.headlineLarge?.copyWith(
                                  fontSize: 30,
                                  color: AppColors.navy,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                strings.brandSubtitle.toUpperCase(),
                                textAlign: TextAlign.center,
                                style: text.bodyMedium?.copyWith(
                                  fontSize: 11,
                                  letterSpacing: 3,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Center(
                          child: SizedBox(width: 220, child: Divider()),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8, bottom: 8),
                          child: Text(
                            strings.introTitle,
                            textAlign: TextAlign.center,
                            style: text.bodyMedium?.copyWith(
                              fontStyle: FontStyle.italic,
                              fontSize: 14,
                            ),
                          ),
                        ),
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
                          padding: const EdgeInsets.all(24),
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
                          padding: const EdgeInsets.all(16),
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
                      return ReadingSection(
                        items: widget.viewModel.readingItems,
                        onOpen: widget.onOpenReading,
                        title: widget.viewModel.hasReadingProgress
                            ? strings.continueReading
                            : strings.startReading,
                      );
                    },
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                  sliver: SliverToBoxAdapter(
                    child: _BibleEntry(strings: strings),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverToBoxAdapter(
                    child: _LibrarySection(strings: strings),
                  ),
                ),
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 32, 16, 40),
                    child: Column(
                      children: <Widget>[
                        const Divider(),
                        const SizedBox(height: 36),
                        Text(
                          strings.homeScriptureQuote,
                          textAlign: TextAlign.center,
                          style: text.bodyMedium?.copyWith(
                            fontStyle: FontStyle.italic,
                            fontSize: 14,
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          strings.homeScriptureReference,
                          textAlign: TextAlign.center,
                          style: text.bodyMedium?.copyWith(
                            color: AppColors.softRed,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
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
  Widget build(BuildContext context) => HomeAction(
    decoration: BoxDecoration(
      color: AppColors.navy,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: <Widget>[
          const Icon(
            Icons.import_contacts_outlined,
            color: AppColors.surface,
            size: 22,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  strings.bibleTitle,
                  style: const TextStyle(
                    fontSize: 18,
                    color: AppColors.surface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  strings.bibleEdition,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.surface.withValues(alpha: .8),
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, size: 20, color: AppColors.surface),
        ],
      ),
    ),
  );
}

class _LibrarySection extends StatelessWidget {
  const _LibrarySection({required this.strings});
  final AppLocalizations strings;
  @override
  Widget build(BuildContext context) {
    final List<(String, String)> categories = <(String, String)>[
      (strings.confessions, strings.homeConfessionsSummary),
      (strings.catechisms, strings.homeCatechismsSummary),
      (strings.creeds, strings.homeCreedsSummary),
      (strings.documents, strings.homeDocumentsSummary),
    ];
    Widget card((String, String) category) => HomeAction(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              category.$1,
              style: const TextStyle(fontSize: 14, color: AppColors.navy),
            ),
            const SizedBox(height: 10),
            Text(
              category.$2,
              style: const TextStyle(
                fontSize: 12,
                height: 1.4,
                color: AppColors.mutedInk,
              ),
            ),
          ],
        ),
      ),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Text(
                strings.exploreLibrary,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.navy,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    strings.seeAll,
                    textAlign: TextAlign.end,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.softRed,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final bool single =
                constraints.maxWidth < 300 ||
                MediaQuery.textScalerOf(context).scale(14) > 21;
            return Column(
              children: <Widget>[
                for (int i = 0; i < categories.length; i += single ? 1 : 2)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: single
                        ? card(categories[i])
                        : IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Expanded(child: card(categories[i])),
                                const SizedBox(width: 8),
                                Expanded(child: card(categories[i + 1])),
                              ],
                            ),
                          ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}
