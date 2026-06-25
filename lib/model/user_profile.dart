class UserProfile {
  final String uid;
  final String name;
  final String email;
  final int? phone;
  final String? address;

  const UserProfile({
    required this.uid,
    required this.name,
    required this.email,
    this.phone,
    this.address,
  });

  static int? parsePhone(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) {
      final digits = value.replaceAll(RegExp(r'\D'), '');
      if (digits.isEmpty) return null;
      return int.tryParse(digits);
    }
    return null;
  }

  factory UserProfile.fromFirestore(Map<String, dynamic> data, String uid) {
    return UserProfile(
      uid: uid,
      name: data['name'] as String? ?? '',
      email: data['email'] as String? ?? '',
      phone: parsePhone(data['phone']),
      address: data['address'] as String?,
    );
  }

  UserProfile copyWith({
    String? name,
    String? email,
    int? phone,
    String? address,
  }) {
    return UserProfile(
      uid: uid,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
    };
  }
}
