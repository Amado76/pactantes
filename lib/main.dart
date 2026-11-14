import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'app/dependency_injection.dart';
import 'design_system/theme/app_theme.dart';
import 'features/home/view_models/home_view_model.dart';
import 'features/home/views/home_view.dart';
import 'l10n/generated/app_localizations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  registerDependencies(GetIt.instance);
  runApp(MainApp(createHomeViewModel: () => GetIt.instance<HomeViewModel>()));
}

class MainApp extends StatefulWidget {
  const MainApp({required this.createHomeViewModel, super.key});
  final HomeViewModel Function() createHomeViewModel;

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
    home: HomeView(viewModel: _homeViewModel),
  );
}
