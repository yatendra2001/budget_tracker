import 'dart:ui';

import 'package:budget_tracker/constants.dart';
import 'package:budget_tracker/models/money_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'income_expense_layout.dart';

class DashboardHeader extends StatefulWidget {
  const DashboardHeader({
    Key? key,
  }) : super(key: key);
  @override
  _DashboardHeaderState createState() => _DashboardHeaderState();
}

class _DashboardHeaderState extends State<DashboardHeader> {
  final currencyFormat = NumberFormat("#,##0.00", "en_US");
  bool visibility = true;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {},
      child: Container(
        padding: const EdgeInsets.all(20),
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(0, 6),
                blurRadius: 8.0,
              )
            ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Balance unitl the end of the month',
              style: TextStyle(
                  color: Colors.black54,
                  fontSize: 10.0,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              '\$${currencyFormat.format(Provider.of<MoneyData>(context).getRemainingMoney)}',
              style: const TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w700,
                  fontSize: 30.0),
            ),
            const SizedBox(
              height: 18,
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  visibility ? visibility = false : visibility = true;
                });
              },
              child: visibility
                  ? const Icon(
                      Icons.visibility_outlined,
                      color: Colors.black54,
                      size: 20,
                    )
                  : const Icon(
                      Icons.visibility_off_outlined,
                      color: Colors.black54,
                      size: 20,
                    ),
            ),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IncomeExpenseLayout(
                    imageUrl: kIncomeImageUrl,
                    isIncome: true,
                    incomeOrExpense: 'Income'),
                IncomeExpenseLayout(
                  imageUrl: kExpenseImageUrl,
                  isIncome: false,
                  incomeOrExpense: 'Expense',
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
