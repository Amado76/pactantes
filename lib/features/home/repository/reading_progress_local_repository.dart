import 'dart:convert';

import '../../../core/preferences/preferences_reader.dart';
import '../models/reading_progress.dart';

abstract interface class ReadingProgressLocalRepository {
  Future<List<ReadingProgress>> read();
}

class ReadingProgressLocalRepositoryImpl
    implements ReadingProgressLocalRepository {
  const ReadingProgressLocalRepositoryImpl(this._preferences);

  static const String storageKey = 'reading_progress';
  final PreferencesReader _preferences;

  @override
  Future<List<ReadingProgress>> read() async {
    final String? stored = await _preferences.readString(storageKey);
    if (stored == null) return const <ReadingProgress>[];
    try {
      final Object? decoded = jsonDecode(stored);
      final List<Object?> entries = decoded is List<Object?>
          ? decoded
          : <Object?>[decoded];
      return entries
          .map(ReadingProgress.fromJson)
          .whereType<ReadingProgress>()
          .toList(growable: false);
    } on FormatException {
      return const <ReadingProgress>[];
    }
  }
}
