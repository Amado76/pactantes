import '../models/reading_content.dart';
import 'sources/reading_content_source.dart';

abstract interface class ReaderContentLocalRepository {
  Future<ReadingContent> read(String documentId, {String languageCode = 'es'});
}

class ReaderContentLocalRepositoryImpl implements ReaderContentLocalRepository {
  ReaderContentLocalRepositoryImpl(Map<String, ReadingContentSource> sources)
    : _sources = Map<String, ReadingContentSource>.unmodifiable(sources);

  final Map<String, ReadingContentSource> _sources;

  @override
  Future<ReadingContent> read(
    String documentId, {
    String languageCode = 'es',
  }) async {
    final ReadingContentSource? source = _sources[documentId];
    if (source == null) throw const UnsupportedReadingDocumentException();
    final String requested = languageCode
        .toLowerCase()
        .split(RegExp('[-_]'))
        .first;
    final String language = <String>{'en', 'es', 'pt'}.contains(requested)
        ? requested
        : 'pt';
    return source.read(documentId, languageCode: language);
  }
}

class UnsupportedReadingDocumentException implements Exception {
  const UnsupportedReadingDocumentException();
}
