class AppUser {
  final String uid;
  final String displayName;
  final int age;
  final String bio;
  final List<String> photos;

  AppUser({
    required this.uid,
    required this.displayName,
    required this.age,
    required this.bio,
    required this.photos,
  });

  factory AppUser.fromMap(String uid, Map<String, dynamic> map) {
    return AppUser(
      uid: uid,
      displayName: map['displayName'] ?? '',
      age: map['age'] ?? 0,
      bio: map['bio'] ?? '',
      photos: List<String>.from(map['photos'] ?? []),
    );
  }

  Map<String, dynamic> toMap() => {
    'displayName': displayName,
    'age': age,
    'bio': bio,
    'photos': photos,
  };
}
