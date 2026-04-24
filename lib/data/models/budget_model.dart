class BudgetModel {
  final int? id;
  final int categoryId;
  final double amount;
  final String month; // ISO String or YYYY-MM-01

  BudgetModel({
    this.id,
    required this.categoryId,
    required this.amount,
    required this.month,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'category_id': categoryId,
      'amount': amount,
      'month': month,
    };
  }

  factory BudgetModel.fromMap(Map<String, dynamic> map) {
    return BudgetModel(
      id: map['id'],
      categoryId: map['category_id'],
      amount: map['amount'],
      month: map['month'],
    );
  }
}
