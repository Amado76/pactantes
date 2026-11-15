import '../../../../core/bible/bible_book_names.dart';
import '../../../../core/database/reading_database.dart';
import '../../models/reading_content.dart';
import 'reading_content_source.dart';

class HeidelbergReadingContentSource implements ReadingContentSource {
  const HeidelbergReadingContentSource(this._database, this._bookNames);
  final ReadingDatabase _database;
  final BibleBookNames _bookNames;

  @override
  Future<ReadingContent> read(
    String documentId, {
    required String languageCode,
  }) async {
    final List<Map<String, Object?>> rows = await _database.query(
      '''
      SELECT c.canonical_question_number, c.question_number, c.question, c.answer,
        q.lords_day_number, d.label, s.title, c.language_code
      FROM heidelberg_catechism c
      JOIN heidelberg_questions q USING (canonical_question_number)
      JOIN heidelberg_lords_day_labels d USING (language_code)
      JOIN document_sources s USING (document_key)
      WHERE c.language_code = ? ORDER BY c.question_number
    ''',
      <Object?>[languageCode],
    );
    if (rows.isEmpty) throw const ReadingDatabaseException();
    final List<Map<String, Object?>> references = await _database.query('''
      SELECT * FROM heidelberg_scripture_references
      ORDER BY canonical_question_number, reference_number, passage_number
    ''');
    final Map<int, List<String>> referencesByQuestion = <int, List<String>>{};
    for (final Map<String, Object?> reference in references) {
      final int canonical = reference['canonical_question_number']! as int;
      referencesByQuestion
          .putIfAbsent(canonical, () => <String>[])
          .add(_reference(reference, languageCode));
    }
    final List<Map<String, Object?>> canonical = await _database.query(
      'SELECT canonical_question_number FROM heidelberg_questions '
      'ORDER BY canonical_question_number',
    );
    return ReadingContent(
      documentId: documentId,
      title: rows.first['title']! as String,
      languageCode: rows.first['language_code']! as String,
      canonicalUnitIds: List<String>.unmodifiable(
        canonical.map(
          (Map<String, Object?> row) =>
              'question-${row['canonical_question_number']}',
        ),
      ),
      units: List<ReadingUnit>.unmodifiable(
        rows.map((Map<String, Object?> row) {
          final int canonical = row['canonical_question_number']! as int;
          final int day = row['lords_day_number']! as int;
          return ReadingUnit(
            id: 'question-$canonical',
            number: row['question_number']! as int,
            question: row['question']! as String,
            body: row['answer']! as String,
            parentId: 'lords-day-$day',
            parentTitle: '${row['label']} $day',
            references: List<String>.unmodifiable(
              referencesByQuestion[canonical] ?? <String>[],
            ),
          );
        }),
      ),
    );
  }

  String _reference(Map<String, Object?> row, String language) {
    final String code = row['book_code']! as String;
    final String book = _bookNames.name(code, languageCode: language);
    final int start = row['chapter_start']! as int;
    final int end = row['chapter_end']! as int;
    final int? verse = row['verse_start'] as int?;
    final int? lastVerse = row['verse_end'] as int?;
    if (verse == null) return '$book $start${end == start ? '' : '–$end'}';
    if (end != start) return '$book $start:$verse–$end:$lastVerse';
    if (lastVerse != verse) return '$book $start:$verse–$lastVerse';
    return '$book $start:$verse';
  }
}
