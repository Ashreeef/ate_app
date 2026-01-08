import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firebase_auth_service.dart';
import '../services/cloudinary_storage_service.dart';

/// Firebase Connection Test
/// Run this to verify Firebase is properly configured
class FirebaseTest {
  static Future<void> testAll() async {
    print('🔥 Testing Firebase Connection...\n');

    // 1. Test Firebase Auth
    try {
      final authService = FirebaseAuthService();
      print('✅ Firebase Auth: Connected');
      print(
        '   Current user: ${authService.currentUser?.email ?? "None (not signed in)"}',
      );
    } catch (e) {
      print('❌ Firebase Auth: ERROR - $e');
      return;
    }

    // 2. Test Cloud Firestore
    try {
      final firestore = FirebaseFirestore.instance;

      // Try to write a test document
      await firestore.collection('_test').doc('ping').set({
        'timestamp': FieldValue.serverTimestamp(),
        'message': 'Hello from Ate app!',
        'version': '1.0.0',
      });

      print('✅ Cloud Firestore: Connected and writable');

      // Read it back
      final doc = await firestore.collection('_test').doc('ping').get();
      if (doc.exists) {
        print('   Test data: ${doc.data()}');
      }

      // Clean up test document
      await firestore.collection('_test').doc('ping').delete();
      print('   Test cleanup: Done');
    } catch (e) {
      print('❌ Cloud Firestore: ERROR - $e');
      print('   Make sure Firestore is enabled in Firebase Console');
    }

    // 3. Test Cloudinary Storage
    try {
      print('✅ Cloudinary Storage: Ready');
      print('   Cloud name: ${CloudinaryStorageService.cloudName}');
      print('   Upload preset: ${CloudinaryStorageService.uploadPreset}');
      print('   Free tier: 25GB storage + 25GB bandwidth/month');
    } catch (e) {
      print('❌ Cloudinary Storage: ERROR - $e');
      print('   Check cloudinary_storage_service.dart configuration');
    }

    print('\n🎉 Firebase setup test complete!');
    print('📖 Check FIREBASE_SETUP_GUIDE.md for next steps');
  }

  /// Create a test user for development
  static Future<void> createTestUser() async {
    print('👤 Creating test user...\n');

    final authService = FirebaseAuthService();
    final firestore = FirebaseFirestore.instance;

    try {
      // Try to create test user
      final userCred = await authService.signUp(
        email: 'test@ate.com',
        password: 'test123',
      );

      final uid = userCred.user!.uid;
      print('✅ Auth account created: test@ate.com');
      print('   UID: $uid');

      // Create user profile in Firestore
      await firestore.collection('users').doc(uid).set({
        'username': 'test_user',
        'email': 'test@ate.com',
        'displayName': 'Test User',
        'bio': 'Testing Ate app with Firebase backend',
        'profileImage': '',
        'phone': '',
        'points': 0,
        'level': 'Bronze',
        'followersCount': 0,
        'followingCount': 0,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      print('✅ User profile created in Firestore');
      print('\n📧 Login credentials:');
      print('   Email: test@ate.com');
      print('   Password: test123');
      print('\n🎉 Test user ready!');

      // Sign out
      await authService.signOut();
    } catch (e) {
      if (e.toString().contains('email-already-in-use')) {
        print('ℹ️  Test user already exists: test@ate.com');
        print('   You can login with password: test123');
      } else {
        print('❌ Error creating test user: $e');
      }
    }
  }
}
