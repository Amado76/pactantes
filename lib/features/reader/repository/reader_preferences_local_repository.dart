import 'dart:convert';

import '../../../core/preferences/preferences_store.dart';
import '../models/reader_preferences.dart';

abstract interface class ReaderPreferencesLocalRepository {
  Future<ReaderPreferences> read();
  Future<void> save(ReaderPreferences preferences);
}

class ReaderPreferencesLocalRepositoryImpl
    implements ReaderPreferencesLocalRepository {
  const ReaderPreferencesLocalRepositoryImpl(this._store);
  final PreferencesStore _store;
  static const String key = 'reader_preferences';
  @override
  Future<ReaderPreferences> read() async {
    final String? raw = await _store.readString(key);
    if (raw == null) return const ReaderPreferences();
    try {
      final Object? value = jsonDecode(raw);
      return value is Map<String, Object?>
          ? ReaderPreferences.fromJson(value)
          : const ReaderPreferences();
    } on FormatException {
      return const ReaderPreferences();
    }
  }

  @override
  Future<void> save(ReaderPreferences preferences) =>
      _store.writeString(key, jsonEncode(preferences.toJson()));
}
