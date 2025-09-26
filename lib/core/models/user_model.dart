class UserModel {
  final int id;
  final String fullName;
  final String phone;
  final String address;
  final String email;
  final String imageUrl;
  final String? emailVerifiedAt;

  UserModel({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.address,
    required this.email,
    required this.imageUrl,
    this.emailVerifiedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      fullName: json['full_name'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      email: json['email'] ?? '',
      imageUrl: json['image_url'] ?? '',
      emailVerifiedAt: json['email_verified_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'phone': phone,
      'address': address,
      'email': email,
      'image_url': imageUrl,
      'email_verified_at': emailVerifiedAt,
    };
  }

  // Check if email is verified
  bool get isEmailVerified => emailVerifiedAt != null;

  // Get initials for avatar
  String get initials {
    final names = fullName.split(' ');
    if (names.length >= 2) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    } else if (names.isNotEmpty) {
      return names[0][0].toUpperCase();
    }
    return 'U';
  }

  @override
  String toString() {
    return 'UserModel(id: $id, fullName: $fullName, email: $email, phone: $phone)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
