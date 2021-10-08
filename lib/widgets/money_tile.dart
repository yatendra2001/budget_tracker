import 'package:budget_tracker/constants.dart';
import 'package:budget_tracker/extension/string_extension.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:budget_tracker/models/expense_model.dart';
import 'package:budget_tracker/screens/add_expense_screen.dart';

class ExpenseTile extends StatelessWidget {
  final Expense expense;
  final VoidCallback updateExpenses;

  const ExpenseTile(
      {Key? key, required this.expense, required this.updateExpenses})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
            color:
                _getColor(EnumToString.convertToString(expense.typeOfExpense))),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        tileColor: Colors.white,
        key: Key(expense.id.toString()),
        title: Text(
          expense.name,
          style: const TextStyle(fontSize: 18.0),
        ),
        subtitle: Row(
          children: [
            Text(
              '${DateFormat.MMMMEEEEd().format(expense.date)} • ',
              style: const TextStyle(height: 1.3),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 2.5, horizontal: 8.0),
              decoration: BoxDecoration(
                  color: _getColor(
                      EnumToString.convertToString(expense.typeOfExpense)),
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      offset: Offset(0, 2),
                      blurRadius: 4.0,
                    )
                  ]),
              child: Text(
                EnumToString.convertToString(expense.typeOfExpense)
                    .capitalize(),
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
        trailing: Text(
          '\$${expense.money}',
          style: const TextStyle(color: Colors.redAccent),
        ),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            fullscreenDialog: true,
            builder: (_) => AddExpenseScreen(
                updateExpenses: updateExpenses, expense: expense),
          ),
        ),
      ),
    );
  }
}

Color _getColor(String category) {
  switch (category) {
    case 'home':
      return homeColor;
    case 'transport':
      return transportColor;
    case 'food':
      return foodColor;
    default:
      return othersColor;
  }
}
