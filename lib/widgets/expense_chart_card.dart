import 'package:budget_tracker/screens/screens.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:budget_tracker/constants.dart';
import 'package:budget_tracker/screens/expense_screen.dart';

Route _createRoute(category) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        category == "Expense" ? const ExpenseScreen() : const IncomeScreen(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

class ExpenseChartCard extends StatefulWidget {
  final String category;

  final double homeMoney;
  final double transportMoney;
  final double foodMoney;
  final double expenseOthersMoney;

  final double salaryMoney;
  final double profitMoney;
  final double incomeOthersMoney;

  const ExpenseChartCard({
    Key? key,
    required this.category,
    required this.homeMoney,
    required this.transportMoney,
    required this.foodMoney,
    required this.expenseOthersMoney,
    required this.salaryMoney,
    required this.profitMoney,
    required this.incomeOthersMoney,
  }) : super(key: key);

  @override
  State<ExpenseChartCard> createState() => _ExpenseChartCardState();
}

class _ExpenseChartCardState extends State<ExpenseChartCard> {
  @override
  Widget build(BuildContext context) {
    Map<String, double> dataMap = widget.category == "Expense"
        ? {
            "Home": widget.homeMoney,
            "Transport": widget.transportMoney,
            "Food": widget.foodMoney,
            "Others": widget.expenseOthersMoney,
          }
        : {
            "Salary": widget.salaryMoney,
            "Profit": widget.profitMoney,
            "Others": widget.incomeOthersMoney,
          };
    return TextButton(
      onPressed: () {
        Navigator.push(context, _createRoute(widget.category));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 6),
              blurRadius: 6.0,
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              PieChart(
                dataMap: dataMap,
                animationDuration: const Duration(milliseconds: 800),
                chartLegendSpacing: 32,
                chartRadius: MediaQuery.of(context).size.width / 5,
                colorList: [
                  homeColor,
                  transportColor,
                  foodColor,
                  othersColor,
                ],
                chartType: ChartType.ring,
                initialAngleInDegree: 0,
                legendOptions: const LegendOptions(showLegends: false),
                chartValuesOptions:
                    const ChartValuesOptions(showChartValues: false),
              ),
              widget.category == "Expense"
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _Indicator(
                            money: widget.homeMoney,
                            expense: 'Home',
                            color: homeColor,
                            category: widget.category),
                        const SizedBox(height: 20),
                        _Indicator(
                          money: widget.transportMoney,
                          expense: 'Transport',
                          color: transportColor,
                          category: widget.category,
                        ),
                        const SizedBox(height: 20),
                        _Indicator(
                          money: widget.foodMoney,
                          expense: 'Food',
                          color: foodColor,
                          category: widget.category,
                        ),
                        const SizedBox(height: 20),
                        _Indicator(
                          money: widget.expenseOthersMoney,
                          expense: 'Others',
                          color: othersColor,
                          category: widget.category,
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _Indicator(
                            money: widget.salaryMoney,
                            expense: 'Salary',
                            color: homeColor,
                            category: widget.category),
                        const SizedBox(height: 20),
                        _Indicator(
                          money: widget.profitMoney,
                          expense: 'Profit',
                          color: transportColor,
                          category: widget.category,
                        ),
                        const SizedBox(height: 20),
                        _Indicator(
                          money: widget.incomeOthersMoney,
                          expense: 'Others',
                          color: othersColor,
                          category: widget.category,
                        ),
                      ],
                    )
            ],
          ),
        ),
      ),
    );
  }
}

class _Indicator extends StatelessWidget {
  final double money;
  final String expense;
  final Color color;
  final String category;
  const _Indicator(
      {Key? key,
      required this.money,
      required this.expense,
      required this.color,
      required this.category})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat("#,##0.00", "en_US");
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(width: 5),
        Text(
          expense,
          style: const TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12),
        ),
        const SizedBox(width: 20),
        Text(
          "\$${currencyFormat.format(money)}",
          style: TextStyle(
              color:
                  category == "Expense" ? Colors.red[900] : Colors.green[900],
              fontSize: 12),
        ),
      ],
    );
  }
}
