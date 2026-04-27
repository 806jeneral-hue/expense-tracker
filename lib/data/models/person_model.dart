class PersonModel {
  final int? id;
  final String name;
  final String? phone;
  final String? email;
  final DateTime createdAt;

  PersonModel({
    this.id,
    required this.name,
    this.phone,
    this.email,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory PersonModel.fromMap(Map<String, dynamic> map) {
    return PersonModel(
      id: map['id'],
      name: map['name'],
      phone: map['phone'],
      email: map['email'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  PersonModel copyWith({
    int? id,
    String? name,
    String? phone,
    String? email,
    DateTime? createdAt,
  }) {
    return PersonModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}