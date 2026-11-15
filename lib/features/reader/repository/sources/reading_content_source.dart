import '../../models/reading_content.dart';

abstract interface class ReadingContentSource {
  Future<ReadingContent> read(
    String documentId, {
    required String languageCode,
  });
}
