abstract interface class PreferencesReader {
  /// Returns null for missing or invalid values; throws on storage failures.
  Future<String?> readString(String key);
}

class PreferencesReadException implements Exception {
  const PreferencesReadException();
}
