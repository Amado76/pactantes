import 'package:flutter/foundation.dart';

import '../../../core/library/models/reading_document.dart';
import '../../../core/library/repository/document_catalog_local_repository.dart';
import '../models/home_reading_item.dart';
import '../../../core/reading_progress/models/reading_progress.dart';
import '../repository/reading_progress_local_repository.dart';

enum HomeReadingState { initial, loading, ready, error }

class HomeViewModel extends ChangeNotifier {
  HomeViewModel(this._repository, this._catalog) {
    _readingItems = _suggestions();
  }

  final ReadingProgressLocalRepository _repository;
  final DocumentCatalogLocalRepository _catalog;
  List<HomeReadingItem> _readingItems = const <HomeReadingItem>[];
  List<HomeReadingItem> get readingItems => _readingItems;
  bool get hasReadingProgress =>
      _readingItems.any((HomeReadingItem item) => item.progress != null);
  HomeReadingState _readingState = HomeReadingState.initial;
  HomeReadingState get readingState => _readingState;
  bool _disposed = false;

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

  Future<void> initialize() async {
    if (_disposed ||
        _readingState == HomeReadingState.loading ||
        _readingState == HomeReadingState.ready) {
      return;
    }
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
      if (_disposed) return;
      _readingItems = items.isEmpty
          ? _suggestions()
          : List<HomeReadingItem>.unmodifiable(items);
      _readingState = HomeReadingState.ready;
    } on Exception {
      if (_disposed) return;
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
