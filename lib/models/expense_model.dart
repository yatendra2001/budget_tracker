import 'package:enum_to_string/enum_to_string.dart';

enum TypeOfExpense { home, transport, food, others }

class Expense {
  final int? id;
  final String name;
  final DateTime date;
  final TypeOfExpense typeOfExpense;
  final double money;

  const Expense(
      {this.id,
      required this.name,
      required this.date,
      required this.typeOfExpense,
      required this.money});

  // To modify values
  Expense copyWith({
    int? id,
    String? name,
    DateTime? date,
    double? money,
    TypeOfExpense? typeOfExpense,
  }) {
    return Expense(
        id: id ?? this.id,
        name: name ?? this.name,
        date: date ?? this.date,
        typeOfExpense: typeOfExpense ?? this.typeOfExpense,
        money: money ?? this.money);
  }

  // Map Expenses to database correctly
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'date': date.toIso8601String(),
      'type_of_expense': EnumToString.convertToString(typeOfExpense),
      'money': money
    };
  }

  // Pull out data from database and convert it again to Expense
  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'] as int,
      name: map['name'] as String,
      date: DateTime.parse(map['date'] as String),
      typeOfExpense: EnumToString.fromString(
          TypeOfExpense.values, map['type_of_expense'] as String)!,
      money: double.parse(map['money']),
    );
  }
}
