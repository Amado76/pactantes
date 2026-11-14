import 'package:pactantes/core/library/models/reading_document.dart';
import 'package:pactantes/core/library/repository/document_catalog_local_repository.dart';

class FakeDocumentCatalog implements DocumentCatalogLocalRepository {
  FakeDocumentCatalog({Set<String> availableIds = const <String>{}})
    : all = List<ReadingDocument>.unmodifiable(
        const DocumentCatalogLocalRepositoryImpl().all.map(
          (ReadingDocument document) => ReadingDocument(
            id: document.id,
            title: document.title,
            type: document.type,
            collectionId: document.collectionId,
            totalUnits: document.totalUnits,
            isAvailable: availableIds.contains(document.id),
          ),
        ),
      );

  @override
  final List<ReadingDocument> all;
  @override
  List<ReadingDocument> get available =>
      all.where((ReadingDocument document) => document.isAvailable).toList();
  @override
  ReadingDocument? findById(String id) {
    for (final ReadingDocument document in all) {
      if (document.id == id) return document;
    }
    return null;
  }

  @override
  List<ReadingDocument> byType(DocumentType type) =>
      all.where((ReadingDocument document) => document.type == type).toList();
  @override
  List<ReadingDocument> inCollection(String collectionId) => all
      .where(
        (ReadingDocument document) => document.collectionId == collectionId,
      )
      .toList();
}
