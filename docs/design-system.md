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
- Reader light, paper, and dark palettes are centralized in `ReaderTheme`, independent of the global application theme. See [Reader](reader.md).

## Accessibility and motion

- Minimum comfortable touch areas (target ~48 logical pixels).
- Accessible labels for icons, selection, progress, and carousels.
- Respect reduced motion and text scaling; avoid unnecessary animation.
- Handle empty, loading, error and offline states without misleading promises. Bible and library reading and basic search remain available offline; show connectivity requirements only for features that actually use a network.

## Home implementation assets

Home uses bundled Source Serif 4 for editorial text and the platform sans-serif for controls. Font files come from the Google Fonts Source Serif 4 distribution, authored by the Adobe Source Serif project; the SIL Open Font License is retained in `assets/fonts/OFL.txt`. Home displays `assets/logo/pactantes.png`, generated from the user-provided open-book reference with transparent background. Home entries and the overflow icon provide native Material touch feedback without navigating or changing the selected destination. The Bible entry uses the navy emphasis requested for Home.

## Home logo generation

Generated with the built-in ImageGen tool from the user-provided open-book reference. The transparent PNG is displayed above the brand title on Home.

### Final generation prompt

Use case: logo-brand. Asset type: transparent PNG brand mark for the Pactantes Flutter app header. Input image: reference image only, recreate its exact minimal open-book symbol as a clean high-resolution asset. Subject: four slender curved strokes forming two facing open pages: upper left and upper right strokes muted red #A34C4F; lower left and lower right strokes navy #263E59, converging gently at a central fold with small natural gaps. Preserve the simple shallow curves, balanced symmetry and wide approximately 4:1 silhouette seen in the supplied reference. Flat thin rounded strokes, clean antialiasing. Symbol only, no lettering, no frame, no shadow, no gradients, no additional pages or elements. True transparent background, including between strokes. Tightly framed around the symbol with only a small transparent margin, wide landscape canvas. Output intended to display approximately 52 logical pixels wide by 18 high. Save generated PNG to filesystem and report its local path.

## Home reference adaptation

Home places the larger book mark at the center of a compact 48-pixel AppBar, with the language overflow menu at the right. The serif brand title, tracked uppercase subtitle, and italic introduction sit immediately below the bar. A short divider and compact spacing separate the subtitle and introduction. A featured reading card precedes the compact navy Bible entry. The library uses a two-column grid with neutral bordered text-only tiles; it stacks at narrow widths or enlarged text sizes. The footer shows Ephesians 2:8 above the fixed main navigation.

Reading cards use the actual bundled edition title, parent grouping, unit label, and question preview. Saved progress includes both a visible percentage and a progress bar, and stable section IDs still control resuming; an unstarted edition shows Begin study without inventing progress. Multiple reading records retain the existing horizontal carousel and pagination. Reader preferences control the edition independently of the interface locale.

The Portuguese footer wording comes from the user's supplied reference. English uses the public-domain KJV text verified at https://www.biblegateway.com/passage/?search=Ephesians2%3A8&version=KJV; Spanish uses the public-domain Reina-Valera Antigua text verified at https://www.biblegateway.com/passage/?search=Efesios%202%3A8&version=RVA. These short bundled footer quotations do not imply an implemented SBT Bible reader or alter the catechism source text.
