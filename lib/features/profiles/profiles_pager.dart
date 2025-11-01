// lib/features/profiles/profiles_pager.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';

final firestoreProvider = Provider<FirebaseFirestore>(
  (ref) => FirebaseFirestore.instance,
);

// Model for a profile (simple)
class Profile {
  final String uid;
  final String name;
  final int age;
  final String imageUrl;

  Profile({
    required this.uid,
    required this.name,
    required this.age,
    required this.imageUrl,
  });

  factory Profile.fromDoc(QueryDocumentSnapshot doc) {
    final m = doc.data() as Map<String, dynamic>;
    return Profile(
      uid: doc.id,
      name: (m['name'] ?? '') as String,
      age: (m['age'] ?? 0) as int,
      imageUrl: (m['imageUrl'] ?? '') as String,
    );
  }
}

class ProfilesPagerState {
  final List<Profile> items;
  final bool loadingInitial;
  final bool loadingMore;
  final bool hasMore;
  final String? error;

  ProfilesPagerState({
    required this.items,
    required this.loadingInitial,
    required this.loadingMore,
    required this.hasMore,
    this.error,
  });

  ProfilesPagerState copyWith({
    List<Profile>? items,
    bool? loadingInitial,
    bool? loadingMore,
    bool? hasMore,
    String? error,
  }) {
    return ProfilesPagerState(
      items: items ?? this.items,
      loadingInitial: loadingInitial ?? this.loadingInitial,
      loadingMore: loadingMore ?? this.loadingMore,
      hasMore: hasMore ?? this.hasMore,
      error: error,
    );
  }

  factory ProfilesPagerState.initial() => ProfilesPagerState(
    items: [],
    loadingInitial: false,
    loadingMore: false,
    hasMore: true,
    error: null,
  );
}

class ProfilesPager extends StateNotifier<ProfilesPagerState> {
  final FirebaseFirestore _firestore;
  final int pageSize;
  QueryDocumentSnapshot? _lastDoc;

  ProfilesPager({required FirebaseFirestore firestore, this.pageSize = 10})
    : _firestore = firestore,
      super(ProfilesPagerState.initial());

  Future<void> loadInitial() async {
    if (state.loadingInitial) return;
    state = state.copyWith(loadingInitial: true, error: null);

    try {
      final q = _firestore
          .collection('users')
          // provide an order so startAfter works deterministically. If you have createdAt, use that instead.
          .orderBy('name')
          .limit(pageSize);

      final snap = await q.get();
      final docs = snap.docs;
      final items = docs.map((d) => Profile.fromDoc(d)).toList();

      _lastDoc = docs.isNotEmpty ? docs.last : null;

      state = state.copyWith(
        items: items,
        loadingInitial: false,
        hasMore: docs.length == pageSize,
      );
    } catch (e) {
      state = state.copyWith(loadingInitial: false, error: e.toString());
      // optionally log st
    }
  }

  Future<void> loadMore() async {
    if (state.loadingMore || !state.hasMore) return;
    if (_lastDoc == null) return; // nothing to page from

    state = state.copyWith(loadingMore: true, error: null);

    try {
      final q = _firestore
          .collection('users')
          .orderBy('name')
          .startAfterDocument(_lastDoc!)
          .limit(pageSize);

      final snap = await q.get();
      final docs = snap.docs;
      final more = docs.map((d) => Profile.fromDoc(d)).toList();

      _lastDoc = docs.isNotEmpty ? docs.last : _lastDoc;

      state = state.copyWith(
        items: [...state.items, ...more],
        loadingMore: false,
        hasMore: docs.length == pageSize,
      );
    } catch (e) {
      state = state.copyWith(loadingMore: false, error: e.toString());
    }
  }

  /// remove item locally (e.g. after like/dislike). Does NOT delete from Firestore.
  void remove(String uid) {
    final updated = state.items.where((p) => p.uid != uid).toList();
    state = state.copyWith(items: updated);
  }

  /// refresh - clear and reload
  Future<void> refresh() async {
    _lastDoc = null;
    state = ProfilesPagerState.initial();
    await loadInitial();
  }
}

final profilesPagerProvider =
    StateNotifierProvider<ProfilesPager, ProfilesPagerState>((ref) {
      final firestore = ref.watch(firestoreProvider);
      return ProfilesPager(firestore: firestore, pageSize: 8);
    });
