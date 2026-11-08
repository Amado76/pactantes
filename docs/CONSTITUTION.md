# Pactantes Frontend Constitution

These principles govern every change to the Pactantes Flutter frontend. This constitution lives at `docs/CONSTITUTION.md`. Read it before every task, then read the relevant focused guide before changing its area.

## Project-wide principles

- Prefer clarity, simplicity, testability, reuse, then extensibility, in that order.
- Solve current requirements without speculative layers, files, or packages. Required repository contracts and external-package interfaces are architectural boundaries, not optional abstractions.
- Apply SOLID across layers: give components one responsibility, extend behavior through focused contracts, preserve substitutability, segregate interfaces by consumer needs, and invert dependencies toward abstractions.
- Keep UI separate from business rules and persistence. Inject dependencies through constructors. ViewModels and Services depend on repository interfaces; repositories depend on infrastructure interfaces rather than package implementations.
- Write all project documentation, source code, identifiers, filenames, folders, tests, and comments in English. Keep comments short and explain *why*.
- Use Dart sound null safety, explicit types, `final` by default, `const` where applicable; avoid `var` and unnecessary `dynamic`.
- Treat accessibility, graceful errors, privacy, copyright/licensing, and maintainability as implementation requirements.
- Preserve exact authorized Bible wording and document provenance; never silently rewrite source text or fabricate citations.
- Reading the Bible, confessions, catechisms, creeds, and other included historical documents, as well as basic search, must work offline without authentication.
- Store the approved reading corpus and its search indexes in one bundled SQLite database file. Install it locally on first launch without a network request. Content updates must preserve offline reading and user data.

## Architecture

- Mobile-first: Android and iOS. Adapt to larger widths when needed; do not design tablet or Web as the primary experience.
- Organize by feature, then layer: `features/<feature>/<layer>/`; shared concerns belong in `core/<concern>/<layer>/`.
- Use `View → ViewModel → Repository` by default. Introduce a named Service only for real coordination or shared application state.
- Views render state and forward actions to injected ViewModels. Views do not call API clients, repositories, storage, or services directly.
- Default to Flutter `ChangeNotifier`, `ListenableBuilder`, and `ValueListenableBuilder`.
- Every implemented data feature has a local repository behind an explicit interface. Add a separate remote repository and interface only when remote access is required. Keep local persistence and remote communication in their respective implementations.
- Hide external infrastructure packages behind application-owned, narrowly scoped interfaces. Local repositories use an injected database/storage interface; remote repositories use an injected `HttpClient` interface. Package-specific types and exceptions must not escape the implementation boundary.
- For HTTP, `DioHttpClient` implements `HttpClient` and receives a `Dio` instance through its constructor. Only this implementation calls Dio directly; repositories, Services, and ViewModels never do. Apply the same dependency inversion to SQLite, preferences, and secure-storage packages when used.
- Use GetIt at app composition boundaries to bind interfaces to implementations and inject package instances into their adapters. Use constructor injection elsewhere. Prefer Dio behind `HttpClient` when remote APIs are introduced; do not introduce network dependencies before needed.
- Keep guest/public reading separate from authenticated user and church-community capabilities.
- Mobile releases and server deployments are independent; maintain backward-compatible API contracts.

## Focused guidance

- [Product Overview](product-overview.md)
- [Frontend Architecture](architecture.md)
- [Design System](design-system.md)
- [Search Strategy](search-strategy.md)
- [Testing and Definition of Done](testing.md)

If guides conflict, this constitution takes precedence. Update the relevant guide when an agreed decision changes.
