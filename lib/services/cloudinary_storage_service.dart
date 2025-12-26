import 'dart:io';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class CloudinaryStorageService {
  static const String cloudName = 'db75kcrwj';
  static const String uploadPreset = 'ate_app_preset';

  final CloudinaryPublic _cloudinary = CloudinaryPublic(
    cloudName,
    uploadPreset,
    cache: false,
  );

  /// Upload profile image
  /// Returns the Cloudinary URL
  Future<String> uploadProfileImage(File imageFile, String userId) async {
    try {
      // Compress image first
      final compressed = await _compressImage(imageFile);

      // Upload to Cloudinary with transformation
      final response = await _cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          compressed.path,
          folder: 'profiles/$userId',
          resourceType: CloudinaryResourceType.Image,
        ),
      );

      // Return optimized URL
      return response.secureUrl;
    } catch (e) {
      throw Exception('Failed to upload profile image: $e');
    }
  }

  /// Upload post images (multiple)
  /// Returns list of Cloudinary URLs
  Future<List<String>> uploadPostImages(
    List<File> imageFiles,
    String userId,
  ) async {
    try {
      if (imageFiles.isEmpty) return [];

      // Validate files exist
      for (var file in imageFiles) {
        if (!await file.exists()) {
          throw Exception('File not found: ${file.path}');
        }
      }

      final uploadTasks = <Future<String>>[];

      for (int i = 0; i < imageFiles.length; i++) {
        uploadTasks.add(_uploadPostImage(imageFiles[i], userId, i));
      }

      return await Future.wait(uploadTasks);
    } catch (e) {
      throw Exception('Failed to upload post images: $e');
    }
  }

  /// Upload single post image
  Future<String> _uploadPostImage(
    File imageFile,
    String userId,
    int index,
  ) async {
    final compressed = await _compressImage(imageFile);
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    final response = await _cloudinary.uploadFile(
      CloudinaryFile.fromFile(
        compressed.path,
        folder: 'posts/$userId',
        publicId: '$timestamp-$index',
        resourceType: CloudinaryResourceType.Image,
      ),
    );

    return response.secureUrl;
  }

  /// Compress image to reduce upload size and improve performance
  Future<File> _compressImage(File file) async {
    try {
      final filePath = file.absolute.path;
      final directory = await getTemporaryDirectory();
      final targetPath = path.join(
        directory.path,
        '${path.basenameWithoutExtension(filePath)}_compressed.jpg',
      );

      final result = await FlutterImageCompress.compressAndGetFile(
        filePath,
        targetPath,
        quality: 85, // Good balance between quality and size
        minWidth: 1080,
        minHeight: 1080,
      );

      if (result != null) {
        return File(result.path);
      }

      // If compression fails, return original
      return file;
    } catch (e) {
      print('Image compression error: $e');
      return file; // Return original if compression fails
    }
  }

  /// Delete image from Cloudinary
  /// Note: Requires admin API (not available in free tier via client)
  /// For now, images will be auto-deleted after 30 days (set in Cloudinary dashboard)
  Future<void> deleteImage(String imageUrl) async {
    // Cloudinary free tier doesn't allow deletion from client
    // Set auto-delete policy in Cloudinary dashboard instead
    print('Image deletion: Set auto-cleanup in Cloudinary dashboard');
  }

  /// Get optimized image URL with transformations
  /// Example: Resize, crop, optimize format
  String getOptimizedUrl(
    String originalUrl, {
    int? width,
    int? height,
    String quality = 'auto',
  }) {
    // Cloudinary automatically optimizes
    // You can add transformations to the URL
    final transformations = <String>[];

    if (width != null) transformations.add('w_$width');
    if (height != null) transformations.add('h_$height');
    transformations.add('q_$quality');
    transformations.add('f_auto'); // Auto format (WebP when supported)

    final transformation = transformations.join(',');
    return originalUrl.replaceFirst('/upload/', '/upload/$transformation/');
  }

  /// Get thumbnail URL (for feed previews)
  String getThumbnailUrl(String originalUrl) {
    return getOptimizedUrl(originalUrl, width: 400, height: 400, quality: '80');
  }
}
