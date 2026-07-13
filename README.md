# Ascrollbox

Ascrollbox is a Flutter app for saving and organizing videos you find on YouTube, TikTok, Instagram, and Facebook. Share a link from any app and Ascrollbox saves it in the background — no need to stop what you were doing.

## What it does

- **Save with one share** — share a video link from any app; Ascrollbox fetches the title and thumbnail automatically and saves it to your library.
- **Organize with tags** — 80+ predefined tags plus custom ones, filters, search, and sort.
- **Group videos into Packs** — curated collections you can keep private or publish to the community.
- **Share with the community** — publish a pack publicly or with a 6-character code; others can discover it, rate it, and save it.
- **Keep some things private** — a PIN-protected section completely hidden from search, home, and packs.
- **Watch without leaving the app** — an in-app player opens videos directly.

## Supported platforms

| Platform  | How metadata is fetched |
|-----------|--------------------------|
| YouTube   | oEmbed API |
| TikTok    | oEmbed API |
| Facebook  | HTML scraping (Facebook's crawler UA) |
| Instagram | HTML scraping |
| Any other URL | Generic HTML scraping (title, image, description) |

## Tech stack

| Layer        | Package / Tool |
|--------------|-----------------|
| Framework    | Flutter (Dart 3.12+) |
| Auth         | `firebase_auth` + `google_sign_in` |
| Database     | `cloud_firestore` |
| Storage      | `firebase_storage` |
| App security | `firebase_app_check` |
| State        | `provider` |
| Video player | `webview_flutter` |
| i18n         | `flutter_localizations` (English, Spanish, German, Portuguese) |

For the full architecture (folder structure, Firestore schema, security rules, and platform-specific build notes), see [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md).

## Getting started

### Prerequisites

- Flutter SDK >= 3.12
- A Firebase project with **Authentication** (Google provider), **Firestore**, **Storage**, and **App Check** enabled
- `google-services.json` placed in `android/app/`

### Setup

```bash
flutter pub get
dart run flutter_launcher_icons        # generate adaptive app icons
dart run flutter_native_splash:create  # generate native splash assets
flutter run
```

### Localization

ARB files live in [lib/l10n/](lib/l10n/). After editing them, regenerate the generated Dart files:

```bash
flutter gen-l10n
```

Files in `lib/l10n/generated/` are auto-generated and committed — don't edit them by hand.

## Building & releasing

### Debug build (run on a connected device)

```bash
flutter run
```

### Release build for Google Play

Bump the version in `pubspec.yaml` (`version: x.y.z+buildNumber`), then:

```bash
flutter build appbundle --release
```

The signed App Bundle is written to:

```
build/app/outputs/bundle/release/app-release.aab
```

Upload it in [Google Play Console](https://play.google.com/console) → your app → **Release** → the track you want (Production / Testing) → **Create new release**.

Release signing reads credentials from `android/key.properties` (not committed — keep it and the `.jks` keystore safe, losing them means you can never update the app on Play again).
