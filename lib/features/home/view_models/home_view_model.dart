import 'package:flutter/foundation.dart';

import '../../reader/models/reader_preferences.dart';
import '../../reader/models/reading_content.dart';
import '../../reader/repository/reader_content_local_repository.dart';
import '../../reader/repository/reader_preferences_local_repository.dart';

import '../../../core/library/models/reading_document.dart';
import '../../../core/library/repository/document_catalog_local_repository.dart';
import '../models/home_reading_item.dart';
import '../../../core/reading_progress/models/reading_progress.dart';
import '../repository/reading_progress_local_repository.dart';

enum HomeReadingState { initial, loading, ready, error }

class HomeViewModel extends ChangeNotifier {
  HomeViewModel(
    this._repository,
    this._catalog, {
    this._readerPreferencesRepository,
    this._readerContentRepository,
  }) {
    _readingItems = _suggestions();
  }

  final ReaderContentLocalRepository? _readerContentRepository;
  String _languageCode = 'es';
  final ReadingProgressLocalRepository _repository;
  final DocumentCatalogLocalRepository _catalog;
  List<HomeReadingItem> _readingItems = const <HomeReadingItem>[];
  List<HomeReadingItem> get readingItems => _readingItems;
  bool get hasReadingProgress =>
      _readingItems.any((HomeReadingItem item) => item.progress != null);
  HomeReadingState _readingState = HomeReadingState.initial;
  HomeReadingState get readingState => _readingState;
  bool _disposed = false;
  int _loadGeneration = 0;

  final ReaderPreferencesLocalRepository? _readerPreferencesRepository;
  bool get canChangeTranslation => _readerPreferencesRepository != null;
  ReaderTranslation selectedTranslation = ReaderTranslation.device;

  Future<bool> loadTranslation() async {
    try {
      final ReaderPreferencesLocalRepository? repository =
          _readerPreferencesRepository;
      if (repository == null) return false;
      final ReaderPreferences preferences = await repository.read();
      if (_disposed) return false;
      selectedTranslation = preferences.translation;
      return true;
    } on Exception {
      return false;
    }
  }

  Future<bool> changeTranslation(ReaderTranslation translation) async {
    try {
      final ReaderPreferencesLocalRepository? repository =
          _readerPreferencesRepository;
      if (repository == null) return false;
      // Read the latest settings so changing language preserves reader appearance.
      final ReaderPreferences preferences = await repository.read();
      await repository.save(preferences.copyWith(translation: translation));
      if (_disposed) return false;
      selectedTranslation = translation;
      await initialize(refresh: true);
      return true;
    } on Exception {
      return false;
    }
  }

  List<HomeReadingItem> _suggestions() {
    List<ReadingDocument> documents = _catalog.available
        .where(
          (ReadingDocument document) =>
              document.type != DocumentType.collection,
        )
        .toList();
    // Until a reader exists, registered resources are presentational catalog previews.
    if (documents.isEmpty) {
      documents = _catalog.all
          .where(
            (ReadingDocument document) =>
                document.type != DocumentType.collection,
          )
          .toList();
    }
    return List<HomeReadingItem>.unmodifiable(
      documents.map(
        (ReadingDocument document) => HomeReadingItem(document: document),
      ),
    );
  }

  Future<void> initialize({bool refresh = false, String? languageCode}) async {
    final bool languageChanged =
        languageCode != null && languageCode != _languageCode;
    _languageCode = languageCode ?? _languageCode;
    if (_disposed ||
        (!refresh &&
            !languageChanged &&
            (_readingState == HomeReadingState.loading ||
                _readingState == HomeReadingState.ready))) {
      return;
    }
    final int generation = ++_loadGeneration;
    final String requestedLanguage = _languageCode;
    _readingState = HomeReadingState.loading;
    notifyListeners();
    final List<HomeReadingItem> items = <HomeReadingItem>[];
    try {
      for (final ReadingProgress progress in await _repository.read()) {
        if (!progress.isValid) continue;
        final ReadingDocument? document = _catalog.findById(
          progress.documentId,
        );
        if (document == null ||
            !document.isAvailable ||
            document.type == DocumentType.collection) {
          continue;
        }
        items.add(HomeReadingItem(document: document, progress: progress));
      }
      if (_disposed || generation != _loadGeneration) return;
      final List<HomeReadingItem> candidates = items.isEmpty
          ? _suggestions()
          : items;
      final ReaderPreferences preferences =
          await _readerPreferencesRepository?.read() ??
          const ReaderPreferences();
      final List<HomeReadingItem> hydrated = <HomeReadingItem>[];
      for (final HomeReadingItem item in candidates) {
        if (_readerContentRepository == null || !item.document.isAvailable) {
          hydrated.add(item);
          continue;
        }
        final ReadingContent content = await _readerContentRepository.read(
          item.document.id,
          languageCode:
              preferences.translation.languageCode ?? requestedLanguage,
        );
        if (content.units.isEmpty) {
          throw const FormatException('Empty document');
        }
        final ReadingUnit unit =
            content.units[content.resolveUnitIndex(item.progress?.sectionId)];
        hydrated.add(
          HomeReadingItem(
            document: item.document,
            progress: item.progress,
            unit: unit,
            sourceTitle: content.title,
            languageCode: content.languageCode,
          ),
        );
      }
      if (_disposed || generation != _loadGeneration) return;
      _readingItems = List<HomeReadingItem>.unmodifiable(hydrated);
      _readingState = HomeReadingState.ready;
    } on Exception {
      if (_disposed || generation != _loadGeneration) return;
      _readingState = HomeReadingState.error;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
