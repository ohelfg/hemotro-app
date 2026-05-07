class User {
  final String id;
  final String email;
  final String name;
  final String? avatar;
  final bool isVerified;
  final String role;
  final DateTime createdAt;
  final DateTime? lastLogin;

  User({
    required this.id,
    required this.email,
    required this.name,
    this.avatar,
    required this.isVerified,
    required this.role,
    required this.createdAt,
    this.lastLogin,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      avatar: json['avatar'],
      isVerified: json['isVerified'] ?? false,
      role: json['role'] ?? 'user',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      lastLogin: json['lastLogin'] != null
          ? DateTime.parse(json['lastLogin'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'avatar': avatar,
      'isVerified': isVerified,
      'role': role,
      'createdAt': createdAt.toIso8601String(),
      'lastLogin': lastLogin?.toIso8601String(),
    };
  }

  bool get isAdmin => role == 'admin';
}
