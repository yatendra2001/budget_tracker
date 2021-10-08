import 'package:budget_tracker/constants.dart';
import 'package:budget_tracker/extension/string_extension.dart';
import 'package:budget_tracker/models/income_model.dart';
import 'package:budget_tracker/screens/add_income_screen.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class IncomeTile extends StatelessWidget {
  final Income income;
  final VoidCallback updateIncomes;

  const IncomeTile(
      {Key? key, required this.income, required this.updateIncomes})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
            color:
                _getColor(EnumToString.convertToString(income.typeOfIncome))),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        tileColor: Colors.white,
        key: Key(income.id.toString()),
        title: Text(
          income.name,
          style: const TextStyle(fontSize: 18.0),
        ),
        subtitle: Row(
          children: [
            Text(
              '${DateFormat.MMMMEEEEd().format(income.date)} • ',
              style: const TextStyle(height: 1.3),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 2.5, horizontal: 8.0),
              decoration: BoxDecoration(
                  color: _getColor(
                      EnumToString.convertToString(income.typeOfIncome)),
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      offset: Offset(0, 2),
                      blurRadius: 4.0,
                    )
                  ]),
              child: Text(
                EnumToString.convertToString(income.typeOfIncome).capitalize(),
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
        trailing: Text(
          '\$${income.money}',
          style: TextStyle(color: Colors.green[900]),
        ),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            fullscreenDialog: true,
            builder: (_) =>
                AddIncomeScreen(updateIncomes: updateIncomes, income: income),
          ),
        ),
      ),
    );
  }
}

Color _getColor(String category) {
  switch (category) {
    case 'salary':
      return homeColor;
    case 'profit':
      return transportColor;
    default:
      return foodColor;
  }
}
