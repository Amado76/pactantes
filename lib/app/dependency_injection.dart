import 'package:get_it/get_it.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:share_plus/share_plus.dart';

import '../core/database/reading_database.dart';
import '../features/reader/repository/sources/reading_content_source.dart';
import '../features/reader/repository/sources/heidelberg_reading_content_source.dart';
import '../l10n/localized_bible_book_names.dart';
import '../core/database/sqflite_reading_database.dart';
import '../core/preferences/preferences_store.dart';
import '../features/reader/repository/reader_content_local_repository.dart';
import '../features/reader/repository/reader_preferences_local_repository.dart';
import '../features/reader/repository/reader_favorites_local_repository.dart';
import '../features/reader/repository/reader_progress_local_repository.dart';
import '../features/reader/services/reading_actions.dart';
import '../features/reader/services/platform_reading_actions.dart';
import '../features/reader/view_models/reader_view_model.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../core/library/repository/document_catalog_local_repository.dart';
import '../core/preferences/preferences_reader.dart';
import '../core/preferences/shared_preferences_reader.dart';
import '../features/home/repository/reading_progress_local_repository.dart';
import '../features/home/view_models/home_view_model.dart';

void registerDependencies(GetIt container) {
  container.registerLazySingleton<PreferencesStore>(
    () => SharedPreferencesReader(SharedPreferences.getInstance),
  );
  container.registerLazySingleton<PreferencesReader>(
    () => container<PreferencesStore>(),
  );
  container.registerLazySingleton<ReadingDatabase>(
    () => SqfliteReadingDatabase(databaseFactory, rootBundle),
  );
  container.registerLazySingleton<ReaderContentLocalRepository>(
    () => ReaderContentLocalRepositoryImpl(<String, ReadingContentSource>{
      'heidelberg-catechism': HeidelbergReadingContentSource(
        container<ReadingDatabase>(),
        const LocalizedBibleBookNames(),
      ),
    }),
  );
  container.registerLazySingleton<ReaderPreferencesLocalRepository>(
    () => ReaderPreferencesLocalRepositoryImpl(container<PreferencesStore>()),
  );
  container.registerLazySingleton<ReaderFavoritesLocalRepository>(
    () => ReaderFavoritesLocalRepositoryImpl(container<PreferencesStore>()),
  );
  container.registerLazySingleton<ReaderProgressLocalRepository>(
    () => ReaderProgressLocalRepositoryImpl(container<PreferencesStore>()),
  );
  container.registerLazySingleton<ReadingActions>(
    () => PlatformReadingActions(SharePlus.instance),
  );
  container.registerFactory<ReaderViewModel>(
    () => ReaderViewModel(
      container<ReaderContentLocalRepository>(),
      container<ReaderPreferencesLocalRepository>(),
      container<ReaderFavoritesLocalRepository>(),
      container<ReaderProgressLocalRepository>(),
    ),
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
      readerPreferencesRepository:
          container<ReaderPreferencesLocalRepository>(),
      readerContentRepository: container<ReaderContentLocalRepository>(),
    ),
  );
}
