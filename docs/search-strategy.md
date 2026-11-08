# Pactantes Search Strategy

## Recommended rollout

### Phase 1 — deterministic, low cost

- Parse Bible references (book aliases, chapter, verse and ranges) with explicit validation and canonical IDs.
- Index approved Bible and historical-document text with SQLite full-text search in the same bundled database file as the reading corpus. Basic search must work offline from the first launch, without a server or authentication.
- Normalize queries for accent/case variations where appropriate, while displaying exact original text.
- Filter by Bible edition, document category, title and language; link results to precise passages/sections.
- Rank reference matches above generic keyword matches. Provide useful empty/no-match states.

### Phase 2 — semantic retrieval, only if justified

Any future remote semantic search is an optional enhancement. It must not replace or block offline reading and basic local search.

- Evaluate multilingual embeddings and vector similarity (e.g. PostgreSQL with pgvector) on a measured query set.
- Return verifiable passages and source identifiers. Never synthesize or alter scripture quotations.
- Test Spanish theological terminology, false positives, hallucination risk and latency/cost before rollout.

### Phase 3 — optional grounded question answering

- Add an LLM only if users demonstrably need natural-language synthesis beyond retrieval.
- Require retrieval-grounded answers, source links, explicit distinction between quotation and AI explanation, and a graceful fallback when confidence is low.
- Compare total costs of hosting (RAM/CPU/GPU, ops, monitoring) against managed APIs. Self-hosting is not automatically cheaper.

## Open decisions

- Exact licensed SBT edition, text format, territory, distribution and offline permissions.
- Canonical historical-document editions and source rights.
- The Flutter SQLite package and supported full-text-search configuration; offline reading and basic search at launch are already required.
- Supported Bible book abbreviations and languages.
- Whether communities require private search and server-side authorization.
