import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../providers/user_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserDocProvider);
    return currentUser.when(
      data: (user) => user == null
          ? const Center(child: Text('No profile'))
          : Scaffold(
              appBar: AppBar(title: Text(user.displayName)),
              body: Column(
                children: [
                  if (user.photos.isNotEmpty)
                    Image.network(
                      user.photos.first,
                      height: 250,
                      fit: BoxFit.cover,
                    ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(user.bio),
                  ),
                ],
              ),
            ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => Center(child: Text('Error: $e')),
    );
  }
}
