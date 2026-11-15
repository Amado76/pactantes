abstract interface class ReadingDatabase {
  Future<List<Map<String, Object?>>> query(
    String sql, [
    List<Object?> arguments = const <Object?>[],
  ]);
}

class ReadingDatabaseException implements Exception {
  const ReadingDatabaseException();
}
