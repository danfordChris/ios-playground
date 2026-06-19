class UserSession {
  const UserSession({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  final String id;
  final String name;
  final String email;
  final String role;

  /// Convert to JSON-compatible map
  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'email': email,
    'role': role,
  };

  /// Create from JSON map
  static UserSession fromMap(Map<String, dynamic> map) => UserSession(
    id: map['id'] as String? ?? '',
    name: map['name'] as String? ?? 'User',
    email: map['email'] as String? ?? '',
    role: map['role'] as String? ?? 'User',
  );
}
