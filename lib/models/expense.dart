class Expense {
  final String id;
  final String name;
  final double amount;
  final String category;
  final String iconPath;
  final DateTime date;

  Expense({
    required this.id,
    required this.name,
    required this.amount,
    required this.category,
    required this.iconPath,
    required this.date,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'category': category,
      'iconPath': iconPath,
      'date': date.toIso8601String(),
    };
  }

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'],
      name: json['name'],
      amount: json['amount'],
      category: json['category'],
      iconPath: json['iconPath'],
      date: DateTime.parse(json['date']),
    );
  }
}