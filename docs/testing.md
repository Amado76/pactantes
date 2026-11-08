# Testing and Definition of Done

## Test-driven development

Run scripts, tests, and checks only when requested by the user or necessary to complete the authorized task, as required by `AGENTS.md`. Redirect stdout and stderr from every command to a temporary file; inspect the exit code first and extract only relevant excerpts when needed.

For meaningful behavior use Red → Green → Refactor. Prefer small fakes to mocking frameworks when sufficient. Test actual rules and failures, not implementation trivia.

## Coverage priorities

- **Unit:** Bible reference parsing, book aliases, verse-range validation, document ordering, search ranking/filtering, reading progress and ViewModel transitions.
- **Widget:** home layout, bottom navigation, Bible chapter navigation, library category selection, reader text scaling, search results, empty/loading/error/retry, guest access, responsive behavior.
- **Integration:** first-launch database installation, public reading and basic search in airplane mode without authentication, navigation to exact verses/document sections, database initialization failure/retry, content updates preserving user data; search → exact source passage; persisted progress/bookmarks when implemented; authentication/community authorization only after those features exist.
- **Content integrity:** source text matches licensed editions, references point to correct verses/sections, content provenance and required attribution are present.

## Async/error states

Handle initial, loading, success, empty, error, and applicable refreshing/saving states. Show actionable, nontechnical errors; do not display raw Dio exceptions. Never claim progress, bookmark sync, or community submission succeeded before persistence confirms it.

## Definition of Done

A feature is complete when it:

- Meets acceptance criteria and has passing relevant tests.
- Preserves source content accuracy and required licensing/attribution.
- Works for guests when public; never adds unnecessary authentication gates.
- Supports first-launch offline reading and basic search from the bundled SQLite database; optional remote services do not block these features.
- Handles loading, empty, error and retry states.
- Respects mobile safe areas, accessibility, text scaling and the design system.
- Keeps business logic/data access out of Views and credentials out of source.
- Uses null safety, explicit types, `final`/`const` appropriately, and no unjustified dependencies.
- Introduces no relevant warnings and documents any missing backend contract instead of inventing one.
