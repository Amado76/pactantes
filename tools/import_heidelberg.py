"""Import the supplied Heidelberg PDFs into the bundled offline database.

Requires pdfplumber. See docs/heidelberg-database.md for usage and source notes.
"""

import argparse
import collections
import hashlib
import os
import re
import sqlite3
import tempfile
from pathlib import Path

import pdfplumber

def normalize(text):
    return re.sub(r'\s+', ' ', text).strip()

def english(path):
    rows = []
    day, current, mode = 0, None, None
    with pdfplumber.open(path) as pdf:
        for page_no, page in enumerate(pdf.pages, 1):
            for line in page.extract_text_lines(x_tolerance=.5):
                text = line['text']
                sizes = collections.Counter(round(c['size'], 1) for c in line['chars'])
                size = sizes.most_common(1)[0][0]
                # Printed page numbers and running headers are outside the text area.
                if line['top'] < 35 or line['top'] > 585:
                    continue
                if match := re.fullmatch(r'LORD’S DAY (\d+)', text):
                    day = int(match[1])
                    continue
                if match := re.match(r'(\d+)\. Q\.\s*(.*)', text):
                    current = dict(
                        question_number=int(match[1]), lords_day_number=day,
                        question=[match[2]], answer=[], references=[],
                        source_page_start=page_no, source_page_end=page_no,
                    )
                    rows.append(current)
                    mode = 'question'
                    continue
                font = collections.Counter(c['fontname'] for c in line['chars']).most_common(1)[0][0]
                # The first question uses 10pt body text; headings use bold faces.
                is_body_type = font.endswith(('Times-Roman', 'Times-Italic'))
                if current is None or (size >= 10 and not is_body_type):
                    continue
                # Footnote type sizes distinguish the apparatus from numbered answer lists.
                if size in (7, 4.2):
                    marker = ''.join(c['text'] for c in line['chars'] if round(c['size'], 1) == 4.2)
                    if marker:
                        if not marker.isdigit():
                            raise ValueError(f'Invalid footnote marker on page {page_no}: {text}')
                        current['references'].append(dict(
                            number=int(marker), text=text[len(marker):].lstrip(),
                            page_start=page_no, page_end=page_no,
                        ))
                    else:
                        if not current['references']:
                            raise ValueError(f'Footnote continuation without a note on page {page_no}')
                        current['references'][-1]['text'] += ' ' + text
                        current['references'][-1]['page_end'] = page_no
                    mode = 'references'
                else:
                    if text.startswith('A. '):
                        text, mode = text[3:], 'answer'
                    if mode not in ('answer', 'question'):
                        raise ValueError(f'Unexpected text on page {page_no}: {text}')
                    if size == 5.4:
                        current[mode][-1] += text
                    else:
                        current[mode].append(text)
                current['source_page_end'] = page_no
    for row in rows:
        for key in ('question', 'answer'):
            row[key] = normalize(' '.join(row[key]))
        for ref in row['references']:
            ref['text'] = normalize(ref['text'])
        numbers = [ref['number'] for ref in row['references']]
        if numbers != list(range(1, len(numbers) + 1)):
            raise ValueError(f'Unexpected note sequence for question {row["question_number"]}')
    if [row['question_number'] for row in rows] != list(range(1, 130)):
        raise ValueError('Expected English questions 1–129')
    return rows

def portuguese(path):
    text, page_at = source_text(path)
    matches = list(re.finditer(r'(?m)^P\.\s*(\d+)\.\s*', text))
    rows = []
    for index, match in enumerate(matches):
        end = matches[index + 1].start() if index + 1 < len(matches) else len(text)
        chunk = text[match.end():end]
        question, answer = re.split(r'\bR\.\s*', chunk, maxsplit=1)
        ref = re.search(r'(?<!\d)1\.\s*(?=[123]?[A-Za-zÀ-ÿ])', answer)
        # Question 23 numbers the Creed's articles; they are not footnotes.
        if int(match[1]) == 23:
            ref = None
        body = answer[:ref.start()] if ref else re.split(
            r'\n(?:Dia do Senhor|O Catecismo|Parte )', answer,
        )[0]
        rows.append(dict(
            question_number=int(match[1]), question=normalize(question), answer=normalize(body),
            source_page_start=page_at(match.start()),
            source_page_end=page_at(match.end() + chunk.index('R.') + 2 + len(body)),
        ))
    if [row['question_number'] for row in rows] != list(range(1, 130)):
        raise ValueError('Expected Portuguese questions 1–129')
    return rows

def source_text(path):
    with pdfplumber.open(path) as pdf:
        pages = [page.extract_text(x_tolerance=.5) for page in pdf.pages]
    text, offsets = '', []
    for number, page in enumerate(pages, 1):
        offsets.append((len(text), number))
        text += page + '\n'

    def page_at(position):
        return max(number for start, number in offsets if start <= position)

    return text, page_at


def spanish(path):
    text, page_at = source_text(path)
    matches = list(re.finditer(r'(?m)^(\d+)\.\s*Pregunta:\s*', text))
    rows = []
    for index, match in enumerate(matches):
        end = matches[index + 1].start() if index + 1 < len(matches) else len(text)
        chunk = text[match.end():end]
        question, answer = re.split(r'Respuesta:\s*', chunk, maxsplit=1)
        answer = re.split(
            r'\n(?:De Dios Padre|De Dios Hijo|De Dios Espíritu Santo|De los Sacramentos|'
            r'Del Santo Bautismo|De la Santa Cena de Nuestro Señor|De la Gratitud|'
            r'De la Ley|Oración|La Redención del Hombre|Used by permission)', answer,
        )[0]
        rows.append(dict(
            question_number=int(match[1]), question=normalize(question), answer=normalize(answer),
            source_page_start=page_at(match.start()),
            source_page_end=page_at(match.end() + chunk.index('Respuesta:') + len('Respuesta:') + len(answer)),
        ))
    if [row['question_number'] for row in rows] != list(range(1, 129)):
        raise ValueError('Expected Spanish questions 1–128')
    return rows


BOOK_CODES = {
    'Gen': 'Gen', 'Ex': 'Exod', 'Lev': 'Lev', 'Num': 'Num', 'Deut': 'Deut',
    'Josh': 'Josh', '1 Sam': '1Sam', '2 Sam': '2Sam', '1 Kings': '1Kgs',
    '2 Kings': '2Kgs', '1 Chron': '1Chr', '2 Chron': '2Chr', 'Job': 'Job',
    'Ps': 'Ps', 'Prov': 'Prov', 'Eccles': 'Eccl', 'Is': 'Isa', 'Jer': 'Jer',
    'Ezek': 'Ezek', 'Dan': 'Dan', 'Joel': 'Joel', 'Mic': 'Mic', 'Nahum': 'Nah',
    'Hab': 'Hab', 'Zech': 'Zech', 'Mt': 'Matt', 'Mk': 'Mark', 'Lk': 'Luke',
    'Jn': 'John', 'Acts': 'Acts', 'Rom': 'Rom', '1 Cor': '1Cor', '2 Cor': '2Cor',
    'Gal': 'Gal', 'Eph': 'Eph', 'Phil': 'Phil', 'Col': 'Col',
    '1 Thess': '1Thess', '2 Thess': '2Thess', '1 Tim': '1Tim', '2 Tim': '2Tim',
    'Tit': 'Titus', 'Titus': 'Titus', 'Heb': 'Heb', 'Jas': 'Jas',
    '1 Pet': '1Pet', '2 Pet': '2Pet', '1 Jn': '1John', '2 Jn': '2John',
    'Jude': 'Jude', 'Rev': 'Rev',
}
BOOK_PATTERN = re.compile(
    r'^(' + '|'.join(re.escape(book) for book in sorted(BOOK_CODES, key=len, reverse=True))
    + r')\s+(.*)$'
)
ENGLISH_URL = 'https://www.heidelberg-catechism.com/pdf/lords-days/Heidelberg-Catechism.pdf'
PORTUGUESE_URL = (
    'https://www.heidelberg-catechism.com/pdf/lords-days/'
    'O%20CATECISMO%20DE%20HEIDELBERG%20(Portuguese).pdf'
)


def parse_passages(citation):
    """Keep book/chapter context in abbreviated lists; emit language-neutral OSIS codes."""
    text = citation.rstrip('.').replace('(', ';').replace(')', ';')
    text = text.replace(' and ', ';')
    book = None
    passages = []
    for part in text.split(';'):
        part = part.strip()
        if not part:
            continue
        if match := BOOK_PATTERN.fullmatch(part):
            book = BOOK_CODES[match[1]]
            part = match[2]
        if book is None:
            raise ValueError(f'Missing reference book: {citation}')
        chapter = None
        for item in part.split(','):
            if match := BOOK_PATTERN.fullmatch(item.strip()):
                book = BOOK_CODES[match[1]]
                item = match[2]
                chapter = None
            item = re.sub(r'\s+', '', item)
            if match := re.fullmatch(r'(\d+):(\d+)(?:-(?:(\d+):)?(\d+))?', item):
                chapter, verse = int(match[1]), int(match[2])
                end_chapter = int(match[3]) if match[3] else chapter
                end_verse = int(match[4]) if match[4] else verse
                passages.append((book, chapter, verse, end_chapter, end_verse))
            elif match := re.fullmatch(r'(\d+)(?:-(\d+))?', item):
                start = int(match[1])
                end = int(match[2]) if match[2] else start
                if chapter is None:
                    passages.append((book, start, None, end, None))
                else:
                    passages.append((book, chapter, start, chapter, end))
            else:
                raise ValueError(f'Unrecognized reference {item!r} in {citation!r}')
    return passages


def section_for(number, language):
    if number <= 2:
        return {'en': 'Introduction', 'pt': 'Introdução'}[language]
    if number <= 11:
        return {'en': 'Our Sin and Misery', 'pt': 'Nossos Pecados e Miséria'}[language]
    if number <= 85:
        return {'en': 'Our Deliverance', 'pt': 'Nossa Salvação'}[language]
    return {'en': 'Our Thankfulness', 'pt': 'A Nossa Gratidão'}[language]


def reference_groups(row):
    if row['references']:
        return [dict(ref, kind='footnote') for ref in row['references']]
    # Questions 71 and 77 cite Scripture in the answer rather than in footnotes.
    return [
        dict(number=number, text=text, kind='inline',
             page_start=row['source_page_start'], page_end=row['source_page_end'])
        for number, text in enumerate(re.findall(r'\(([^()]+)\)', row['answer']), 1)
    ]


def validate(db, translations):
    if db.execute('PRAGMA integrity_check').fetchone()[0] != 'ok':
        raise ValueError('Database integrity check failed')
    if db.execute('PRAGMA foreign_key_check').fetchall():
        raise ValueError('Database foreign keys failed')
    expected = {'en': 129, 'pt': 129, 'es': 128}
    counts = dict(db.execute(
        'SELECT language_code, count(*) FROM heidelberg_catechism GROUP BY language_code'
    ))
    if counts != expected:
        raise ValueError(f'Unexpected translation counts: {counts}')
    if db.execute('SELECT count(DISTINCT lords_day_number) FROM heidelberg_questions').fetchone()[0] != 52:
        raise ValueError('Expected all 52 Lord\'s Days')
    without_references = [row[0] for row in db.execute('''
        SELECT canonical_question_number FROM heidelberg_questions
        EXCEPT SELECT canonical_question_number FROM heidelberg_reference_groups
        ORDER BY canonical_question_number
    ''')]
    if without_references != [23, 24]:
        raise ValueError(f'Unexpected questions without source references: {without_references}')
    for language, rows in translations.items():
        for row in rows:
            actual = db.execute('''
                SELECT question, answer FROM heidelberg_catechism
                WHERE language_code = ? AND question_number = ?
            ''', (language, row['question_number'])).fetchone()
            if actual != (row['question'], row['answer']):
                raise ValueError(f'Text mismatch: {language} {row["question_number"]}')
    # The FTS docid must identify the translation, not the shared question.
    mismatch = db.execute('''
        SELECT count(*) FROM heidelberg_catechism c
        LEFT JOIN heidelberg_catechism_search s ON s.docid = c.id
        WHERE s.docid IS NULL OR c.question != s.question
            OR c.answer != s.answer OR c.section != s.section
    ''').fetchone()[0]
    if mismatch or db.execute('SELECT count(*) FROM heidelberg_catechism_search').fetchone()[0] != 386:
        raise ValueError('Full-text index differs from the translations')
    db.execute("INSERT INTO heidelberg_catechism_search(heidelberg_catechism_search) VALUES ('integrity-check')")
    for language, term in [('en', 'comfort'), ('pt', 'consolo'), ('es', 'consuelo')]:
        if not db.execute('''
            SELECT c.id FROM heidelberg_catechism_search s
            JOIN heidelberg_catechism c ON c.id = s.docid
            WHERE heidelberg_catechism_search MATCH ? AND c.language_code = ?
        ''', (term, language)).fetchone():
            raise ValueError(f'Offline search failed: {language}')


def import_database(database, english_pdf, portuguese_pdf, spanish_pdf):
    translations = {'en': english(english_pdf), 'pt': portuguese(portuguese_pdf),
                    'es': spanish(spanish_pdf)}
    with sqlite3.connect(f'{database.resolve().as_uri()}?mode=ro', uri=True) as original:
        sources = original.execute('SELECT * FROM document_sources').fetchall()
        spanish_source = next(row for row in sources if row[2] == 'es')
        if hashlib.sha256(spanish_pdf.read_bytes()).hexdigest() != spanish_source[4]:
            raise ValueError('The Spanish PDF differs from the existing database source')
        sections = dict(original.execute(
            "SELECT question_number, section FROM heidelberg_catechism WHERE language_code = 'es'"
        ))
        handle, temporary = tempfile.mkstemp(suffix='.db', dir=database.parent)
        os.close(handle)
        try:
            with sqlite3.connect(temporary) as db:
                original.backup(db)
                db.execute('PRAGMA foreign_keys = ON')
                # Rebuild only the Heidelberg corpus; keep unrelated content intact.
                db.execute('DROP TABLE heidelberg_catechism_search')
                db.execute('DROP TABLE heidelberg_catechism')
                for table in ('heidelberg_scripture_references', 'heidelberg_reference_groups',
                              'heidelberg_questions', 'heidelberg_lords_day_labels'):
                    db.execute(f'DROP TABLE IF EXISTS {table}')
                schema = Path(__file__).with_name('heidelberg_schema.sql').read_text()
                db.executescript(schema)
                db.executemany('INSERT INTO heidelberg_lords_day_labels VALUES (?, ?)', [
                    ('en', 'Lord’s Day'), ('pt', 'Dia do Senhor'), ('es', 'Día del Señor'),
                ])
                db.executemany('INSERT INTO heidelberg_questions VALUES (?, ?)', [
                    (row['question_number'], row['lords_day_number']) for row in translations['en']
                ])
                for language, pdf, url, title in (
                    ('en', english_pdf, ENGLISH_URL, 'The Heidelberg Catechism'),
                    ('pt', portuguese_pdf, PORTUGUESE_URL, 'O Catecismo de Heidelberg'),
                ):
                    db.execute('INSERT OR REPLACE INTO document_sources VALUES (?, ?, ?, ?, ?, ?, ?, ?)', (
                        f'heidelberg_catechism_{language}', title, language,
                        url.rsplit('/', 1)[1].replace('%20', ' '),
                        hashlib.sha256(pdf.read_bytes()).hexdigest(),
                        ('Book of Praise, Heidelberg Catechism, pp. 519–558; '
                         if language == 'en' else 'O Catecismo de Heidelberg, Portuguese PDF; ')
                        + 'source supplied by the user; hosted by heidelberg-catechism.com; '
                        'no redistribution license stated in the supplied PDF.', url, 2 if language == 'en' else 1,
                    ))
                for language, rows in translations.items():
                    for row in rows:
                        number = row['question_number']
                        canonical = number + 1 if language == 'es' and number >= 80 else number
                        db.execute('''
                            INSERT INTO heidelberg_catechism (
                                question_number, canonical_question_number, question, answer,
                                section, language_code, source_page_start, source_page_end, document_key
                            ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
                        ''', (number, canonical, row['question'], row['answer'],
                              sections[number] if language == 'es' else section_for(number, language),
                              language, row['source_page_start'], row['source_page_end'],
                              spanish_source[0] if language == 'es' else f'heidelberg_catechism_{language}'))
                db.execute("UPDATE document_sources SET content_version = 2 WHERE language_code = 'es' AND document_key = ?",
                           (spanish_source[0],))
                for row in translations['en']:
                    for group in reference_groups(row):
                        key = (row['question_number'], group['number'])
                        db.execute('INSERT INTO heidelberg_reference_groups VALUES (?, ?, ?, ?, ?, ?, ?)',
                                   (*key, group['kind'], group['text'], group['page_start'],
                                    group['page_end'], 'heidelberg_catechism_en'))
                        db.executemany('INSERT INTO heidelberg_scripture_references VALUES (?, ?, ?, ?, ?, ?, ?, ?)', [
                            (*key, number, *passage)
                            for number, passage in enumerate(parse_passages(group['text']), 1)
                        ])
                db.execute('''
                    INSERT INTO heidelberg_catechism_search(docid, question, answer, section)
                    SELECT id, question, answer, section FROM heidelberg_catechism ORDER BY id
                ''')
                db.execute('PRAGMA user_version = 2')
                validate(db, translations)
                db.commit()
            os.replace(temporary, database)
        finally:
            if os.path.exists(temporary):
                os.unlink(temporary)
    print('Imported en=129, pt=129, es=128; 52 Lord\'s Days; integrity and offline search verified.')


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--database', type=Path, required=True)
    parser.add_argument('--english', type=Path, required=True)
    parser.add_argument('--portuguese', type=Path, required=True)
    parser.add_argument('--spanish', type=Path, required=True)
    args = parser.parse_args()
    import_database(args.database, args.english, args.portuguese, args.spanish)
