import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddProfiles {
  Future<void> insertSampleUsers() async {
    final firestore = FirebaseFirestore.instance;

    final samples = [
      {
        'name': 'Ava',
        'age': 22,
        'imageUrl': 'https://randomuser.me/api/portraits/women/21.jpg',
      },
      {
        'name': 'Mia',
        'age': 24,
        'imageUrl': 'https://randomuser.me/api/portraits/women/31.jpg',
      },
      {
        'name': 'Sophia',
        'age': 25,
        'imageUrl': 'https://randomuser.me/api/portraits/women/41.jpg',
      },
      {
        'name': 'Olivia',
        'age': 23,
        'imageUrl': 'https://randomuser.me/api/portraits/women/51.jpg',
      },
      {
        'name': 'Emma',
        'age': 26,
        'imageUrl': 'https://randomuser.me/api/portraits/women/61.jpg',
      },
      {
        'name': 'Noah',
        'age': 27,
        'imageUrl': 'https://randomuser.me/api/portraits/men/11.jpg',
      },
      {
        'name': 'Liam',
        'age': 28,
        'imageUrl': 'https://randomuser.me/api/portraits/men/21.jpg',
      },
      {
        'name': 'James',
        'age': 24,
        'imageUrl': 'https://randomuser.me/api/portraits/men/31.jpg',
      },
      {
        'name': 'Lucas',
        'age': 26,
        'imageUrl': 'https://randomuser.me/api/portraits/men/41.jpg',
      },
      {
        'name': 'Ethan',
        'age': 29,
        'imageUrl': 'https://randomuser.me/api/portraits/men/51.jpg',
      },
    ];

    for (final u in samples) {
      // add document — Firestore auto generates a uid
      await firestore.collection('users').add(u);
    }

    debugPrint("Sample users inserted ✅");
  }
}
