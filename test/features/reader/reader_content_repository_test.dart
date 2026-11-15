import 'package:flutter_test/flutter_test.dart';
import 'package:pactantes/features/reader/models/reading_content.dart';
import 'package:pactantes/features/reader/repository/reader_content_local_repository.dart';
import 'package:pactantes/features/reader/repository/sources/reading_content_source.dart';
import 'package:pactantes/l10n/localized_bible_book_names.dart';

class StubReadingContentSource implements ReadingContentSource {
  StubReadingContentSource(this.title);
  final String title;

  @override
  Future<ReadingContent> read(
    String documentId, {
    required String languageCode,
  }) async => ReadingContent(
    documentId: documentId,
    title: title,
    languageCode: languageCode,
    units: const <ReadingUnit>[
      ReadingUnit(id: 'article-1', number: 1, title: 'Article I', body: 'Text'),
    ],
  );
}

void main() {
  test(
    'registered document sources determine content without a fixed document ID',
    () async {
      final ReaderContentLocalRepository repository =
          ReaderContentLocalRepositoryImpl(<String, ReadingContentSource>{
            'confession': StubReadingContentSource('Confession'),
            'creed': StubReadingContentSource('Creed'),
          });
      final ReadingContent confession = await repository.read(
        'confession',
        languageCode: 'en-US',
      );
      final ReadingContent creed = await repository.read(
        'creed',
        languageCode: 'pt_BR',
      );
      expect(confession.documentId, 'confession');
      expect(confession.title, 'Confession');
      expect(confession.languageCode, 'en');
      expect(creed.title, 'Creed');
      expect(creed.languageCode, 'pt');
      expect(
        (await repository.read('creed', languageCode: 'fr')).languageCode,
        'pt',
      );
      expect(
        () => repository.read('unknown'),
        throwsA(isA<UnsupportedReadingDocumentException>()),
      );
    },
  );

  test(
    'Bible book names follow the source language and retain unknown codes',
    () {
      const LocalizedBibleBookNames names = LocalizedBibleBookNames();
      expect(names.name('1Cor', languageCode: 'en'), '1 Corinthians');
      expect(names.name('1Cor', languageCode: 'pt'), '1 Coríntios');
      expect(names.name('1Cor', languageCode: 'es'), '1 Corintios');
      expect(names.name('John', languageCode: 'es'), 'Juan');
      expect(names.name('unrecognized', languageCode: 'pt'), 'unrecognized');
    },
  );

  test(
    'canonical restoration uses the preceding unit when no successor exists',
    () {
      const ReadingContent content = ReadingContent(
        documentId: 'sample',
        title: 'Sample',
        languageCode: 'en',
        canonicalUnitIds: <String>['a', 'b', 'c'],
        units: <ReadingUnit>[
          ReadingUnit(id: 'a', number: 1, body: 'A'),
          ReadingUnit(id: 'b', number: 2, body: 'B'),
        ],
      );
      expect(content.resolveUnitIndex('c'), 1);
      expect(content.resolveUnitIndex('a'), 0);
      expect(content.resolveUnitIndex('unknown'), 0);
      expect(content.resolveUnitIndex(null), 0);
    },
  );
}
