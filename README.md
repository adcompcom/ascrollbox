# Ascrollbox

A Flutter app for saving and organizing social media videos from YouTube, TikTok, Instagram, Facebook, and any other URL. Share a link from any app and Ascrollbox saves it without interrupting what you were doing.

## Features

- **Share-to-save bottom sheet** — share any video URL from another app and a transparent bottom sheet slides up *without* opening Ascrollbox. The source app stays visible behind it. Tap **Save**, select tags, and dismiss. The app never takes over the screen.
- **Manual URL entry** — paste or type a URL directly from inside the app
- **Auto metadata** — fetches title and thumbnail via oEmbed (YouTube, TikTok) or HTML scraping (Facebook, Instagram, generic)
- **AI tag suggestions** — analyzes title and description to pre-select relevant tags
- **80+ predefined tags** across 13 categories (Entertainment, Education, Lifestyle, Family, Spirituality, Politics, Business, Creativity, Community, Mental Health, Gaming, Sports, Trending)
- **Custom tags** — add any free-form tag beyond the predefined list (max 5 per video)
- **Tag filter bar** — filter the video grid by one or more tags (OR logic)
- **Full-text search** — searches title, notes, and both English and localized tag names
- **Sort** — newest first, oldest first, or grouped by platform
- **Packs** — curated collections; add any video to one or more packs. Packs have a description and tags.
- **Community sharing** — publish any pack to the community (public or code-only). Other users can discover, rate, and save shared packs. Each pack tracks views, saves, and a 1–5 star rating.
- **Edit** — update tags and personal notes on any saved video
- **In-app player** — opens videos in a WebView without leaving the app
- **Google Sign-In** — authentication via Firebase Auth
- **Bilingual** — English and Spanish, using Flutter's official `l10n` system
- **Material 3 theming** — purple accent, adaptive icon for Android
- **Private section** — PIN-protected vault that hides videos from home, search, and every other view. Videos can be moved in/out freely. PIN recoverable via Google re-authentication.

## Architecture

```
lib/
├── main.dart                 # Entry point — detects share vs normal launch,
│                             # Firebase init, splash, auth gate, Provider setup
├── theme.dart                # Material 3 theme
├── firebase_options.dart     # Auto-generated Firebase config
│
├── models/
│   ├── video_model.dart      # VideoModel (url, platform, title, thumbnailUrl,
│   │                         #   tags, notes, packIds, createdAt, isPrivate)
│   ├── pack_model.dart       # PackModel (name, videoIds)
│   ├── category_model.dart   # CategoryModel (used in categories view)
│   └── tag_model.dart        # Tag keys, emoji map, section definitions, localization helpers
│
├── providers/
│   └── app_provider.dart     # ChangeNotifier — videos (public only), privateVideos,
│                             #   packs, search/filter/sort state, CRUD, PIN methods
│
├── services/
│   ├── auth_service.dart     # Google Sign-In / sign-out
│   ├── firestore_service.dart# Firestore CRUD + real-time streams for videos and packs;
│   │                         #   PIN hash storage/verification (SHA-256)
│   ├── metadata_service.dart # URL metadata fetching (oEmbed + HTML scraping)
│   ├── tag_classifier.dart   # Keyword-based tag suggestion from title/description
│   └── category_classifier.dart
│
├── screens/
│   ├── login_screen.dart              # Google Sign-In screen
│   ├── home_screen.dart               # Main grid + search + tag filter + save/edit sheets + drawer
│   ├── video_player_screen.dart       # In-app WebView player
│   ├── packs_screen.dart              # Tabs: Mis Packs / Compartidos
│   ├── pack_detail_screen.dart        # Videos inside a specific pack + share button
│   ├── pack_publish_screen.dart       # Configure pack sharing (description, tags, visibility, code)
│   ├── community_pack_detail_screen.dart # Shared pack view: stats, rating, playable videos
│   ├── find_pack_screen.dart          # Enter 6-char code to find a pack
│   ├── categories_screen.dart         # Browse videos grouped by category/tag
│   ├── private_screen.dart            # PIN-protected grid of private videos
│   ├── pin_entry_screen.dart          # 6-digit PIN entry/setup with security question recovery
│   └── security_questions_screen.dart # Security question setup and verification
│
├── widgets/
│   ├── video_card.dart           # Thumbnail card with platform badge, context menu
│   │                             #   (includes Move to Private / Move to Home options)
│   ├── pack_card.dart            # Pack card with thumbnail mosaic
│   └── community_pack_card.dart  # Community pack card with views, rating, share code badge
│
└── l10n/
    ├── app_en.arb            # English strings
    ├── app_es.arb            # Spanish strings
    └── generated/            # Auto-generated AppLocalizations (do not edit)

android/app/src/main/kotlin/com/ascrollbox/ascrollbox/
├── MainActivity.kt           # Standard FlutterActivity (launcher)
└── ShareActivity.kt          # Transparent FlutterActivity for share intents —
                              # renders only the save bottom sheet using RenderMode.texture,
                              # passes the shared URL to Flutter via MethodChannel
```

## Share-to-save Flow

When the user taps **Share → Ascrollbox** in any other app:

1. Android routes the `ACTION_SEND` intent to `ShareActivity` (not `MainActivity`)
2. `ShareActivity` starts with a transparent window theme so the source app shows through
3. Flutter detects `defaultRouteName == '/share'` and skips the normal app stack
4. A `MethodChannel` passes the shared text to Flutter
5. The save bottom sheet slides up showing the **Ascrollbox logo**, tag suggestions, a **Private switch**, and Save/Cancel buttons
6. On save: metadata is fetched and the video is written directly to Firestore; the activity closes
7. On cancel or swipe-dismiss: the activity closes with no side effects

The source app is never interrupted — the user stays in context.

## Private Section

Videos marked as private are completely isolated from the rest of the app:

- **Never appear** in the home grid, search results, tag filters, or categories
- Accessible only via the **Privado** item in the drawer, protected by a 6-digit PIN
- PIN is stored as a **SHA-256 hash** in Firestore (`users/{uid}/settings/private`) — the raw PIN never leaves the device in plaintext
- **First access**: user creates a PIN and confirms it
- **Subsequent access**: user enters the PIN to unlock
- **Move to private**: long-press any video → "Move to Private"
- **Move back**: long-press any private video → "Move to Home"
- **Save as private**: toggle the Private switch in the save sheet (works from the share flow too)

### PIN Recovery

If the user forgets their PIN:

1. Tap **"¿Olvidaste tu clave?"** on the PIN screen
2. App re-authenticates with Google (already integrated)
3. On successful re-auth: the PIN hash is deleted and the user sets a new PIN
4. Videos remain intact — only the PIN is reset

Security trade-off: Google re-auth proves the user owns the account. An attacker who steals the unlocked phone would still need to know the Google account password to bypass the PIN.

## Supported Platforms

| Platform   | Metadata method                                    |
|------------|----------------------------------------------------|
| YouTube    | oEmbed API (`youtube.com/oembed`)                  |
| TikTok     | oEmbed API (`tiktok.com/oembed`)                   |
| Facebook   | HTML scraping with OG tags (uses Facebook's own crawler UA for Reels) |
| Instagram  | HTML scraping with OG tags                         |
| Other      | Generic HTML scraping (og:title, og:image, meta description) |

## Tech Stack

| Layer        | Package / Tool                    |
|--------------|-----------------------------------|
| Framework    | Flutter 3.44+ (Dart 3.12+)        |
| Auth         | `firebase_auth` + `google_sign_in` |
| Database     | `cloud_firestore` (real-time streams) |
| Storage      | `firebase_storage`                |
| State        | `provider` (ChangeNotifier)       |
| Video player | `webview_flutter`                 |
| Image cache  | `cached_network_image`            |
| HTTP         | `http`                            |
| PIN hashing  | `crypto` (SHA-256)                |
| i18n         | `flutter_localizations` + ARB files |
| Native splash| `flutter_native_splash`           |
| App icons    | `flutter_launcher_icons`          |

## Getting Started

### Prerequisites

- Flutter SDK >= 3.12
- Firebase project with **Authentication** (Google provider), **Firestore**, and **Storage** enabled
- `google-services.json` placed in `android/app/`

### Setup

```bash
flutter pub get
dart run flutter_launcher_icons        # generate adaptive app icons
dart run flutter_native_splash:create  # generate native splash assets
flutter run
```

### Localization

ARB files live in [lib/l10n/](lib/l10n/). After editing them, regenerate:

```bash
flutter gen-l10n
```

Generated files in `lib/l10n/generated/` are committed and should not be edited by hand.

## Firestore Structure

```
users/{uid}/
  videos/{videoId}
    url           String
    platform      String   # youtube | tiktok | instagram | facebook | other
    title         String
    thumbnailUrl  String
    tags          List<String>
    notes         String?
    packIds       List<String>
    createdAt     Timestamp
    isPrivate     Boolean  # default false; true = hidden from home/search/packs

  packs/{packId}
    name          String
    videoIds      List<String>
    createdAt     Timestamp

  settings/private
    pinHash             String          # SHA-256 hash of the 6-digit PIN
    securityQuestions   List<Map>       # [{questionId, answerHash}] × 3

community_packs/{packId}
  ownerId, ownerName, ownerPhotoUrl
  name          String
  description   String
  tags          List<String>
  isPublic      Boolean       # true = discoverable; false = code-only
  shareCode     String        # 6-char code (e.g. "A3K9F2")
  viewCount     Number
  shareCount    Number        # times other users saved this pack
  ratingSum     Number
  ratingCount   Number        # avg = ratingSum / ratingCount
  createdAt, updatedAt

  videos/{videoId}            # Snapshot of video metadata (syncs on add/remove)
    url, platform, title, thumbnailUrl

  ratings/{uid}
    rating      Number (1–5)
    ratedAt     Timestamp

users/{uid}/saved_community_packs/{communityPackId}
  savedAt       Timestamp
```

## Tag System

Tags are stored in Firestore as English string keys (e.g., `"Humor & Comedy"`). The UI displays them localized via `tag_model.dart`'s `localizedTag()` helper. Each tag has an associated emoji for the filter chips and save sheet.

The save sheet auto-suggests up to 3 tags by running `TagClassifier.suggest()` against the video's title and description. Users can accept, remove, or add custom tags up to a maximum of 5.

## Android Notes

### Xiaomi / MIUI

- **Impeller disabled** via `AndroidManifest.xml` meta-data (`io.flutter.embedding.android.EnableImpeller = false`). Impeller's Vulkan+OpenGLES initialization causes a grey screen on MIUI due to a "Width is zero" surface conflict.
- The native launch screen (before Flutter renders) is a grey animation controlled by MIUI's launcher — this is a system-level behavior that cannot be overridden from the app.

### Gradle / Build

- **JVM memory**: `org.gradle.jvmargs=-Xmx4G -XX:MaxMetaspaceSize=512m` — prevents Gradle from hanging when requesting excessive RAM.
- **Kotlin incremental off**: `kotlin.incremental=false` — fixes a cross-drive compilation error (`IllegalArgumentException: this and base files have different roots`) that occurs when the project is on a different drive letter than the Pub cache (common on Windows with D: project / C: cache).
