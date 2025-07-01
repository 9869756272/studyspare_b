class UserModel {
  final String id;
  final String name;
  final String email;
  final String role;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required String password,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      password: json['password'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'name': name, 'email': email, 'role': role};
  }

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, email: $email, role: $role)';
  }
}
