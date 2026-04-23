class TransactionModel {
  final int? id;
  final int accountId;
  final int categoryId;
  final double amount;
  final String type; // income | expense
  final String? note;
  final DateTime date;
  final bool isRecurring;
  final String? recurInterval; // daily | weekly | monthly
  final DateTime createdAt;

  // Joined query fields
  final String? accountName;
  final String? categoryName;
  final String? categoryNameAr;
  final String? categoryIcon;
  final String? categoryColor;

  TransactionModel({
    this.id,
    required this.accountId,
    required this.categoryId,
    required this.amount,
    required this.type,
    this.note,
    required this.date,
    this.isRecurring = false,
    this.recurInterval,
    DateTime? createdAt,
    this.accountName,
    this.categoryName,
    this.categoryNameAr,
    this.categoryIcon,
    this.categoryColor,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'account_id': accountId,
      'category_id': categoryId,
      'amount': amount,
      'type': type,
      'note': note,
      'date': date.toIso8601String(),
      'is_recurring': isRecurring ? 1 : 0,
      'recur_interval': recurInterval,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'],
      accountId: map['account_id'],
      categoryId: map['category_id'],
      amount: (map['amount'] as num).toDouble(),
      type: map['type'],
      note: map['note'],
      date: DateTime.parse(map['date']),
      isRecurring: (map['is_recurring'] ?? 0) == 1,
      recurInterval: map['recur_interval'],
      createdAt: DateTime.parse(map['created_at']),
      accountName: map['account_name'],
      categoryName: map['category_name'],
      categoryNameAr: map['category_name_ar'],
      categoryIcon: map['category_icon'],
      categoryColor: map['category_color'],
    );
  }

  bool get isExpense => type == 'expense';
  bool get isIncome => type == 'income';
}
