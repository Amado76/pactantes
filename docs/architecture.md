# Pactantes Frontend Architecture

## Approach

Flutter mobile-first, feature-first, with proportional complexity. Avoid adding backend architecture into the Flutter repository; the server, if built, can live in a separate repository.

Typical flow:

```text
View → ViewModel → LocalRepository interface → local implementation → storage interface → package adapter
                 → RemoteRepository interface (when needed) → remote implementation → HttpClient → DioHttpClient → Dio
```

Use `View → ViewModel → Service → Repository` only for real cross-feature coordination. No controllers between Views and ViewModels. Implement the required repository and package boundaries without adding speculative layers.

## Responsibilities

- **Models:** typed, preferably immutable data. Keep scripture/document identity, edition, chapter/section and reference metadata explicit.
- **Views:** widget layout, responsive composition, localized strings, state rendering and user action forwarding only.
- **ViewModels:** `ChangeNotifier` by default; initialization, search state, retries, reading navigation state and user-facing errors.
- **Services:** cross-repository workflows only when needed, e.g. a future `ReadingSyncService` or `SessionService`.
- **Repositories:** provide focused interfaces for content retrieval, preferences, progress, and remote API mapping. Every implemented data feature has a local repository; add a separate remote repository only when needed. Local implementations own persistence, and remote implementations own remote retrieval and mapping.

## SOLID and dependency boundaries

- **Single responsibility:** Views render, ViewModels manage presentation state, Services coordinate workflows when needed, repositories handle a specific data concern, and infrastructure adapters integrate packages.
- **Open/closed:** add implementations behind established contracts when behavior varies; do not introduce unused extension points.
- **Liskov substitution:** implementations honor their interface semantics, including ordering, failure behavior, and offline guarantees. A remote-only implementation cannot substitute for a contract promising offline reads.
- **Interface segregation:** define small interfaces around consumer needs. Avoid a universal repository, generic CRUD requirements, or storage/client contracts that force callers to depend on unrelated capabilities.
- **Dependency inversion:** higher layers depend on application-owned interfaces. Constructor injection supplies repository and infrastructure implementations; concrete packages remain at the infrastructure boundary.

## Local and remote repositories

- Define a local repository interface for every implemented data feature, for example `BibleLocalRepository` with `BibleLocalRepositoryImpl` as its implementation. Add `BibleRemoteRepository` and its implementation only if that feature needs a remote API. Apply the same naming pattern to documents, search, and other persisted features.
- Use the singular `repository/` folder. Keep each repository interface and its implementation in the same file, named after the interface in snake_case (for example, `reading_progress_local_repository.dart`). Name contracts `<Feature>LocalRepository` or `<Feature>RemoteRepository` and their implementations `<Feature>LocalRepositoryImpl` or `<Feature>RemoteRepositoryImpl`, such as `ReadingProgressLocalRepositoryImpl`.
- Inject these contracts into the consuming ViewModel or coordinating Service. Keep methods specific to the feature and consumer; read-only repositories do not need write methods.
- Keep local and remote contracts separate where their capabilities or guarantees differ. Use a shared narrow interface only when the implementations genuinely satisfy the same contract.
- When a feature needs synchronization or fallback, put that coordination in a focused Service. A local repository must not silently make network requests, and a remote repository must not own local persistence.

## External-package interfaces

- Wrap each external infrastructure package behind an application-owned interface. Repository, Service, and ViewModel contracts must not expose package-specific classes, return types, or exceptions.
- Define `HttpClient` as the HTTP contract and implement it with `DioHttpClient`. Inject the configured `Dio` instance into `DioHttpClient` through its constructor at the composition root. Only `DioHttpClient` calls Dio directly; remote repositories receive `HttpClient`, never `Dio`.
- Define only the HTTP operations consumers need. Translate Dio response/error types into application-owned results and failures inside `DioHttpClient`. Do not add a redundant `ApiClient` wrapper just to forward requests.
- Local repositories receive a focused database/storage interface. Its SQLite-backed adapter receives the chosen package database handle and is the only implementation that calls that package. Apply the same pattern to preferences and secure storage when used.
- Keep interfaces independent of their concrete adapters. Bind each interface to its implementation through GetIt at `app/` composition boundaries; use fakes implementing those interfaces when testing consumers.

Example composition when HTTP is needed: create a configured `Dio`, inject it into `DioHttpClient`, register that implementation as `HttpClient`, then inject `HttpClient` into the remote repository. Register the repository under its own interface and inject that interface into its consumer.

## Dependency injection and state

Use constructor injection and GetIt at `app/` composition boundaries. ViewModels are created per owning screen and disposed with it. Do not use GetIt directly from domain models, Views, or ViewModels. Prefer Flutter native `ChangeNotifier`, `ListenableBuilder`, `ValueListenableBuilder`; avoid a new state management framework absent a concrete requirement.

## Data and search

- Bible, confessions, catechisms, creeds, and other included historical texts are read offline from one bundled SQLite database file. Include only editions whose rights permit the intended offline distribution, and retain required attribution and provenance.
- Prefer stable identifiers for edition, book, chapter, verse, document, section, and language. Do not infer passage identity from rendered strings.
- Use focused local repository contracts such as `BibleLocalRepository`, `DocumentLocalRepository`, `SearchLocalRepository`, and `ReadingProgressLocalRepository` as their features are implemented. Add corresponding remote contracts only for actual remote requirements.
- Use deterministic reference parsing and SQLite full-text search over the local reading database. Reading, reference navigation, and basic keyword search must work in airplane mode from the first launch, without sign-in or content downloads. Future remote search is optional and must preserve local search.
- Remote repositories use the application-owned `HttpClient` interface. Its `DioHttpClient` implementation receives Dio by constructor injection and maps transport errors before they leave the adapter.
- SQLite is the required storage for the reading corpus and its full-text indexes. Use shared preferences for simple settings and secure storage for credentials when authentication exists. Keep mutable reading progress and bookmarks separate from replaceable content tables so content updates cannot erase them.
- Preserve backward compatibility between installed mobile versions and server APIs.

## Offline reading database

- Package the approved corpus as a versioned SQLite asset, for example `assets/database/pactantes.sqlite`, and copy it to an application-local path on first launch. Initialization must not require a server.
- Store Bible editions, books, chapters, verses, historical documents, sections, source metadata, attribution, and full-text indexes in this single content database. Use stable IDs and explicit ordering.
- Local repositories query the content database through an injected database interface. The SQLite adapter encapsulates the selected package API and receives its database handle through constructor injection. Choose the Flutter SQLite package when implementation begins; no package is selected by this document.
- Preserve canonical text exactly. Normalize search queries and index terms without rewriting the displayed source text.
- Track content/schema versions. Validate a replacement database before switching to it, preserve user data, and retain the installed corpus if an optional update fails.
- Distinguish database initialization or integrity failures from network availability. An offline device must still be able to read and search installed content.

## Suggested structure (grow incrementally)

```text
lib/
  app/
    bootstrap.dart
    dependency_injection/
  core/
    network/          # when API integration exists
    preferences/      # when persisted settings exist
    auth/             # when accounts are implemented
  design_system/
    theme/
    components/
  features/
    home/
      views/
      view_models/
    bible/
      models/
      repository/
      views/
      view_models/
    library/
      models/
      repository/
      views/
      view_models/
    reader/
      views/
      view_models/
    search/
      models/
      repository/
      views/
      view_models/
    community/        # only when implemented
  l10n/
    generated/
```

This is a direction, not a requirement to create empty folders. Tests mirror implemented feature paths.

## Localization

Use Flutter gen-l10n with `flutter_localizations` and `intl`. English is the ARB template (`lib/l10n/app_en.arb`); add matching keys in `app_pt.arb` and `app_es.arb`. Run `flutter gen-l10n` after editing translations. Generated Dart files live in `lib/l10n/generated/` and must not be edited manually.

Read UI strings through `AppLocalizations.of(context)` from a context below `MaterialApp`. Keep `locale` unset so Flutter follows the device preferred languages and responds to language changes. The supported order in `l10n.yaml` is Portuguese, English, Spanish; Portuguese is the fallback when no preferred language is supported. Language-only locales accept regional variants such as `pt-BR`, `pt-PT`, `en-US`, and `es-PY`. Keep iOS `CFBundleLocalizations` aligned with the supported languages. Translations are bundled and require no network or authentication.

This config localizes the interface; it does not translate or alter the licensed reading corpus.

## Community boundaries (future)

Separate public church profiles from member-only information. Account identity, church membership, admin permissions, prayer request visibility and birthday visibility must be authorized server-side. Never rely on a hidden Flutter button as access control. Do not invent API routes or fields; document contracts once the backend exists.

## Shared document catalog

The read-only `DocumentCatalogLocalRepository` in `core/library` owns metadata lookup, availability, type filtering, and collection membership. `DocumentCatalogLocalRepositoryImpl` registers the five initial Spanish resources with stable IDs. Collection queries return the existing member objects by `collectionId`; a collection is not additional reading content. Westminster Standards has a stable collection ID without adding an unrequested sixth catalog entry. Unknown unit counts are null. Edition-specific totals and Lord's Day groupings are resolved by the reader repository.

The bundled English, Portuguese, and Spanish Heidelberg editions are available through the offline reader, selected by the resolved device language or a saved reader translation choice. Other resources remain catalog previews. Reader totals, source numbering, canonical question IDs, Lord's Day groups, and references come from the bundled SQLite corpus; the catalog does not guess edition-specific counts. The reader resolves source titles and content from the matching bundled edition without translating the source text. See [Reader](reader.md) for the implementation and persistence boundaries.

## Home reading-progress contract

Home reads the `reading_progress` SharedPreferences string through an injected, read-only `PreferencesReader` adapter and `ReadingProgressLocalRepository`. Home and reader share the model, serialization, validation, and key through `core/reading_progress`; their local repository interfaces remain focused on each consumer. The JSON may contain one object or a list. Valid records require nonempty `documentId` and `sectionId`, a positive integer `paragraph`, a finite numeric `progress`, and a parseable ISO `lastReadAt` string. An optional `sectionTitle` describes the saved position; otherwise Home shows the paragraph. Persisted document titles are ignored: the catalog is the source of truth. Older records containing document titles remain compatible. `progress` is a fraction (`0.68` means 68%) and is clamped to 0–1 for presentation. Nothing is seeded or written by Home.

The Home ViewModel resolves saved IDs through the catalog and ignores invalid, unknown, unavailable, or collection records. When valid progress exists it supplies continuing items; otherwise it supplies available individual documents to the same reading carousel. Per the requested presentational Home behavior, when no readable documents exist it falls back to registered individual catalog previews, without changing `isAvailable` or enabling navigation. Collections are excluded to avoid duplicating their member content. These previews are metadata, not readable content or saved progress.

Progress loading distinguishes missing or malformed saved data from storage failures. The preferences adapter translates storage exceptions into an application-owned failure. Home exposes loading and recoverable error states and allows retry on the same ViewModel, while preventing concurrent reads.

## Home edition preview

Home optionally receives the reader content and preference repository interfaces at composition. It resolves the saved translation or device language, then hydrates available reading cards with the actual source title and current unit. The View renders this data and forwards resume actions; it never queries SQLite or preferences directly. Changing translation from Home refreshes the preview while preserving appearance settings.
