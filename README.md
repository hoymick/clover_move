# Clover Move

Flutter build of the Clover Move UI pack (`Clover Move — Complete UI 3.html`,
52 screens on a 390 × 844 canvas).

## Running it

```sh
flutter run                 # pick a device when prompted
flutter run -d chrome       # or in the browser
```

The app opens on a **screen index** listing every screen that has been built,
grouped by the pack's own sections. Tap any row to open that screen.

To jump straight to one screen while working on it:

```sh
flutter run --dart-define=SCREEN=discovery
```

The value is the screen's route, as listed in `lib/screens/catalogue.dart`.

## Checks

```sh
flutter analyze
flutter test
```

`test/screens_test.dart` renders every registered screen at 390 × 844 and fails
on any layout overflow or build error, so a broken screen can't reach the index
unnoticed. Note that widget tests substitute a fallback font whose glyphs are
wider than Baloo Bhai 2 — text-heavy rows are therefore checked against a
slightly harsher case than the real app.

## How it's laid out

| Path | What's in it |
| --- | --- |
| `lib/theme/` | Brand colours, radii, insets and the named text styles. Screens never hand-roll a `TextStyle`. |
| `lib/models/` | The three leaf categories and the five locales. |
| `lib/state/` | Session state for the onboarding choices (`AppState`). |
| `lib/widgets/` | The design system — cards, chips, fields, headers, thumbnails, map ground, QR, ratings. |
| `lib/screens/` | One folder per pack section, one file per screen. |
| `lib/screens/catalogue.dart` | The registry. Adding a screen means adding one entry here; the router and the index both read from it. |
| `assets/images/` | The 31 product and member photos extracted from the pack. |

Photographic panels the pack draws as colour washes (routes, events, venues) are
rendered by `CloverThumb` rather than bitmaps, so they re-tint with the member's
chosen colour.

## All 52 screens

| Section | Screens |
| --- | --- |
| Getting in | 4 |
| Finding something to do | 8 |
| Taking part | 6 |
| Hosting | 5 |
| Smart Jerseys | 11 |
| Community & account | 5 |
| Business & partners | 6 |
| Admin | 2 |
| When things go wrong | 5 |

## Matching the design

The pack is an SVG document, so it doubles as the spec. Two things follow from
that:

**The icons are the designer's.** All 45 are drawn as explicit 24 x 24 paths in
the pack, extracted into `lib/theme/pack_icons.dart` and drawn by `PackIcon`,
which scales the path and *then* strokes it — the pack keeps a constant ~1.9px
weight whatever the icon size, which an SVG asset cannot do.

**The leaf art is per category.** `assets/svg/leaf.svg` is the whole three-leaf
clover; the design also uses a single upright leaf carrying an activity
pictogram — walker, cyclist, weightlifter. Those were cut out of the logo into
`leaf_shape.svg`, `leaf_shape_outline.svg` and `pictogram_*.svg`, composed by
`CategoryLeaf`.

Photographic panels the pack draws as colour washes are rendered by `CloverThumb`
rather than bitmaps, so they re-tint with the member's chosen colour.

To check a screen against the pack, render the original and compare:

```sh
# writes one HTML page per screen, then screenshot it
"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
  --headless --force-device-scale-factor=2 --window-size=390,844 \
  --screenshot=ref.png screen.html
```
