import '../models/reading_document.dart';

abstract interface class DocumentCatalogLocalRepository {
  List<ReadingDocument> get all;
  List<ReadingDocument> get available;
  ReadingDocument? findById(String id);
  List<ReadingDocument> byType(DocumentType type);
  List<ReadingDocument> inCollection(String collectionId);
}

class DocumentCatalogLocalRepositoryImpl
    implements DocumentCatalogLocalRepository {
  const DocumentCatalogLocalRepositoryImpl();

  // Availability requires structured content accessible through an integrated reader.
  static const List<ReadingDocument> _documents = <ReadingDocument>[
    ReadingDocument(
      id: 'westminster-confession',
      title: 'Confesión de Fe de Westminster',
      type: DocumentType.confession,
      collectionId: 'westminster-standards',
      isAvailable: false,
    ),
    ReadingDocument(
      id: 'heidelberg-catechism',
      title: 'Catecismo de Heidelberg',
      type: DocumentType.catechism,
      collectionId: 'three-forms-of-unity',
      totalUnits: 129,
      isAvailable: false,
    ),
    ReadingDocument(
      id: 'canons-of-dort',
      title: 'Cánones de Dort',
      type: DocumentType.confession,
      collectionId: 'three-forms-of-unity',
      isAvailable: false,
    ),
    ReadingDocument(
      id: 'belgic-confession',
      title: 'Confesión Belga',
      type: DocumentType.confession,
      collectionId: 'three-forms-of-unity',
      isAvailable: false,
    ),
    ReadingDocument(
      id: 'three-forms-of-unity',
      title: 'Las tres formas de unidad',
      type: DocumentType.collection,
      isAvailable: false,
    ),
  ];

  @override
  List<ReadingDocument> get all => _documents;

  @override
  List<ReadingDocument> get available => List<ReadingDocument>.unmodifiable(
    _documents.where((ReadingDocument document) => document.isAvailable),
  );

  @override
  ReadingDocument? findById(String id) {
    for (final ReadingDocument document in _documents) {
      if (document.id == id) return document;
    }
    return null;
  }

  @override
  List<ReadingDocument> byType(DocumentType type) =>
      List<ReadingDocument>.unmodifiable(
        _documents.where((ReadingDocument document) => document.type == type),
      );

  @override
  List<ReadingDocument> inCollection(String collectionId) =>
      List<ReadingDocument>.unmodifiable(
        _documents.where(
          (ReadingDocument document) => document.collectionId == collectionId,
        ),
      );
}
