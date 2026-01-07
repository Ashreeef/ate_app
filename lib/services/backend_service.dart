import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

/// Service for communicating with the ATE Flask backend.
/// Handles secure operations like image upload, moderation, and analytics.
class BackendService {
  // Production (Render):
  static const String _baseUrl = 'https://ate-backend.onrender.com';
  // For local development (Android emulator):
  // static const String _baseUrl = 'http://10.0.2.2:5000';
  // For local development (iOS simulator/web):
  // static const String _baseUrl = 'http://localhost:5000';

  /// Get the current user's Firebase ID token for authentication
  Future<String?> _getAuthToken() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;
    return await user.getIdToken();
  }

  /// Create authorization headers with Firebase token
  Future<Map<String, String>> _getHeaders({bool isJson = true}) async {
    final token = await _getAuthToken();
    final headers = <String, String>{'Authorization': 'Bearer $token'};
    if (isJson) {
      headers['Content-Type'] = 'application/json';
    }
    return headers;
  }

  // ==================== HEALTH CHECK ====================

  /// Check if the backend is available
  Future<bool> isBackendAvailable() async {
    try {
      debugPrint('🔍 BackendService: Checking backend at $_baseUrl/api/health');
      final response = await http
          .get(Uri.parse('$_baseUrl/api/health'))
          .timeout(const Duration(seconds: 5));
      debugPrint(
        '✅ BackendService: Backend responded with ${response.statusCode}',
      );
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('❌ BackendService: Backend unavailable - $e');
      return false;
    }
  }

  // ==================== IMAGE UPLOAD ====================

  /// Upload a single image to Cloudinary via the backend
  /// Returns the Cloudinary URL and public ID
  Future<ImageUploadResult> uploadImage(File imageFile) async {
    try {
      final token = await _getAuthToken();
      if (token == null) {
        return ImageUploadResult.failure('User not authenticated');
      }

      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$_baseUrl/api/images/upload'),
      );

      request.headers['Authorization'] = 'Bearer $token';
      request.files.add(
        await http.MultipartFile.fromPath('image', imageFile.path),
      );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return ImageUploadResult.success(
          url: data['url'],
          publicId: data['publicId'],
        );
      } else {
        final error = jsonDecode(response.body)['error'] ?? 'Upload failed';
        return ImageUploadResult.failure(error);
      }
    } catch (e) {
      return ImageUploadResult.failure('Network error: $e');
    }
  }

  /// Upload multiple images to Cloudinary via the backend
  Future<MultiImageUploadResult> uploadMultipleImages(
    List<File> imageFiles,
  ) async {
    try {
      final token = await _getAuthToken();
      if (token == null) {
        return MultiImageUploadResult.failure('User not authenticated');
      }

      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$_baseUrl/api/images/upload-multiple'),
      );

      request.headers['Authorization'] = 'Bearer $token';

      for (final file in imageFiles) {
        request.files.add(
          await http.MultipartFile.fromPath('images', file.path),
        );
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final images = (data['images'] as List)
            .map(
              (img) => ImageUploadResult.success(
                url: img['url'],
                publicId: img['publicId'],
              ),
            )
            .toList();
        return MultiImageUploadResult.success(images);
      } else {
        final error = jsonDecode(response.body)['error'] ?? 'Upload failed';
        return MultiImageUploadResult.failure(error);
      }
    } catch (e) {
      return MultiImageUploadResult.failure('Network error: $e');
    }
  }

  /// Delete an image from Cloudinary via the backend
  Future<bool> deleteImage(String publicId) async {
    try {
      final headers = await _getHeaders();
      final response = await http.delete(
        Uri.parse('$_baseUrl/api/images/$publicId'),
        headers: headers,
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // ==================== CONTENT MODERATION ====================

  /// Check text content for profanity and spam
  Future<ModerationResult> checkText(String text) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('$_baseUrl/api/moderation/check-text'),
        headers: headers,
        body: jsonEncode({'text': text}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return ModerationResult(
          safe: data['safe'] ?? true,
          issues: List<String>.from(data['issues'] ?? []),
          flaggedWords: List<String>.from(data['flaggedWords'] ?? []),
        );
      }
      return ModerationResult.safe();
    } catch (e) {
      // If moderation fails, allow content (fail open)
      return ModerationResult.safe();
    }
  }

  /// Validate a post before creation
  Future<ValidationResult> validatePost(
    String caption, {
    String? restaurantId,
  }) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('$_baseUrl/api/moderation/validate-post'),
        headers: headers,
        body: jsonEncode({'caption': caption, 'restaurantId': restaurantId}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return ValidationResult(
          valid: data['valid'] ?? true,
          errors: List<String>.from(data['errors'] ?? []),
        );
      }
      return ValidationResult.valid();
    } catch (e) {
      return ValidationResult.valid();
    }
  }

  /// Validate a comment before creation
  Future<ValidationResult> validateComment(String text) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('$_baseUrl/api/moderation/validate-comment'),
        headers: headers,
        body: jsonEncode({'text': text}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return ValidationResult(
          valid: data['valid'] ?? true,
          errors: List<String>.from(data['errors'] ?? []),
        );
      }
      return ValidationResult.valid();
    } catch (e) {
      return ValidationResult.valid();
    }
  }

  // ==================== ANALYTICS ====================

  /// Get trending posts or restaurants
  Future<List<Map<String, dynamic>>> getTrending({
    String type = 'posts',
    int limit = 10,
  }) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$_baseUrl/api/analytics/trending?type=$type&limit=$limit'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data['items'] ?? []);
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  /// Get leaderboard (top users by points)
  Future<List<Map<String, dynamic>>> getLeaderboard({int limit = 20}) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$_baseUrl/api/analytics/leaderboard?limit=$limit'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data['users'] ?? []);
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  /// Get user summary statistics
  Future<UserSummary?> getUserSummary(String uid) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$_baseUrl/api/analytics/user/$uid/summary'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return UserSummary.fromJson(data);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}

// ==================== RESULT CLASSES ====================

class ImageUploadResult {
  final bool isSuccess;
  final String? url;
  final String? publicId;
  final String? error;

  ImageUploadResult._({
    required this.isSuccess,
    this.url,
    this.publicId,
    this.error,
  });

  factory ImageUploadResult.success({
    required String url,
    required String publicId,
  }) {
    return ImageUploadResult._(isSuccess: true, url: url, publicId: publicId);
  }

  factory ImageUploadResult.failure(String error) {
    return ImageUploadResult._(isSuccess: false, error: error);
  }
}

class MultiImageUploadResult {
  final bool isSuccess;
  final List<ImageUploadResult>? images;
  final String? error;

  MultiImageUploadResult._({required this.isSuccess, this.images, this.error});

  factory MultiImageUploadResult.success(List<ImageUploadResult> images) {
    return MultiImageUploadResult._(isSuccess: true, images: images);
  }

  factory MultiImageUploadResult.failure(String error) {
    return MultiImageUploadResult._(isSuccess: false, error: error);
  }
}

class ModerationResult {
  final bool safe;
  final List<String> issues;
  final List<String> flaggedWords;

  ModerationResult({
    required this.safe,
    required this.issues,
    required this.flaggedWords,
  });

  factory ModerationResult.safe() {
    return ModerationResult(safe: true, issues: [], flaggedWords: []);
  }
}

class ValidationResult {
  final bool valid;
  final List<String> errors;

  ValidationResult({required this.valid, required this.errors});

  factory ValidationResult.valid() {
    return ValidationResult(valid: true, errors: []);
  }
}

class UserSummary {
  final int posts;
  final int likes;
  final int followers;
  final int following;
  final int points;
  final int rank;

  UserSummary({
    required this.posts,
    required this.likes,
    required this.followers,
    required this.following,
    required this.points,
    required this.rank,
  });

  factory UserSummary.fromJson(Map<String, dynamic> json) {
    return UserSummary(
      posts: json['posts'] ?? 0,
      likes: json['likes'] ?? 0,
      followers: json['followers'] ?? 0,
      following: json['following'] ?? 0,
      points: json['points'] ?? 0,
      rank: json['rank'] ?? 0,
    );
  }
}
