class DebtModel {
  final int? id;
  final String personName;
  final double amount;
  final String type; // 'lend' (they owe me) | 'borrow' (I owe them)
  final bool isPaid;
  final DateTime date;
  final DateTime? dueDate;
  final String? note;

  DebtModel({
    this.id,
    required this.personName,
    required this.amount,
    required this.type,
    this.isPaid = false,
    required this.date,
    this.dueDate,
    this.note,
  });

  bool get theyOweMe => type == 'lend';

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'person_name': personName,
      'amount': amount,
      'type': type,
      'is_paid': isPaid ? 1 : 0,
      'date': date.toIso8601String(),
      'due_date': dueDate?.toIso8601String(),
      'note': note,
    };
  }

  factory DebtModel.fromMap(Map<String, dynamic> map) {
    return DebtModel(
      id: map['id'],
      personName: map['person_name'],
      amount: map['amount'],
      type: map['type'],
      isPaid: map['is_paid'] == 1,
      date: DateTime.parse(map['date']),
      dueDate: map['due_date'] != null ? DateTime.parse(map['due_date']) : null,
      note: map['note'],
    );
  }
}
