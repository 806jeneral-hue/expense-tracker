class RecurringModel {
  final int? id;
  final int accountId;
  final int categoryId;
  final double amount;
  final String type; // 'income' or 'expense'
  final String? note;
  final String frequency; // 'daily', 'weekly', 'monthly', 'yearly'
  final DateTime nextExecution;
  final bool isActive;

  RecurringModel({
    this.id,
    required this.accountId,
    required this.categoryId,
    required this.amount,
    required this.type,
    this.note,
    required this.frequency,
    required this.nextExecution,
    this.isActive = true,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'account_id': accountId,
      'category_id': categoryId,
      'amount': amount,
      'type': type,
      'note': note,
      'frequency': frequency,
      'next_execution': nextExecution.toIso8601String(),
      'is_active': isActive ? 1 : 0,
    };
  }

  factory RecurringModel.fromMap(Map<String, dynamic> map) {
    return RecurringModel(
      id: map['id'],
      accountId: map['account_id'],
      categoryId: map['category_id'],
      amount: map['amount'],
      type: map['type'],
      note: map['note'],
      frequency: map['frequency'],
      nextExecution: DateTime.parse(map['next_execution']),
      isActive: map['is_active'] == 1,
    );
  }
}
