# Pactantes Design System

## Direction

A quiet editorial reading app, not a church dashboard, SaaS landing page, or generic AI-generated card collection. Draw subtle inspiration from Paraguay's flag without bright patriotic blocks. Use restraint, generous whitespace, readable type, and a clear hierarchy. Use an approved mobile home reference when one is available; do not assume a reference image is included in this repository.

## Color tokens (initial proposals)

| Role | Hex | Usage |
| --- | --- | --- |
| `paper` | `#F8F7F4` | App background |
| `surface` | `#FFFFFF` | Cards and sheets |
| `ink` | `#242B33` | Primary text |
| `mutedInk` | `#73777B` | Secondary text |
| `navy` | `#263E59` | Primary emphasis, Bible access |
| `softRed` | `#A85D61` | Selected state, limited accents |
| `border` | `#E8E6E1` | Subtle dividers |

Verify contrast for actual text sizes; adjust shades as needed for accessibility. Do not communicate state by color alone. No gold, heavy gradients, decorative glows, or strong shadows.

## Typography

- Editorial serif for brand, section titles and reading headings (e.g. Source Serif 4 or another properly licensed bundled serif).
- Clean sans-serif for controls, labels and navigation (e.g. Inter or another properly licensed bundled sans).
- Bible and historical texts need their own reading typography tokens: comfortable line height, scalable size, paragraph spacing, reference/verse-number treatment, and adequate line length.
- Use `ThemeData`/`TextTheme` as the default. Bundle fonts only after checking license and necessity.

## Layout and navigation

- Phone portrait is the reference composition. Use safe areas and bottom insets.
- One bottom navigation bar on main destinations: Inicio, Biblia, Biblioteca, Buscar, Comunidad. No second mid-screen navigation or duplicate profile tab.
- A compact brand header. No decorative blue/red underline marks beneath the brand: they can resemble swipe/carousel indicators.
- If `Continuar leyendo` is horizontally scrollable, show an affordance that clearly communicates the interaction; pagination dots only when they truly reflect pages and are accessible.
- Prioritize a Bible entry point, continue-reading when data exists, and a short categorized library list.
- Do not fill empty space with generic cards. Prefer restrained rows, thin dividers, and modest radius/elevation.
- Do not repeat the full logo in every section or put decorative banners above essential reading controls.

## Theme-first Flutter implementation

Use native widgets and centralized `ThemeData` first: `NavigationBar` (or an intentionally styled equivalent), text, buttons, cards, dialogs, inputs and dividers. Put reusable semantic tokens in:

```text
lib/design_system/
  theme/
    app_theme.dart
    app_colors.dart
    app_typography.dart
    app_spacing.dart
    app_radius.dart
  components/   # only when needed
```

Use `ThemeExtension` for missing semantic roles such as paper/ink, rather than rebuilding Flutter's entire theme system. Add a component only for meaningful reusable composition or behavior.

## Reading experience

- Reading surfaces should favor uninterrupted text and a low-distraction header.
- Provide clear chapter/section navigation and verse/paragraph anchors.
- Support user text scaling and preserve document structure; avoid truncating canonical passages.
- Bookmark/progress controls must accurately reflect saved vs unsaved state.
- Consider dark reading mode as a later feature, not an implied MVP commitment.

## Accessibility and motion

- Minimum comfortable touch areas (target ~48 logical pixels).
- Accessible labels for icons, selection, progress, and carousels.
- Respect reduced motion and text scaling; avoid unnecessary animation.
- Handle empty, loading, error and offline states without misleading promises. Bible and library reading and basic search remain available offline; show connectivity requirements only for features that actually use a network.
