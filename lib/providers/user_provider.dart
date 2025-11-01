import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../models/app_user.dart';
import 'auth_provider.dart';

final firestoreProvider = Provider<FirebaseFirestore>(
  (ref) => FirebaseFirestore.instance,
);

final currentUserDocProvider = StreamProvider.autoDispose<AppUser?>((ref) {
  final auth = ref.watch(authStateChangesProvider);
  final firestore = ref.watch(firestoreProvider);
  final user = auth.asData?.value;
  if (user == null) return Stream.value(null);
  final doc = firestore.collection('users').doc(user.uid);
  return doc.snapshots().map(
    (snap) => snap.exists
        ? AppUser.fromMap(snap.id, snap.data() as Map<String, dynamic>)
        : null,
  );
});



