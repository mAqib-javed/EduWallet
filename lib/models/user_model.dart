class PigeonUserDetails {
  final String uid;
  final String name;
  final String email;
  final String? dateOfBirth;

  PigeonUserDetails({
    required this.uid,
    required this.name,
    required this.email,
    this.dateOfBirth,
  });

  factory PigeonUserDetails.fromMap(Map<String, dynamic> map) {
    print('🔵 [MODEL] Creating PigeonUserDetails from map: $map');
    try {
      final user = PigeonUserDetails(
        uid: map['uid']?.toString() ?? '',
        name: map['name']?.toString() ?? '',
        email: map['email']?.toString() ?? '',
        dateOfBirth: map['dateOfBirth']?.toString(),
      );
      print('✅ [MODEL] Successfully created user: ${user.email}');
      return user;
    } catch (e) {
      print('❌ [MODEL] Error creating user from map: $e');
      rethrow;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'dateOfBirth': dateOfBirth,
    };
  }
}