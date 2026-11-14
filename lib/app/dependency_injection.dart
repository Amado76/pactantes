import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/library/repository/document_catalog_local_repository.dart';
import '../core/preferences/preferences_reader.dart';
import '../core/preferences/shared_preferences_reader.dart';
import '../features/home/repository/reading_progress_local_repository.dart';
import '../features/home/view_models/home_view_model.dart';

void registerDependencies(GetIt container) {
  container.registerLazySingleton<PreferencesReader>(
    () => SharedPreferencesReader(SharedPreferences.getInstance),
  );
  container.registerLazySingleton<ReadingProgressLocalRepository>(
    () => ReadingProgressLocalRepositoryImpl(container<PreferencesReader>()),
  );
  container.registerLazySingleton<DocumentCatalogLocalRepository>(
    () => const DocumentCatalogLocalRepositoryImpl(),
  );
  container.registerFactory<HomeViewModel>(
    () => HomeViewModel(
      container<ReadingProgressLocalRepository>(),
      container<DocumentCatalogLocalRepository>(),
    ),
  );
}
