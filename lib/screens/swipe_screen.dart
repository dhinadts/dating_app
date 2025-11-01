/* import 'package:dating_app/features/match/match_actions_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../match/match_actions_provider.dart';

class SwipeScreen extends ConsumerWidget {
  const SwipeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final users = [
      {"id": "u1", "name": "Asha", "age": 23},
      {"id": "u2", "name": "Meera", "age": 25},
      {"id": "u3", "name": "Lena", "age": 22},
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          for (var i = 0; i < users.length; i++)
            Positioned.fill(
              child: GestureDetector(
                onPanEnd: (details) {
                  if (details.velocity.pixelsPerSecond.dx > 0) {
                    ref.read(matchActionsProvider).like(users[i]["id"]!);
                  } else {
                    ref.read(matchActionsProvider).dislike(users![i]!["id"]!);
                  }
                },
                child: Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: Container(
                    alignment: Alignment.bottomLeft,
                    padding: const EdgeInsets.all(24),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.purple, Colors.red],
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Text(
                      "${users[i]["name"]}, ${users[i]["age"]}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
} */
