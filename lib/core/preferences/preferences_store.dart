import 'preferences_reader.dart';

abstract interface class PreferencesStore implements PreferencesReader {
  Future<void> writeString(String key, String value);
}

class PreferencesWriteException implements Exception {
  const PreferencesWriteException();
}
