import 'package:budget_tracker/constants.dart';
import 'package:budget_tracker/models/expense_model.dart';
import 'package:budget_tracker/services/database_services.dart';
import 'package:budget_tracker/widgets/money_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pie_chart/pie_chart.dart';

class ExpenseScreen extends StatefulWidget {
  const ExpenseScreen({Key? key}) : super(key: key);

  @override
  _ExpenseScreenState createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  List<String> months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sept',
    'Oct',
    'Nov',
    'Dec'
  ];
  String _selectedLocation = 'Jan';
  Map<String, double> dataMap = {
    "Home": 950,
    "Transport": 800,
    "Food": 770,
    "Others": 1075,
  };
  List<Expense> _expenses = [];

  @override
  void initState() {
    super.initState();
    _getExpenses();
  }

  Future<void> _getExpenses() async {
    final expenses = await ExpensesDatabaseService.instance.getAllExpenses();
    if (mounted) {
      setState(() => _expenses = expenses);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6f6f6),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const CircleAvatar(
            radius: 16.0,
            backgroundColor: Colors.black26,
            child: Icon(
              Icons.close_rounded,
              color: Colors.white,
            ),
          ),
        ),
        title: const Text(
          'Expenses',
          style: TextStyle(color: Colors.black54),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                value: _selectedLocation,
                onChanged: (value) {
                  setState(() {
                    _selectedLocation = value.toString();
                  });
                },
                items: months.map((location) {
                  return DropdownMenuItem(
                    child: Text(location),
                    value: location,
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView.separated(
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                return PieChart(
                  dataMap: dataMap,
                  animationDuration: const Duration(milliseconds: 800),
                  chartLegendSpacing: 32,
                  chartRadius: MediaQuery.of(context).size.width / 2,
                  colorList: [
                    homeColor,
                    transportColor,
                    foodColor,
                    othersColor,
                  ],
                  chartType: ChartType.disc,
                  initialAngleInDegree: 0,
                  legendOptions: const LegendOptions(
                      showLegends: true, legendPosition: LegendPosition.right),
                  chartValuesOptions: const ChartValuesOptions(
                      showChartValues: true, showChartValuesInPercentage: true),
                );
              }
              final expense = _expenses[index - 1];
              return ExpenseTile(
                expense: expense,
                updateExpenses: _getExpenses,
              );
            },
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemCount: 1 + _expenses.length,
          ),
        ),
      ),
    );
  }
}
