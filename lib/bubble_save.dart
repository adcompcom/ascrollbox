import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'firebase_options.dart';
import 'models/video_model.dart';
import 'services/firestore_service.dart';
import 'services/metadata_service.dart';
import 'services/storage_service.dart';

/// Runs inside a headless FlutterEngine hosted by SavingService (Kotlin),
/// independent of ShareActivity's lifecycle — so the save survives the
/// share sheet closing and the source app regaining focus.
@pragma('vm:entry-point')
void bubbleSaveMain() {
  WidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('ascrollbox/bubble_save');

  channel.setMethodCallHandler((call) async {
    if (call.method != 'save') return null;

    final args = Map<String, dynamic>.from(call.arguments as Map);
    final uid = args['uid'] as String;
    final url = args['url'] as String;
    final tags = List<String>.from(args['tags'] as List);
    final isPrivate = args['isPrivate'] as bool;

    try {
      await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

      final meta = await MetadataService().fetch(url);

      final thumbnailUrl = meta.thumbnailUrl.isNotEmpty
          ? (await StorageService().uploadThumbnail(uid, meta.thumbnailUrl) ??
              meta.thumbnailUrl)
          : '';

      await FirestoreService().addVideo(
        uid,
        VideoModel(
          id: '',
          url: url,
          platform: meta.platform,
          title: meta.title.isEmpty ? url : meta.title,
          thumbnailUrl: thumbnailUrl,
          tags: tags,
          packIds: [],
          createdAt: DateTime.now(),
          isPrivate: isPrivate,
        ),
      );

      await channel.invokeMethod<void>('done', {'success': true});
    } catch (e) {
      await channel.invokeMethod<void>('done', {
        'success': false,
        'error': e.toString(),
      });
    }
    return null;
  });

  channel.invokeMethod<void>('ready');
}
