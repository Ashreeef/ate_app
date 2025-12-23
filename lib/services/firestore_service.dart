import 'package:cloud_firestore/cloud_firestore.dart';

/// Firestore Service
/// Base service for Firestore operations
class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection references
  CollectionReference get users => _firestore.collection('users');
  CollectionReference get posts => _firestore.collection('posts');
  CollectionReference get restaurants => _firestore.collection('restaurants');
  CollectionReference get follows => _firestore.collection('follows');
  CollectionReference get savedPosts => _firestore.collection('savedPosts');

  /// Enable offline persistence
  Future<void> enableOfflinePersistence() async {
    _firestore.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );
  }

  /// Batch write operations
  WriteBatch batch() => _firestore.batch();

  /// Transaction operations
  Future<T> runTransaction<T>(TransactionHandler<T> transactionHandler) {
    return _firestore.runTransaction(transactionHandler);
  }

  /// Get server timestamp
  FieldValue get serverTimestamp => FieldValue.serverTimestamp();

  /// Increment field value
  FieldValue increment(num value) => FieldValue.increment(value);

  /// Array union (add to array if not exists)
  FieldValue arrayUnion(List elements) => FieldValue.arrayUnion(elements);

  /// Array remove
  FieldValue arrayRemove(List elements) => FieldValue.arrayRemove(elements);
}
