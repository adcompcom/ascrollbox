import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Downloads [imageUrl] and uploads it to Firebase Storage.
  /// Returns the permanent Storage download URL, or null if anything fails.
  /// Caller should fall back to the original URL when null is returned.
  Future<String?> uploadThumbnail(String uid, String imageUrl) async {
    if (imageUrl.isEmpty) return null;
    try {
      final response = await http
          .get(Uri.parse(imageUrl))
          .timeout(const Duration(seconds: 15));

      if (response.statusCode != 200) return null;

      final bytes = response.bodyBytes;
      if (bytes.isEmpty) return null;

      final contentType = response.headers['content-type'] ?? 'image/jpeg';
      final ext = _ext(contentType);
      final filename =
          '${DateTime.now().millisecondsSinceEpoch}.$ext';

      final ref = _storage.ref('users/$uid/thumbnails/$filename');
      await ref.putData(bytes, SettableMetadata(contentType: contentType));
      return await ref.getDownloadURL();
    } catch (_) {
      // Network error, storage error, timeout — fall back to original URL
      return null;
    }
  }

  String _ext(String contentType) {
    if (contentType.contains('png')) return 'png';
    if (contentType.contains('webp')) return 'webp';
    if (contentType.contains('gif')) return 'gif';
    return 'jpg';
  }
}
