import 'package:flutter/foundation.dart';

import '../models/reading_content.dart';
import '../services/reading_share_formatter.dart';
import '../models/reader_preferences.dart';
import '../repository/reader_content_local_repository.dart';
import '../repository/reader_preferences_local_repository.dart';
import '../repository/reader_favorites_local_repository.dart';
import '../repository/reader_progress_local_repository.dart';

enum ReaderState { loading, ready, error }

class ReaderViewModel extends ChangeNotifier {
  ReaderViewModel(
    this._contentRepository,
    this._preferencesRepository,
    this._favoritesRepository,
    this._progressRepository,
  );
  final ReaderContentLocalRepository _contentRepository;
  final ReaderPreferencesLocalRepository _preferencesRepository;
  final ReaderFavoritesLocalRepository _favoritesRepository;
  final ReaderProgressLocalRepository _progressRepository;
  ReadingContent? _content;
  ReadingContent? get content => _content;
  ReaderState state = ReaderState.loading;
  ReaderPreferences preferences = const ReaderPreferences();
  int _index = 0;
  int get index => _index;
  ReadingUnit? get unit => _content?.units[_index];
  bool get hasPrevious => state == ReaderState.ready && _index > 0;
  bool get hasNext =>
      state == ReaderState.ready && _index < _content!.units.length - 1;
  bool favorite = false;
  bool favoriteBusy = false;
  bool favoriteAvailable = false;
  bool _disposed = false;
  int _loadGeneration = 0;
  String _deviceLanguageCode = 'es';
  bool saveError = false;
  Future<void> _writes = Future<void>.value();
  Future<void> get pendingWrites => _writes;

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  Future<void> initialize(
    String documentId, {
    String? unitId,
    String languageCode = 'es',
  }) async {
    final int generation = ++_loadGeneration;
    _deviceLanguageCode = languageCode;
    state = ReaderState.loading;
    saveError = false;
    _notify();
    try {
      final ReaderPreferences restored = await _preferencesRepository.read();
      final ReadingContent content = await _contentRepository.read(
        documentId,
        languageCode: restored.translation.languageCode ?? languageCode,
      );
      if (content.units.isEmpty) throw const FormatException('Empty document');
      final String? savedUnit =
          unitId ?? await _progressRepository.readUnit(documentId);
      if (_disposed || generation != _loadGeneration) return;
      final int savedIndex = content.resolveUnitIndex(savedUnit);
      _content = content;
      preferences = restored;
      _index = savedIndex;
      state = ReaderState.ready;
      await _loadFavorite();
      if (generation == _loadGeneration) _saveProgress();
    } on Exception {
      if (!_disposed && generation == _loadGeneration) {
        state = ReaderState.error;
      }
    } finally {
      if (generation == _loadGeneration) _notify();
    }
  }

  Future<void> changeTranslation(ReaderTranslation translation) async {
    final ReadingContent? current = _content;
    final String? currentUnitId = unit?.id;
    if (state != ReaderState.ready ||
        current == null ||
        preferences.translation == translation) {
      return;
    }
    updatePreferences(preferences.copyWith(translation: translation));
    await pendingWrites;
    if (_disposed) return;
    await initialize(
      current.documentId,
      unitId: currentUnitId,
      languageCode: _deviceLanguageCode,
    );
  }

  Future<void> _loadFavorite() async {
    final ReadingUnit? current = unit;
    if (current == null) return;
    favoriteAvailable = false;
    favorite = false;
    try {
      final bool value = await _favoritesRepository.contains(
        _content!.documentId,
        current.id,
      );
      if (_disposed || unit?.id != current.id) return;
      favorite = value;
      favoriteAvailable = true;
    } on Exception {
      if (!_disposed) saveError = true;
    }
    _notify();
  }

  void select(String unitId) {
    if (state != ReaderState.ready) return;
    final int next = _content!.units.indexWhere(
      (ReadingUnit unit) => unit.id == unitId,
    );
    if (next < 0 || next == _index) return;
    _index = next;
    _notify();
    _loadFavorite();
    _saveProgress();
  }

  void previous() {
    if (hasPrevious) select(_content!.units[_index - 1].id);
  }

  void next() {
    if (hasNext) select(_content!.units[_index + 1].id);
  }

  void _enqueue(Future<void> Function() operation) {
    _writes = _writes.then((_) async {
      try {
        await operation();
      } on Exception {
        saveError = true;
        _notify();
      }
    });
  }

  void updatePreferences(ReaderPreferences value) {
    preferences = value.copyWith();
    final ReaderPreferences snapshot = preferences;
    _notify();
    _enqueue(() => _preferencesRepository.save(snapshot));
  }

  void _saveProgress() {
    final ReadingContent? content = _content;
    final ReadingUnit? current = unit;
    if (content == null || current == null) return;
    final double progress = (_index + 1) / content.units.length;
    _enqueue(
      () => _progressRepository.save(
        documentId: content.documentId,
        unitId: current.id,
        title: current.title ?? current.parentTitle ?? content.title,
        progress: progress,
      ),
    );
  }

  Future<void> toggleFavorite() async {
    if (!favoriteAvailable || favoriteBusy || unit == null) return;
    final ReadingUnit current = unit!;
    final bool value = !favorite;
    favoriteBusy = true;
    _notify();
    try {
      await _favoritesRepository.setFavorite(
        _content!.documentId,
        current.id,
        value,
      );
      if (!_disposed && unit?.id == current.id) favorite = value;
    } on Exception {
      saveError = true;
    } finally {
      favoriteBusy = false;
      _notify();
    }
  }

  String formattedText({
    required String unitLabel,
    required String questionPrefix,
    required String answerPrefix,
    required String referencesLabel,
    required String attribution,
  }) => const ReadingShareFormatter().format(
    document: _content!,
    unit: unit!,
    unitLabel: unitLabel,
    questionPrefix: questionPrefix,
    answerPrefix: answerPrefix,
    referencesLabel: referencesLabel,
    attribution: attribution,
  );

  void clearSaveError() {
    saveError = false;
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
