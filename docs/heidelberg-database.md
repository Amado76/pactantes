# Heidelberg Catechism database

`assets/db/reformed_documents.db` uses schema version 2. It contains 129 English,
129 Portuguese, and 128 Spanish questions and answers, with an offline FTS4 index.
The Flutter reader installs the corpus revision 3 asset into a separate read-only local file, preserving earlier installed files and mutable user preferences.

## Sources and text

- [English PDF](https://www.heidelberg-catechism.com/pdf/lords-days/Heidelberg-Catechism.pdf),
  Book of Praise, printed pages 519–558 (40 PDF pages).
- [Portuguese PDF](https://www.heidelberg-catechism.com/pdf/lords-days/O%20CATECISMO%20DE%20HEIDELBERG%20(Portuguese).pdf),
  29 PDF pages.
- User-supplied `Catecismo de Heidelberg.pdf`, 16 PDF pages, SHA-256
  `3c269dae25fc1a986f1fa9bae8c662ab5deb0955e9fb06eac6d0c8a8a25e6995`.
  This matches the Spanish source already recorded in the database. Its attribution
  is “Used by permission of the Reformed Church in America”.

`document_sources` records each PDF's hash, URL, attribution, and content version.
PDF page metadata is one-based and refers to the physical PDF page, not the
printed page number. Whitespace and line breaks are normalized; wording, source
spelling, punctuation, numbered lists, and inline reference markers are retained.
Footnote apparatus is separated from answers. The English and Portuguese PDFs do
not state a redistribution license; source metadata records that fact without
asserting permission.

All 128 Spanish questions and answers were compared with the supplied PDF. No
question or answer was missing from that source. Re-extraction repairs four words
previously split by extraction: `cuerpo` (31), `momento` (47), `todopoderoso` (50),
and `temerariamente` (111). Other differences are whitespace around words or
footnote markers. The Spanish content version is now 2.

## Question identity and Lord's Days

`heidelberg_questions` defines the canonical questions 1–129 and their shared
`lords_day_number` (1–52), using the English PDF's division. Localized labels are
stored in `heidelberg_lords_day_labels`: `Lord’s Day`, `Dia do Senhor`, and
`Día del Señor`. Append the shared day number when displaying a heading.

`heidelberg_catechism` stores each translation with its own integer `id`.
`question_number` preserves the source edition's numbering;
`canonical_question_number` links equivalent questions across languages. Both
numbers are unique per language. Existing consumers must now filter by
`language_code`; `question_number` is no longer a global primary key.

The Spanish edition omits canonical question 80 (the comparison of the Lord's
Supper and the papal mass). Spanish 1–79 map to canonical 1–79; Spanish 80–128 map
to canonical 81–129. Its question 80 about admission to the Lord's table is present
and maps to English/Portuguese 81. There is no invented Spanish translation for
canonical 80. This mapping prevents incorrect reference and day assignments after
question 79 while preserving the Spanish edition's numbering.

The Portuguese PDF prints `Dia do Senhor 4` before question 116, where the
English sequence has Lord's Day 45. The shared day metadata uses 45. This source
heading typo does not change the Portuguese question or answer text.

## Shared Scripture references

`heidelberg_reference_groups` preserves the English PDF's numbered footnotes,
their source text, source pages, and provenance. `heidelberg_scripture_references`
stores ordered passages within each group using language-neutral OSIS book codes
and explicit start/end chapters and verses. A null verse represents a whole
chapter or chapter range. Both tables link to the canonical question, so every
translation uses exactly the same references, without per-language copies.

The English PDF is the reference authority for these shared records; Portuguese
footnote typographical differences are not used to create conflicting reference
sets. English abbreviations in `source_text` are provenance, not localized book
labels. Render a reference using `book_code` and the desired language's book names.

Questions 71 and 77 have Scripture citations inside their answers instead of
numbered footnotes. These are also indexed, with `reference_kind = 'inline'`.
Questions 23 (the Creed) and 24 (its division) have no Scripture references in the
supplied PDFs; they intentionally have no reference records. Footnote numbers
identify notes within an edition; they are not universal inline marker positions
across translations.

Example: fetch a Spanish source question with its shared day heading.

```sql
SELECT c.*, d.label || ' ' || q.lords_day_number AS lords_day_title
FROM heidelberg_catechism c
JOIN heidelberg_questions q USING (canonical_question_number)
JOIN heidelberg_lords_day_labels d USING (language_code)
WHERE c.language_code = 'es' AND c.question_number = 80;
```

Fetch that question's shared references by joining on canonical identity:

```sql
SELECT r.*
FROM heidelberg_catechism c
JOIN heidelberg_scripture_references r USING (canonical_question_number)
WHERE c.language_code = 'es' AND c.question_number = 80
ORDER BY r.reference_number, r.passage_number;
```

FTS4 `heidelberg_catechism_search.docid` references the translation's `id`.
Join on that field and filter the translation language when searching offline.

## Rebuilding and validation

Install `pdfplumber==0.11.8` in a temporary Python environment. Download the two
linked PDFs and supply the original Spanish PDF locally, then run:

```sh
python tools/import_heidelberg.py \
  --database assets/db/reformed_documents.db \
  --english /path/to/Heidelberg-Catechism.pdf \
  --portuguese '/path/to/O CATECISMO DE HEIDELBERG (Portuguese).pdf' \
  --spanish '/path/to/Catecismo de Heidelberg.pdf'
```

The importer uses `tools/heidelberg_schema.sql`, preserves unrelated tables and
source records, and replaces the database only after validating a temporary copy.
It verifies source question sequences, note sequences, exact extracted text,
translation counts, all 52 days, reference coverage, SQLite integrity, foreign
keys, FTS integrity and text correspondence, and a real offline search in each
language. The Spanish PDF hash must match the recorded original source.

## English question 1 correction

The first PDF page uses 10-point Times body text, while subsequent pages use smaller type. The importer previously classified all 10-point continuation lines as headings, truncating question 1 and its answer. Body font faces now distinguish that text from bold section headings. The complete English corpus was re-extracted and compared against the asset; only question 1 differed. Its question, full answer, and FTS record are corrected, and the English source content version is 2. The shared reference tables and other translations are unchanged. A synthetic-font regression test covers this distinction.
