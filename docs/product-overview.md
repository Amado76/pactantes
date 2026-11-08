# Pactantes — Product Overview

## Purpose

Pactantes — Recursos Reformados is a Spanish-language, mobile-first reading and discovery app for Reformed Christian resources. It combines an authorized Bible edition (SBT), historical confessions, catechisms, creeds, and reference search. In a later phase, registered users may participate in church communities.

Product voice: serious, calm, welcoming, precise, readable. Brand line: *Creciendo en Gracia y Verdad*.

## Audiences and access

- Guests: browse and read the authorized Bible and public historical documents; search public material without an account.
- Registered readers (future/when supported): optional sync of reading progress, bookmarks, and preferences.
- Church-community participants (later phase): access church-specific information according to membership and permissions.
- Church administrators (later phase): manage approved community content and access.

The Bible and all included historical reading material must be available offline from the first launch, stored with their search indexes in one SQLite database file bundled with the app. Opening, navigating, and searching this material must not depend on connectivity or a server.

Do not introduce sign-in gates for public content. Do not assume registration, church verification, moderation, or role-management APIs already exist.

## MVP scope

1. **Bible:** read the authorized SBT edition, navigate by book/chapter/verse, display verse numbers and reference labels accurately. Confirm exact licensed content, territory, redistribution, offline storage, and attribution terms before packaging it in the SQLite database.
2. **Historical library:** organized confessions, catechisms, creeds, Westminster standards, and other Reformed documents. Include metadata (title, category, source, language, edition, sections) and document-specific navigation. Read the included texts from the same offline SQLite database as the Bible. Verify rights and source editions individually.
3. **Search:** exact Bible reference parsing (`Juan 3:16`, `Jn 3:16-18` when supported), keyword search across available content, category filters, and accurate result snippets linking to the original text. Run basic search locally with SQLite full-text indexes, without network access or an LLM dependency.
4. **Reading UX:** typography and reading comfort, progress/continue-reading when implemented, adjustable text size, sensible empty/loading/error states. Local-only progress or bookmarks may precede cloud sync.
5. **Navigation:** single persistent bottom navigation on principal screens: `Inicio`, `Biblia`, `Biblioteca`, `Buscar`, `Comunidad`. `Comunidad` may display a clear future-feature state until implemented. Settings/account entry can live in a discreet overflow menu, not a duplicate navigation bar.

## Later phases — not MVP promises

- Account creation, sign-in, optional cross-device sync.
- Church directory, church profiles, membership/request-to-join and admin approval where needed.
- Church information, worship/service times, announcements and events.
- Prayer requests with explicit visibility and moderation controls; birthdays with consent, visibility and privacy protections.
- Optional semantic search and cited, retrieval-grounded assistance.

## Platforms and responsive behavior

- Target Android and iOS first; prioritize phone portrait and actual device testing.
- Use available width rather than OS checks. Accommodate larger phones and tablets gracefully; Web is not a current delivery requirement.
- Respect safe areas, dynamic text scaling, touch targets and screen-reader semantics.

## Localization

- Initial UI: Spanish (`es`). Project documentation remains in English; Spanish navigation labels, reference examples, and brand wording below are intentional product strings.
- Structure user-facing strings for Flutter ARB localization from the start. Do not claim other locales are implemented until translated and tested.
- Preserve source-document language independently of UI locale. Search normalization must not modify displayed canonical text.

## Privacy and trust

- Public reading does not require collecting personal information.
- Treat prayer requests, birthdays and church membership as sensitive community information; use least-privilege access and consent-based visibility.
- Never present AI-generated text as scripture or as a historical quotation. Search results must resolve to verified source passages.
