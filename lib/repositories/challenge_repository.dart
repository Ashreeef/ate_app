import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/challenge.dart';

/// Repository for Challenge data operations using Firestore
class ChallengeRepository {
  final CollectionReference _challenges =
      FirebaseFirestore.instance.collection('challenges');

  // ==================== CREATE ====================

  /// Create a new challenge (restaurant owners only)
  Future<String> createChallenge({
    required String restaurantId,
    required String title,
    required String description,
    required ChallengeType type,
    required int targetCount,
    required DateTime startDate,
    required DateTime endDate,
    required String rewardBadge,
    String? imageUrl,
  }) async {
    try {
      final docRef = _challenges.doc();
      final challengeId = docRef.id;

      final challengeData = {
        'id': challengeId,
        'createdBy': restaurantId,
        'title': title,
        'description': description,
        'type': type.toString().split('.').last,
        'targetCount': targetCount,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
        'rewardBadge': rewardBadge,
        'isActive': true,
        'imageUrl': imageUrl,
        'createdAt': DateTime.now().toIso8601String(),
      };

      await docRef.set(challengeData);
      return challengeId;
    } catch (e) {
      throw Exception('Failed to create challenge: $e');
    }
  }

  // ==================== READ ====================

  /// Get all active challenges
  Future<List<Challenge>> getActiveChallenges() async {
    try {
      final now = DateTime.now();
      final snapshot = await _challenges
          .where('isActive', isEqualTo: true)
          .where('endDate', isGreaterThan: now.toIso8601String())
          .orderBy('endDate')
          .orderBy('startDate', descending: true)
          .limit(50)
          .get();

      return snapshot.docs
          .map((doc) => _challengeFromFirestore(
                doc.id,
                doc.data() as Map<String, dynamic>,
              ))
          .toList();
    } catch (e) {
      print('Error getting active challenges: $e');
      // If composite index doesn't exist yet, fallback to simple query
      try {
        final snapshot = await _challenges
            .where('isActive', isEqualTo: true)
            .limit(50)
            .get();

        final now = DateTime.now();
        return snapshot.docs
            .map((doc) => _challengeFromFirestore(
                  doc.id,
                  doc.data() as Map<String, dynamic>,
                ))
            .where((challenge) => challenge.endDate.isAfter(now))
            .toList();
      } catch (e2) {
        print('Error in fallback query: $e2');
        return [];
      }
    }
  }

  /// Get challenges created by a specific restaurant
  Future<List<Challenge>> getChallengesByRestaurant(String restaurantId) async {
    try {
      final snapshot = await _challenges
          .where('createdBy', isEqualTo: restaurantId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => _challengeFromFirestore(
                doc.id,
                doc.data() as Map<String, dynamic>,
              ))
          .toList();
    } catch (e) {
      print('Error getting restaurant challenges: $e');
      return [];
    }
  }

  /// Get a challenge by ID with user's participation status
  Future<Challenge?> getChallengeById(
    String challengeId, {
    String? userId,
  }) async {
    try {
      final doc = await _challenges.doc(challengeId).get();

      if (!doc.exists) return null;

      final challenge = _challengeFromFirestore(
        doc.id,
        doc.data() as Map<String, dynamic>,
      );

      // If userId provided, check participation
      if (userId != null) {
        final participationDoc = await _challenges
            .doc(challengeId)
            .collection('participants')
            .doc(userId)
            .get();

        if (participationDoc.exists) {
          final data = participationDoc.data()!;
          return challenge.copyWith(
            isJoined: true,
            currentCount: data['currentProgress'] as int? ?? 0,
          );
        }
      }

      return challenge;
    } catch (e) {
      print('Error getting challenge: $e');
      return null;
    }
  }

  /// Get challenges a user has joined
  Future<List<Challenge>> getUserActiveChallenges(String userId) async {
    try {
      // Get all challenge documents where user is in participants
      final allChallenges = await getActiveChallenges();
      final userChallenges = <Challenge>[];

      for (final challenge in allChallenges) {
        final participationDoc = await _challenges
            .doc(challenge.id)
            .collection('participants')
            .doc(userId)
            .get();

        if (participationDoc.exists) {
          final data = participationDoc.data()!;
          userChallenges.add(
            challenge.copyWith(
              isJoined: true,
              currentCount: data['currentProgress'] as int? ?? 0,
            ),
          );
        }
      }

      return userChallenges;
    } catch (e) {
      print('Error getting user challenges: $e');
      return [];
    }
  }

  // ==================== UPDATE ====================

  /// Join a challenge
  Future<void> joinChallenge(String challengeId, String userId) async {
    try {
      final participantRef = _challenges
          .doc(challengeId)
          .collection('participants')
          .doc(userId);

      await participantRef.set({
        'joinedAt': DateTime.now().toIso8601String(),
        'currentProgress': 0,
        'completedAt': null,
      });
    } catch (e) {
      throw Exception('Failed to join challenge: $e');
    }
  }

  /// Leave a challenge
  Future<void> leaveChallenge(String challengeId, String userId) async {
    try {
      await _challenges
          .doc(challengeId)
          .collection('participants')
          .doc(userId)
          .delete();
    } catch (e) {
      throw Exception('Failed to leave challenge: $e');
    }
  }

  /// Update challenge progress for a user
  Future<void> updateProgress({
    required String challengeId,
    required String userId,
    required int progress,
  }) async {
    try {
      final challenge = await getChallengeById(challengeId);
      if (challenge == null) return;

      final participantRef = _challenges
          .doc(challengeId)
          .collection('participants')
          .doc(userId);

      final completedAt = progress >= challenge.targetCount
          ? DateTime.now().toIso8601String()
          : null;

      await participantRef.update({
        'currentProgress': progress,
        'completedAt': completedAt,
      });
    } catch (e) {
      throw Exception('Failed to update progress: $e');
    }
  }

  /// Increment challenge progress by 1
  Future<void> incrementProgress({
    required String challengeId,
    required String userId,
  }) async {
    try {
      final participantRef = _challenges
          .doc(challengeId)
          .collection('participants')
          .doc(userId);

      final doc = await participantRef.get();
      if (!doc.exists) return;

      final currentProgress = (doc.data()?['currentProgress'] as int?) ?? 0;
      final newProgress = currentProgress + 1;

      final challenge = await getChallengeById(challengeId);
      if (challenge == null) return;

      final completedAt = newProgress >= challenge.targetCount
          ? DateTime.now().toIso8601String()
          : null;

      await participantRef.update({
        'currentProgress': newProgress,
        'completedAt': completedAt,
      });
    } catch (e) {
      throw Exception('Failed to increment progress: $e');
    }
  }

  /// Get user's participation data for a challenge
  Future<Map<String, dynamic>?> getChallengeParticipation(
    String challengeId,
    String userId,
  ) async {
    try {
      final doc = await _challenges
          .doc(challengeId)
          .collection('participants')
          .doc(userId)
          .get();

      return doc.data();
    } catch (e) {
      print('Error getting participation: $e');
      return null;
    }
  }

  /// Check if a user has completed a challenge
  Future<bool> isChallengeCompleted(
    String challengeId,
    String userId,
  ) async {
    try {
      final participation = await getChallengeParticipation(challengeId, userId);
      return participation?['completedAt'] != null;
    } catch (e) {
      return false;
    }
  }

  // ==================== DELETE ====================

  /// Delete a challenge (admin/restaurant owner only)
  Future<void> deleteChallenge(String challengeId) async {
    try {
      // Delete all participants
      final participants = await _challenges
          .doc(challengeId)
          .collection('participants')
          .get();

      for (final doc in participants.docs) {
        await doc.reference.delete();
      }

      // Delete challenge document
      await _challenges.doc(challengeId).delete();
    } catch (e) {
      throw Exception('Failed to delete challenge: $e');
    }
  }

  // ==================== HELPERS ====================

  /// Convert Firestore document to Challenge model
  Challenge _challengeFromFirestore(String id, Map<String, dynamic> data) {
    return Challenge(
      id: id,
      createdBy: data['createdBy'] as String?,
      title: data['title'] as String? ?? '',
      description: data['description'] as String? ?? '',
      imageUrl: data['imageUrl'] as String?,
      targetCount: data['targetCount'] as int? ?? 1,
      currentCount: 0, // Will be updated based on user participation
      rewardBadge: data['rewardBadge'] as String? ?? '',
      startDate: DateTime.parse(data['startDate'] as String),
      endDate: DateTime.parse(data['endDate'] as String),
      isActive: data['isActive'] as bool? ?? true,
      isJoined: false, // Will be updated based on user participation
      type: ChallengeType.values.firstWhere(
        (e) => e.toString().split('.').last == data['type'],
        orElse: () => ChallengeType.general,
      ),
    );
  }
}
