// lib/screens/discover_screen.dart
// ignore_for_file: deprecated_member_use

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../features/profiles/profiles_pager.dart';
import '../features/match/match_actions_provider.dart';

class DiscoverScreen extends ConsumerStatefulWidget {
  const DiscoverScreen({super.key});

  @override
  ConsumerState<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends ConsumerState<DiscoverScreen> {
  static const _loadMoreThreshold =
      3; // when remaining items <= this, load more
  var currentUserId = '';
  @override
  void initState() {
    super.initState();
    // load initial page
    // _refresh();
    Future.microtask(
      () => ref.read(profilesPagerProvider.notifier).loadInitial(),
    );
  }

  

  @override
  Widget build(BuildContext context) {
    final pager = ref.watch(profilesPagerProvider);
    final pagerNotifier = ref.read(profilesPagerProvider.notifier);

    if (pager.loadingInitial && pager.items.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (pager.error != null && pager.items.isEmpty) {
      return Scaffold(body: Center(child: Text('Error: ${pager.error}')));
    }

    if (pager.items.isEmpty) {
      return const Scaffold(body: Center(child: Text('No users found')));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Discover')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 12),
              itemCount: pager.items.length,
              itemBuilder: (context, index) {
                final profile = pager.items[index];

                // When only a few left, trigger loadMore
                if (pager.hasMore &&
                    (pager.items.length - index) <= _loadMoreThreshold) {
                  pagerNotifier.loadMore();
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: Dismissible(
                    key: ValueKey(profile.uid),
                    direction: DismissDirection.horizontal,
                    onDismissed: (direction) async {
                      final authUser = FirebaseAuth.instance.currentUser;
                      if (authUser == null) return;

                      final currentUserId = authUser.uid;
                      // call like/dislike provider
                      if (direction == DismissDirection.endToStart) {
                        // left swipe -> dislike
                        await ref
                            .read(matchActionsProvider)
                            .dislikeUser(
                              currentUserId: currentUserId,
                              targetUserId: profile.uid,
                            );
                      } else {
                        // right swipe -> like
                        await ref
                            .read(matchActionsProvider)
                            .likeUser(
                              currentUserId: currentUserId,
                              targetUserId: profile.uid,
                            );
                      }

                      // remove locally
                      pagerNotifier.remove(profile.uid);
                    },
                    background: Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 20),
                      color: Colors.greenAccent.withOpacity(0.9),
                      child: const Icon(Icons.favorite, color: Colors.white),
                    ),
                    secondaryBackground: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      color: Colors.redAccent.withOpacity(0.9),
                      child: const Icon(Icons.close, color: Colors.white),
                    ),
                    child: _ProfileCard(profile: profile),
                  ),
                );
              },
            ),
          ),

          // footer loader / status
          if (pager.loadingMore)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: CircularProgressIndicator(),
            )
          else if (!pager.hasMore)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Text('No more users'),
            )
          else
            const SizedBox(height: 12),
        ],
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  final Profile profile;
  const _ProfileCard({required this.profile});

  @override
  Widget build(BuildContext context) {
    // FIX: use fixed height so ListView layout is stable
    return SizedBox(
      height: 420,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 6,
        clipBehavior: Clip.hardEdge,
        child: Column(
          children: [
            Expanded(
              child: profile.imageUrl.isNotEmpty
                  ? Image.network(
                      profile.imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (c, e, s) => Container(
                        color: Colors.grey[300],
                        child: const Center(
                          child: Icon(Icons.image_not_supported),
                        ),
                      ),
                    )
                  : Container(
                      color: Colors.grey[300],
                      child: const Center(child: Icon(Icons.person)),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '${profile.name}, ${profile.age}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      // quick like button
                      // you may want to call provider here too
                    },
                    icon: const Icon(Icons.favorite_border),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
