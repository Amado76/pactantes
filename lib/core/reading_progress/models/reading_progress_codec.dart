import 'dart:convert';

import 'reading_progress.dart';

abstract final class ReadingProgressCodec {
  static const String storageKey = 'reading_progress';

  static List<ReadingProgress> decode(String? stored) {
    if (stored == null) return <ReadingProgress>[];
    try {
      final Object? decoded = jsonDecode(stored);
      final List<Object?> entries = decoded is List<Object?>
          ? decoded
          : <Object?>[decoded];
      return entries
          .map(ReadingProgress.fromJson)
          .whereType<ReadingProgress>()
          .toList();
    } on FormatException {
      return <ReadingProgress>[];
    }
  }

  static String encode(List<ReadingProgress> records) => jsonEncode(
    records.map((ReadingProgress record) => record.toJson()).toList(),
  );
}
