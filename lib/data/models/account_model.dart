class AccountModel {
  final int? id;
  final String name;
  final String type; // cash, bank, credit, savings
  final double balance;
  final String currency;
  final String color;
  final String icon;
  final DateTime createdAt;

  AccountModel({
    this.id,
    required this.name,
    required this.type,
    required this.balance,
    this.currency = 'EGP',
    this.color = '#102C26',
    this.icon = 'wallet',
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'balance': balance,
      'currency': currency,
      'color': color,
      'icon': icon,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory AccountModel.fromMap(Map<String, dynamic> map) {
    return AccountModel(
      id: map['id'],
      name: map['name'],
      type: map['type'],
      balance: (map['balance'] as num).toDouble(),
      currency: map['currency'] ?? 'EGP',
      color: map['color'] ?? '#102C26',
      icon: map['icon'] ?? 'wallet',
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  AccountModel copyWith({
    int? id,
    String? name,
    String? type,
    double? balance,
    String? currency,
    String? color,
    String? icon,
  }) {
    return AccountModel(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      balance: balance ?? this.balance,
      currency: currency ?? this.currency,
      color: color ?? this.color,
      icon: icon ?? this.icon,
      createdAt: createdAt,
    );
  }
}
