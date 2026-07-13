# Architecture

Deep technical reference for Ascrollbox. For a general overview, see the [README](../README.md).

## Project structure

```
lib/
├── main.dart                 # Entry point — detects share vs normal launch,
│                             # Firebase + App Check init, splash, auth gate, Provider setup
├── bubble_save.dart          # Headless entrypoint (bubbleSaveMain) run by the Android
│                             # SavingService — performs the share-to-save network work
│                             # independently of any Activity's lifecycle
├── theme.dart                # Material 3 theme
├── firebase_options.dart     # Auto-generated Firebase config
│
├── models/
│   ├── video_model.dart      # VideoModel (url, platform, title, thumbnailUrl, tags,
│   │                         #   notes, packIds, createdAt, updatedAt, isPrivate,
│   │                         #   source, viewCount, lastViewedAt)
│   ├── pack_model.dart       # PackModel (name, description, tags, videoIds,
│   │                         #   communityPackId, createdAt, updatedAt)
│   ├── community_pack_model.dart # CommunityPackModel + CommunityPackVideo
│   │                         #   (includes moderation fields: moderationStatus,
│   │                         #   reportCount, isFlagged, isDeleted, deletedAt)
│   ├── user_document_model.dart  # Top-level user doc for admin panel
│   │                         #   (email, loginCount, lastLoginAt, platform,
│   │                         #    isActive, isBanned, role, videoCount, packCount)
│   ├── user_profile_model.dart   # Public profile (nickname, photoUrl)
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
│   │                         #   community pack publish/unpublish/rating/views;
│   │                         #   upsertUserDocument, writeAuditLog, recordVideoView,
│   │                         #   softDeleteCommunityPack, reportCommunityPack
│   ├── storage_service.dart  # Firebase Storage — thumbnails + profile photos
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
├── ShareActivity.kt          # Transparent FlutterActivity for share intents —
│                             # renders only the save bottom sheet using RenderMode.texture,
│                             # passes the shared URL to Flutter via MethodChannel, then hands
│                             # off the save to SavingService and closes immediately
├── SavingService.kt          # Foreground service — runs bubble_save.dart's bubbleSaveMain in
│                             # a headless FlutterEngine so the save survives ShareActivity closing
└── SavingBubble.kt           # Builds the native Android Bubble notification shown while saving
```

## Share-to-save flow

When the user taps **Share → Ascrollbox** in any other app:

1. Android routes the `ACTION_SEND` intent to `ShareActivity` (not `MainActivity`)
2. `ShareActivity` starts with a transparent window theme so the source app shows through
3. Flutter detects `defaultRouteName == '/share'` and skips the normal app stack
4. A `MethodChannel` passes the shared text to Flutter
5. The save bottom sheet slides up showing tag suggestions and a **Private switch**
6. On save: `ShareActivity` hands the URL/tags/uid off to `SavingService` and closes immediately, returning control to the source app
7. `SavingService` runs the save (fetch metadata, upload thumbnail, write to Firestore) in a headless Flutter engine, showing a native **Bubble notification** with the Ascrollbox icon until it finishes
8. On cancel or swipe-dismiss: the activity closes with no side effects

### The saving bubble notification

`SavingBubble.kt` posts the notification `SavingService` needs to run as a foreground service — Android requires one for the whole duration of the save, it can't be suppressed. It's tuned to be as unobtrusive as possible:

- Channel importance is `IMPORTANCE_DEFAULT` (not `HIGH`) — enough for the bubble to appear, but it never shows as a heads-up banner
- `setSilent(true)` plus no sound/vibration on the channel — no alert when it's posted or dismissed
- `setAutoCancel(true)` and an explicit `SavingBubble.dismiss()` call once the save finishes, so it never lingers

If you ever need to change channel-level settings (importance, sound), bump `CHANNEL_ID` to a new value — Android only lets the *user* change an existing channel's settings from system Settings, the app can't overwrite them in code once the channel has been created once.

## Private section

Videos marked as private are completely isolated from the rest of the app:

- **Never appear** in the home grid, search results, tag filters, categories, or packs
- Accessible only via the **Privado** item in the drawer, protected by a 6-digit PIN
- PIN is stored as a **SHA-256 hash** in Firestore (`users/{uid}/settings/private`)
- **First access**: user creates a PIN, confirms it, then sets 3 security questions
- **Subsequent access**: enter the PIN to unlock
- **Move to private**: long-press any video → "Move to Private"
- **Move back**: long-press any private video → "Move to Home"
- **Save as private**: toggle the Private switch in the save sheet (works from the share flow too)

### PIN recovery

If the user forgets their PIN:

1. Tap **"¿Olvidaste tu clave?"** on the PIN screen
2. Answer the 3 security questions set up during PIN creation
3. On correct answers: set a new PIN (security questions are preserved)

Answers are stored as **SHA-256 hashes** — the plaintext never reaches Firestore. Verification is case-insensitive and ignores leading/trailing spaces.

## Community packs

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

This ensures thumbnails remain available permanently, even after the original platform URL expires (common with TikTok and Instagram). If the upload fails (network error, timeout), the original platform URL is used as fallback.

## Firebase configuration

### Firestore security rules

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    function isAuth() { return request.auth != null; }
    function isOwner(uid) { return request.auth.uid == uid; }
    function isAdmin() {
      return isAuth() &&
        get(/databases/$(database)/documents/users/$(request.auth.uid))
          .data.role in ['admin', 'moderator'];
    }
    function isCommunityPackOwner(packId) {
      return get(/databases/$(database)/documents/community_packs/$(packId))
               .data.ownerId == request.auth.uid;
    }

    // Top-level user doc — readable/writable by owner; readable by admins
    match /users/{uid} {
      allow read: if isAuth() && (isOwner(uid) || isAdmin());
      allow write: if isAuth() && isOwner(uid);
    }

    // Subcollections remain owner-only
    match /users/{uid}/{document=**} {
      allow read, write: if isAuth() && isOwner(uid);
    }

    // Audit log — append-only for authenticated users, read by admins
    match /audit_logs/{logId} {
      allow create: if isAuth();
      allow read: if isAdmin();
    }

    // Nickname index — any auth user can read; write managed by transactions
    match /nicknames/{nick} {
      allow read: if isAuth();
      allow write: if isAuth();
    }

    match /community_packs/{packId} {
      allow read: if isAuth();
      allow create: if isAuth() && request.resource.data.ownerId == request.auth.uid;
      allow update: if isAuth() && (
        resource.data.ownerId == request.auth.uid ||
        isAdmin() ||
        request.resource.data.diff(resource.data).affectedKeys()
          .hasOnly(['viewCount', 'shareCount', 'ratingSum', 'ratingCount',
                    'reportCount', 'isFlagged'])
      );
      allow delete: if isAuth() &&
        (resource.data.ownerId == request.auth.uid || isAdmin());

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

### Storage security rules

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

## Firestore structure

```
users/{uid}                   # Top-level user doc (admin panel)
  uid           String
  email         String
  displayName   String
  createdAt     Timestamp     # first login
  lastLoginAt   Timestamp     # updated on every login
  loginCount    Number
  platform      String        # android | ios | web | windows
  isActive      Boolean       # admin can deactivate
  isBanned      Boolean       # admin can ban
  role          String        # user | admin | moderator
  videoCount    Number        # denormalized
  packCount     Number        # denormalized

  videos/{videoId}
    url           String
    platform      String      # youtube | tiktok | instagram | facebook | other
    title         String
    thumbnailUrl  String      # Firebase Storage URL (permanent)
    tags          List<String>
    notes         String?
    packIds       List<String>
    createdAt     Timestamp
    updatedAt     Timestamp?  # stamped on every edit
    isPrivate     Boolean     # true = hidden from home/search/packs/categories
    source        String      # url_input | share_intent
    viewCount     Number      # times user opened the in-app player
    lastViewedAt  Timestamp?

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

  settings/profile
    nickname      String      # unique across all users
    photoUrl      String?     # Firebase Storage URL

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
  # Moderation (admin panel)
  isDeleted       Boolean     # soft-delete — document kept for audit
  deletedAt       Timestamp?
  reportCount     Number      # times reported by users
  isFlagged       Boolean     # admin-flagged for review
  moderationStatus String     # pending | approved | rejected

  videos/{videoId}            # Live snapshot of video metadata
    url, platform, title, thumbnailUrl

  ratings/{uid}
    rating      Number (1–5)
    ratedAt     Timestamp

nicknames/{nickname_lowercase}
  uid           String        # ownership index for uniqueness checks

audit_logs/{logId}            # Append-only audit trail for admin panel
  uid           String
  action        String        # video_added | video_deleted | pack_published |
                              #   pack_unpublished | pack_deleted
  targetType    String        # video | pack | community_pack
  targetId      String
  metadata      Map?          # extra context (platform, isPrivate, etc.)
  createdAt     Timestamp
```

## Tag system

Tags are stored in Firestore as English string keys (e.g., `"Humor & Comedy"`). The UI displays them localized via `tag_model.dart`'s `localizedTag()` helper. Each tag has an associated emoji.

The save sheet auto-suggests up to 3 tags by running `TagClassifier.suggest()` against the video's title and description. Users can accept, remove, or add custom tags (max 5 per video). Packs can also be tagged to help with community discovery.

## Android notes

### Xiaomi / MIUI

- **Impeller disabled** via `AndroidManifest.xml` meta-data (`io.flutter.embedding.android.EnableImpeller = false`). Impeller's Vulkan+OpenGLES initialization causes a grey screen on MIUI due to a "Width is zero" surface conflict.
- The native launch screen (before Flutter renders) is a grey animation controlled by MIUI's launcher — this is a system-level behavior that cannot be overridden from the app.

### Gradle / build

- **JVM memory**: `org.gradle.jvmargs=-Xmx4G -XX:MaxMetaspaceSize=512m` — prevents Gradle from hanging when requesting excessive RAM.
- **Kotlin incremental off**: `kotlin.incremental=false` — fixes a cross-drive compilation error (`IllegalArgumentException: this and base files have different roots`) that occurs when the project is on a different drive letter than the Pub cache (common on Windows with D: project / C: cache).
- **Headless entrypoints**: any Dart file with an alternate `@pragma('vm:entry-point')` entrypoint (like `bubble_save.dart`) must be imported somewhere reachable from `main.dart`, or it won't be compiled into the app's kernel snapshot and native code trying to run it will fail with "Could not resolve main entrypoint function".
