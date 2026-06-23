# Ascrollbox

A Flutter app for saving and organizing social media videos from YouTube, TikTok, Instagram, Facebook, and any other URL. Share a link from any app and Ascrollbox saves it without interrupting what you were doing.

## Features

- **Share-to-save bottom sheet** — share any video URL from another app and a transparent bottom sheet slides up *without* opening Ascrollbox. The source app stays visible behind it. Tap **Save**, select tags, optionally mark as private, and dismiss.
- **Manual URL entry** — paste or type a URL directly from inside the app
- **Auto metadata** — fetches title and thumbnail via oEmbed (YouTube, TikTok) or HTML scraping (Facebook, Instagram, generic)
- **Persistent thumbnails** — thumbnails are downloaded and stored in Firebase Storage at save time, so they never expire or break
- **AI tag suggestions** — analyzes title and description to pre-select relevant tags
- **80+ predefined tags** across 13 categories (Entertainment, Education, Lifestyle, Family, Spirituality, Politics, Business, Creativity, Community, Mental Health, Gaming, Sports, Trending)
- **Custom tags** — add any free-form tag beyond the predefined list (max 5 per video)
- **Tag filter bar** — filter the video grid by one or more tags (OR logic)
- **Full-text search** — searches title, notes, and both English and localized tag names
- **Sort** — newest first, oldest first, or grouped by platform
- **Packs** — curated collections with name, description, and tags set at creation. Add any video to one or more packs.
- **Community sharing** — publish any pack to the community (public or code-only). Other users can discover via a 6-char code, rate (1–5 stars), and save shared packs. Each pack tracks views, saves, and average rating.
- **Edit** — update tags and personal notes on any saved video
- **In-app player** — opens videos in a WebView without leaving the app
- **Google Sign-In** — authentication via Firebase Auth
- **Firebase App Check** — Play Integrity (production) / debug provider (development) protects Firestore and Storage from unauthorized access
- **Bilingual** — English and Spanish, using Flutter's official `l10n` system
- **Material 3 theming** — purple accent, adaptive icon for Android
- **Private section** — PIN-protected vault that hides videos from home, search, and every other view. Videos can be moved in/out freely. PIN recoverable via 3 security questions.

## Architecture

```
lib/
├── main.dart                 # Entry point — detects share vs normal launch,
│                             # Firebase + App Check init, splash, auth gate, Provider setup
├── theme.dart                # Material 3 theme
├── firebase_options.dart     # Auto-generated Firebase config
│
├── models/
│   ├── video_model.dart      # VideoModel (url, platform, title, thumbnailUrl,
│   │                         #   tags, notes, packIds, createdAt, isPrivate)
│   ├── pack_model.dart       # PackModel (name, description, tags, videoIds,
│   │                         #   communityPackId, createdAt, updatedAt)
│   ├── community_pack_model.dart # CommunityPackModel + CommunityPackVideo
│   ├── category_model.dart   # CategoryModel (used in categories view)
│   ├── tag_model.dart        # Tag keys, emoji map, section definitions, localization helpers
│   └── security_question_model.dart # Predefined security questions with IDs
│
├── providers/
│   └── app_provider.dart     # ChangeNotifier — videos (public only), privateVideos,
│                             #   packs, publicCommunityPacks, savedCommunityPacks,
│                             #   search/filter/sort state, CRUD, PIN & community methods
│
├── services/
│   ├── auth_service.dart     # Google Sign-In / sign-out
│   ├── firestore_service.dart# Firestore CRUD + real-time streams; PIN hash (SHA-256);
│   │                         #   community pack publish/unpublish/rating/views
│   ├── storage_service.dart  # Firebase Storage — downloads and re-uploads thumbnails
│   ├── metadata_service.dart # URL metadata fetching (oEmbed + HTML scraping)
│   ├── tag_classifier.dart   # Keyword-based tag suggestion from title/description
│   └── category_classifier.dart
│
├── screens/
│   ├── login_screen.dart              # Google Sign-In screen
│   ├── home_screen.dart               # Main grid + search + tag filter + save/edit sheets + drawer
│   ├── video_player_screen.dart       # In-app WebView player
│   ├── packs_screen.dart              # Tabs: Mis Packs / Compartidos
│   ├── pack_form_screen.dart          # Create / edit pack (name, description, tags)
│   ├── pack_detail_screen.dart        # Videos inside a pack; description/tags header; share + edit buttons
│   ├── pack_publish_screen.dart       # Configure pack sharing (visibility, share code)
│   ├── community_pack_detail_screen.dart # Shared pack: stats, 1-5 star rating, playable videos
│   ├── find_pack_screen.dart          # Enter 6-char code to find a pack
│   ├── categories_screen.dart         # Browse videos grouped by category/tag
│   ├── private_screen.dart            # PIN-protected grid of private videos
│   ├── pin_entry_screen.dart          # 6-digit PIN entry/setup; "Forgot PIN?" → security questions
│   └── security_questions_screen.dart # Security question setup (3 questions) and verification
│
├── widgets/
│   ├── video_card.dart           # Thumbnail card with platform badge, context menu
│   │                             #   (Move to Private / Home, Remove from Pack, Delete)
│   ├── pack_card.dart            # Pack card with 2×2 thumbnail mosaic
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
5. The save bottom sheet slides up showing tag suggestions and a **Private switch**
6. On save: metadata is fetched, the thumbnail is uploaded to Firebase Storage, and the video is written to Firestore; the activity closes
7. On cancel or swipe-dismiss: the activity closes with no side effects

## Private Section

Videos marked as private are completely isolated from the rest of the app:

- **Never appear** in the home grid, search results, tag filters, categories, or packs
- Accessible only via the **Privado** item in the drawer, protected by a 6-digit PIN
- PIN is stored as a **SHA-256 hash** in Firestore (`users/{uid}/settings/private`)
- **First access**: user creates a PIN, confirms it, then sets 3 security questions
- **Subsequent access**: enter the PIN to unlock
- **Move to private**: long-press any video → "Move to Private"
- **Move back**: long-press any private video → "Move to Home"
- **Save as private**: toggle the Private switch in the save sheet (works from the share flow too)

### PIN Recovery

If the user forgets their PIN:

1. Tap **"¿Olvidaste tu clave?"** on the PIN screen
2. Answer the 3 security questions set up during PIN creation
3. On correct answers: set a new PIN (security questions are preserved)

Answers are stored as **SHA-256 hashes** — the plaintext never reaches Firestore. Verification is case-insensitive and ignores leading/trailing spaces.

## Community Packs

Packs can be shared with the Ascrollbox community:

- **Create a pack** with name, description, and tags
- **Publish**: choose public (discoverable by all) or code-only (shared via a 6-char code like `A3K9F2`)
- **Discover**: tab "Compartidos" shows public packs and a field to enter a code
- **View**: see pack description, tags, stats (views, saves, avg rating), and play videos directly
- **Rate**: give 1–5 stars (one vote per user, changeable)
- **Save**: bookmark a pack to your Compartidos section
- Videos inside a shared pack are synced in real time — when the creator adds or removes videos, everyone sees the update

## Firebase Storage

Thumbnails are downloaded from the source platform at save time and re-uploaded to Firebase Storage:

```
users/{uid}/thumbnails/{timestamp}.{ext}
```

This ensures thumbnails remain available permanently, even after the original platform URL expires (common with TikTok and Instagram).

If the upload fails (network error, timeout), the original platform URL is used as fallback.

## Supported Platforms

| Platform   | Metadata method                                    |
|------------|----------------------------------------------------|
| YouTube    | oEmbed API (`youtube.com/oembed`)                  |
| TikTok     | oEmbed API (`tiktok.com/oembed`)                   |
| Facebook   | HTML scraping with OG tags (uses Facebook's own crawler UA for Reels) |
| Instagram  | HTML scraping with OG tags                         |
| Other      | Generic HTML scraping (og:title, og:image, meta description) |

## Tech Stack

| Layer        | Package / Tool                       |
|--------------|--------------------------------------|
| Framework    | Flutter 3.44+ (Dart 3.12+)           |
| Auth         | `firebase_auth` + `google_sign_in`   |
| Database     | `cloud_firestore` (real-time streams) |
| Storage      | `firebase_storage` (thumbnails)      |
| App security | `firebase_app_check` (Play Integrity / debug) |
| State        | `provider` (ChangeNotifier)          |
| Video player | `webview_flutter`                    |
| Image cache  | `cached_network_image`               |
| HTTP         | `http`                               |
| Hashing      | `crypto` (SHA-256 — PIN + security question answers) |
| i18n         | `flutter_localizations` + ARB files  |
| Native splash| `flutter_native_splash`              |
| App icons    | `flutter_launcher_icons`             |

## Getting Started

### Prerequisites

- Flutter SDK >= 3.12
- Firebase project with **Authentication** (Google provider), **Firestore**, **Storage**, and **App Check** enabled
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

## Firebase Configuration

### Firestore Security Rules

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    function isAuth() { return request.auth != null; }
    function isOwner(uid) { return request.auth.uid == uid; }
    function isCommunityPackOwner(packId) {
      return get(/databases/$(database)/documents/community_packs/$(packId))
               .data.ownerId == request.auth.uid;
    }

    match /users/{uid}/{document=**} {
      allow read, write: if isAuth() && isOwner(uid);
    }

    match /community_packs/{packId} {
      allow read: if isAuth();
      allow create: if isAuth() && request.resource.data.ownerId == request.auth.uid;
      allow update: if isAuth() && (
        resource.data.ownerId == request.auth.uid ||
        request.resource.data.diff(resource.data).affectedKeys()
          .hasOnly(['viewCount', 'shareCount', 'ratingSum', 'ratingCount'])
      );
      allow delete: if isAuth() && resource.data.ownerId == request.auth.uid;

      match /videos/{videoId} {
        allow read: if isAuth();
        allow write: if isAuth() && isCommunityPackOwner(packId);
      }
      match /ratings/{ratingUid} {
        allow read: if isAuth();
        allow write: if isAuth() && request.auth.uid == ratingUid;
      }
    }
  }
}
```

### Storage Security Rules

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /users/{uid}/thumbnails/{filename} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && request.auth.uid == uid;
    }
  }
}
```

### App Check

- **Android production**: Play Integrity API — register the app's SHA-256 fingerprint in Firebase Console → App Check
- **Android development**: debug provider — the debug token is printed to logcat on first run; register it in App Check → Manage debug tokens
- Recommended mode: **Monitoring** during development, **Enforce** after confirming verified traffic in the App Check dashboard

## Firestore Structure

```
users/{uid}/
  videos/{videoId}
    url           String
    platform      String      # youtube | tiktok | instagram | facebook | other
    title         String
    thumbnailUrl  String      # Firebase Storage URL (permanent)
    tags          List<String>
    notes         String?
    packIds       List<String>
    createdAt     Timestamp
    isPrivate     Boolean     # true = hidden from home/search/packs/categories

  packs/{packId}
    name            String
    description     String
    tags            List<String>
    videoIds        List<String>
    communityPackId String?   # set when published to community
    createdAt       Timestamp
    updatedAt       Timestamp

  settings/private
    pinHash             String      # SHA-256 hash of the 6-digit PIN
    securityQuestions   List<Map>   # [{questionId, answerHash}] × 3

  saved_community_packs/{communityPackId}
    savedAt       Timestamp

community_packs/{packId}
  ownerId, ownerName, ownerPhotoUrl
  name          String
  description   String
  tags          List<String>
  isPublic      Boolean       # true = discoverable; false = code-only
  shareCode     String        # 6-char alphanumeric (e.g. "A3K9F2")
  viewCount     Number
  shareCount    Number        # times saved by other users
  ratingSum     Number
  ratingCount   Number        # avg = ratingSum / ratingCount
  createdAt, updatedAt

  videos/{videoId}            # Live snapshot of video metadata
    url, platform, title, thumbnailUrl

  ratings/{uid}
    rating      Number (1–5)
    ratedAt     Timestamp
```

## Tag System

Tags are stored in Firestore as English string keys (e.g., `"Humor & Comedy"`). The UI displays them localized via `tag_model.dart`'s `localizedTag()` helper. Each tag has an associated emoji.

The save sheet auto-suggests up to 3 tags by running `TagClassifier.suggest()` against the video's title and description. Users can accept, remove, or add custom tags (max 5 per video). Packs can also be tagged to help with community discovery.

## Android Notes

### Xiaomi / MIUI

- **Impeller disabled** via `AndroidManifest.xml` meta-data (`io.flutter.embedding.android.EnableImpeller = false`). Impeller's Vulkan+OpenGLES initialization causes a grey screen on MIUI due to a "Width is zero" surface conflict.
- The native launch screen (before Flutter renders) is a grey animation controlled by MIUI's launcher — this is a system-level behavior that cannot be overridden from the app.

### Gradle / Build

- **JVM memory**: `org.gradle.jvmargs=-Xmx4G -XX:MaxMetaspaceSize=512m` — prevents Gradle from hanging when requesting excessive RAM.
- **Kotlin incremental off**: `kotlin.incremental=false` — fixes a cross-drive compilation error (`IllegalArgumentException: this and base files have different roots`) that occurs when the project is on a different drive letter than the Pub cache (common on Windows with D: project / C: cache).
