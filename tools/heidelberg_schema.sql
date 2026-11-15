CREATE TABLE heidelberg_questions (
    canonical_question_number INTEGER PRIMARY KEY
        CHECK (canonical_question_number BETWEEN 1 AND 129),
    lords_day_number INTEGER NOT NULL CHECK (lords_day_number BETWEEN 1 AND 52)
);

CREATE TABLE heidelberg_lords_day_labels (
    language_code TEXT PRIMARY KEY,
    label TEXT NOT NULL
);

CREATE TABLE heidelberg_catechism (
    id INTEGER PRIMARY KEY,
    question_number INTEGER NOT NULL CHECK (question_number > 0),
    canonical_question_number INTEGER NOT NULL
        REFERENCES heidelberg_questions(canonical_question_number),
    question TEXT NOT NULL CHECK (length(trim(question)) > 0),
    answer TEXT NOT NULL CHECK (length(trim(answer)) > 0),
    section TEXT NOT NULL,
    language_code TEXT NOT NULL REFERENCES heidelberg_lords_day_labels(language_code),
    source_page_start INTEGER NOT NULL CHECK (source_page_start > 0),
    source_page_end INTEGER NOT NULL CHECK (source_page_end >= source_page_start),
    document_key TEXT NOT NULL REFERENCES document_sources(document_key),
    UNIQUE (language_code, question_number),
    UNIQUE (language_code, canonical_question_number)
);

CREATE TABLE heidelberg_reference_groups (
    canonical_question_number INTEGER NOT NULL
        REFERENCES heidelberg_questions(canonical_question_number),
    reference_number INTEGER NOT NULL CHECK (reference_number > 0),
    reference_kind TEXT NOT NULL CHECK (reference_kind IN ('footnote', 'inline')),
    source_text TEXT NOT NULL,
    source_page_start INTEGER NOT NULL CHECK (source_page_start > 0),
    source_page_end INTEGER NOT NULL CHECK (source_page_end >= source_page_start),
    document_key TEXT NOT NULL REFERENCES document_sources(document_key),
    PRIMARY KEY (canonical_question_number, reference_number)
);

CREATE TABLE heidelberg_scripture_references (
    canonical_question_number INTEGER NOT NULL,
    reference_number INTEGER NOT NULL,
    passage_number INTEGER NOT NULL CHECK (passage_number > 0),
    book_code TEXT NOT NULL,
    chapter_start INTEGER NOT NULL CHECK (chapter_start > 0),
    verse_start INTEGER CHECK (verse_start > 0),
    chapter_end INTEGER NOT NULL CHECK (chapter_end >= chapter_start),
    verse_end INTEGER CHECK (verse_end > 0),
    CHECK ((verse_start IS NULL) = (verse_end IS NULL)),
    CHECK (chapter_end > chapter_start OR verse_end >= verse_start),
    PRIMARY KEY (canonical_question_number, reference_number, passage_number),
    FOREIGN KEY (canonical_question_number, reference_number)
        REFERENCES heidelberg_reference_groups(canonical_question_number, reference_number)
);

CREATE VIRTUAL TABLE heidelberg_catechism_search USING fts4(
    question, answer, section, tokenize=unicode61
);
