import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'app/dependency_injection.dart';
import 'design_system/theme/app_theme.dart';
import 'features/home/view_models/home_view_model.dart';
import 'features/home/views/home_view.dart';
import 'features/home/models/home_reading_item.dart';
import 'features/reader/view_models/reader_view_model.dart';
import 'features/reader/views/reader_view.dart';
import 'features/reader/services/reading_actions.dart';
import 'l10n/generated/app_localizations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  registerDependencies(GetIt.instance);
  runApp(
    MainApp(
      createHomeViewModel: () => GetIt.instance<HomeViewModel>(),
      createReaderViewModel: () => GetIt.instance<ReaderViewModel>(),
      readingActions: GetIt.instance<ReadingActions>(),
    ),
  );
}

class MainApp extends StatefulWidget {
  const MainApp({
    required this.createHomeViewModel,
    this.createReaderViewModel,
    this.readingActions,
    super.key,
  });
  final HomeViewModel Function() createHomeViewModel;
  final ReaderViewModel Function()? createReaderViewModel;
  final ReadingActions? readingActions;

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late final HomeViewModel _homeViewModel = widget.createHomeViewModel();

  @override
  void dispose() {
    _homeViewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: AppTheme.light,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Builder(
      builder: (BuildContext context) => HomeView(
        viewModel: _homeViewModel,
        onOpenReading: widget.createReaderViewModel == null
            ? null
            : (HomeReadingItem item) async {
                final ReaderViewModel reader = widget.createReaderViewModel!();
                try {
                  await Navigator.of(context).push<void>(
                    MaterialPageRoute<void>(
                      builder: (_) => ReaderView(
                        viewModel: reader,
                        documentId: item.document.id,
                        documentTitle: item.document.title,
                        initialUnitId: item.progress?.sectionId,
                        onShare: widget.readingActions!.share,
                        onCopy: widget.readingActions!.copy,
                      ),
                    ),
                  );
                } finally {
                  await reader.pendingWrites;
                  reader.dispose();
                  await _homeViewModel.initialize(refresh: true);
                }
              },
      ),
    ),
  );
}
