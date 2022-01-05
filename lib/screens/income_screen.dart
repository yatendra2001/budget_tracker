import 'package:budget_tracker/constants.dart';
import 'package:budget_tracker/models/income_model.dart';
import 'package:budget_tracker/models/money_data.dart';
import 'package:budget_tracker/services/income_database_service.dart';
import 'package:budget_tracker/widgets/income_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

class IncomeScreen extends StatefulWidget {
  const IncomeScreen({Key? key}) : super(key: key);

  @override
  _IncomeScreenState createState() => _IncomeScreenState();
}

class _IncomeScreenState extends State<IncomeScreen> {
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

  List<Income> _income = [];

  @override
  void initState() {
    super.initState();
    _getIncomes();
  }

  Future<void> _getIncomes() async {
    final income = await IncomeDatabaseService.instance.getAllIncomes();
    if (mounted) {
      setState(() => _income = income);
    }
  }

  @override
  Widget build(BuildContext context) {
    Map<String, double> dataMap = {
      "Salary": Provider.of<MoneyData>(context).getIncomes[0],
      "Investment": Provider.of<MoneyData>(context).getIncomes[1],
      "Others": Provider.of<MoneyData>(context).getIncomes[2],
    };
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
          'Incomes',
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
                  ],
                  chartType: ChartType.disc,
                  initialAngleInDegree: 0,
                  legendOptions: const LegendOptions(
                      showLegends: true, legendPosition: LegendPosition.right),
                  chartValuesOptions: const ChartValuesOptions(
                      showChartValues: true, showChartValuesInPercentage: true),
                );
              }
              final income = _income[index - 1];
              return IncomeTile(
                income: income,
                updateIncomes: _getIncomes,
              );
            },
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemCount: 1 + _income.length,
          ),
        ),
      ),
    );
  }
}
