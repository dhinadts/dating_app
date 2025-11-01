import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final matchActionsProvider = Provider<MatchActions>((ref) {
  return MatchActions();
});

class MatchActions {
  final firestore = FirebaseFirestore.instance;

  Future<void> likeUser({
    required String currentUserId,
    required String targetUserId,
  }) async {
    // 1 → write like
    await firestore
        .collection('users')
        .doc(currentUserId)
        .collection('likes')
        .doc(targetUserId)
        .set({'likedAt': FieldValue.serverTimestamp()});

    // 2 → check if target also liked current
    final targetLikedCurrent = await firestore
        .collection('users')
        .doc(targetUserId)
        .collection('likes')
        .doc(currentUserId)
        .get();

    if (targetLikedCurrent.exists) {
      // 3 → create match in both
      await _createMatch(currentUserId, targetUserId);
      await _createMatch(targetUserId, currentUserId);
    }
  }

  Future<void> _createMatch(String uidA, String uidB) async {
    await firestore
        .collection('users')
        .doc(uidA)
        .collection('matches')
        .doc(uidB)
        .set({'matchedAt': FieldValue.serverTimestamp()});
  }

  Future<void> dislikeUser({
    required String currentUserId,
    required String targetUserId,
  }) async {
    // you can simply ignore or store dislikes
    await firestore
        .collection('users')
        .doc(currentUserId)
        .collection('dislikes')
        .doc(targetUserId)
        .set({'dislikedAt': FieldValue.serverTimestamp()});
  }
}
