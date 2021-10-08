import 'package:budget_tracker/models/money_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class IncomeExpenseLayout extends StatelessWidget {
  final String imageUrl;
  final String incomeOrExpense;
  final bool isIncome;

  const IncomeExpenseLayout(
      {Key? key,
      required this.imageUrl,
      required this.incomeOrExpense,
      required this.isIncome})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat("#,##0.00", "en_US");

    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Image(
            height: 40,
            width: 40,
            image: AssetImage(imageUrl),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              incomeOrExpense,
              style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 10,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 3,
            ),
            Text(
              isIncome
                  ? '\$${currencyFormat.format(Provider.of<MoneyData>(context).getIncomes[3])}'
                  : '\$${currencyFormat.format(Provider.of<MoneyData>(context).getExpenses[4])}',
              style: TextStyle(
                  color: isIncome ? Colors.green : Colors.red,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            ),
          ],
        )
      ],
    );
  }
}
