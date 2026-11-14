import 'package:flutter_test/flutter_test.dart';
import 'package:pactantes/core/library/models/reading_document.dart';
import 'package:pactantes/core/library/repository/document_catalog_local_repository.dart';

void main() {
  const DocumentCatalogLocalRepositoryImpl catalog =
      DocumentCatalogLocalRepositoryImpl();
  test('registers exactly the five initial resources with stable IDs', () {
    expect(catalog.all.map((ReadingDocument document) => document.id), <String>[
      'westminster-confession',
      'heidelberg-catechism',
      'canons-of-dort',
      'belgic-confession',
      'three-forms-of-unity',
    ]);
    expect(
      catalog.all.map((ReadingDocument document) => document.title),
      <String>[
        'Confesión de Fe de Westminster',
        'Catecismo de Heidelberg',
        'Cánones de Dort',
        'Confesión Belga',
        'Las tres formas de unidad',
      ],
    );
    expect(
      catalog.all.map((ReadingDocument document) => document.id).toSet(),
      hasLength(5),
    );
    expect(() => catalog.all.clear(), throwsUnsupportedError);
  });
  test('nothing is readable until structured content and a reader exist', () {
    expect(catalog.available, isEmpty);
    expect(
      catalog.all.every((ReadingDocument document) => !document.isAvailable),
      isTrue,
    );
  });
  test('only Heidelberg has an established unit count', () {
    expect(catalog.findById('heidelberg-catechism')?.totalUnits, 129);
    expect(
      catalog.all.where(
        (ReadingDocument document) => document.totalUnits != null,
      ),
      hasLength(1),
    );
  });
  test('lookup resolves metadata and safely returns null for unknown IDs', () {
    expect(
      catalog.findById('westminster-confession')?.collectionId,
      'westminster-standards',
    );
    expect(catalog.findById('unknown'), isNull);
  });
  test('filters types independently from collections', () {
    expect(catalog.byType(DocumentType.confession), hasLength(3));
    expect(
      catalog.byType(DocumentType.catechism).single.id,
      'heidelberg-catechism',
    );
    expect(
      catalog.byType(DocumentType.collection).single.id,
      'three-forms-of-unity',
    );
    expect(catalog.byType(DocumentType.creed), isEmpty);
    expect(catalog.byType(DocumentType.document), isEmpty);
  });
  test(
    'collection membership references existing entries without duplication',
    () {
      final List<ReadingDocument> members = catalog.inCollection(
        'three-forms-of-unity',
      );
      expect(
        members.map((ReadingDocument document) => document.id).toSet(),
        <String>{'heidelberg-catechism', 'canons-of-dort', 'belgic-confession'},
      );
      expect(members, hasLength(3));
      for (final ReadingDocument member in members) {
        expect(identical(member, catalog.findById(member.id)), isTrue);
        expect(member.type, isNot(DocumentType.collection));
      }
      expect(
        catalog.inCollection('westminster-standards').single.id,
        'westminster-confession',
      );
      expect(catalog.inCollection('unknown'), isEmpty);
    },
  );
}
