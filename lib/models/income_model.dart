import 'package:enum_to_string/enum_to_string.dart';

enum TypeOfIncome { salary, profit, others }

class Income {
  final int? id;
  final String name;
  final DateTime date;
  final TypeOfIncome typeOfIncome;
  final double money;

  const Income(
      {this.id,
      required this.name,
      required this.date,
      required this.typeOfIncome,
      required this.money});

  // To modify values
  Income copyWith({
    int? id,
    String? name,
    DateTime? date,
    double? money,
    TypeOfIncome? typeOfIncome,
  }) {
    return Income(
        id: id ?? this.id,
        name: name ?? this.name,
        date: date ?? this.date,
        typeOfIncome: typeOfIncome ?? this.typeOfIncome,
        money: money ?? this.money);
  }

  // Map Incomes to database correctly
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'date': date.toIso8601String(),
      'type_of_income': EnumToString.convertToString(typeOfIncome),
      'money': money
    };
  }

  // Pull out data from database and convert it again to Income
  factory Income.fromMap(Map<String, dynamic> map) {
    return Income(
      id: map['id'] as int,
      name: map['name'] as String,
      date: DateTime.parse(map['date'] as String),
      typeOfIncome: EnumToString.fromString(
          TypeOfIncome.values, map['type_of_income'] as String)!,
      money: double.parse(map['money']),
    );
  }
}
