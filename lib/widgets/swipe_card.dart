import 'package:flutter/material.dart';

class SwipeCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final int index;
  const SwipeCard({super.key, required this.data, required this.index});

  @override
  Widget build(BuildContext context) {
    final photos = List<String>.from(data['photos'] ?? []);
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      child: Card(
        margin: const EdgeInsets.all(24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          children: [
            Expanded(
              child: photos.isNotEmpty
                  ? Image.network(
                      photos.first,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    )
                  : Container(color: Colors.grey),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data['displayName'] ?? 'Unknown',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(data['bio'] ?? ''),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FloatingActionButton(
                        heroTag: "chat-fab",

                        onPressed: () {
                          /* pass */
                        },
                        child: const Icon(Icons.close),
                      ),
                      FloatingActionButton(
                        heroTag: null,
                        onPressed: () {
                          /* like */
                        },
                        child: const Icon(Icons.favorite),
                      ),
                    ],
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
