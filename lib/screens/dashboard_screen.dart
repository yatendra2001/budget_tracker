import 'dart:io';

import 'package:budget_tracker/constants.dart';
import 'package:budget_tracker/models/money_data.dart';
import 'package:budget_tracker/screens/add_expense_screen.dart';
import 'package:budget_tracker/screens/add_income_screen.dart';
import 'package:budget_tracker/widgets/dashboard_header/dashboard_header.dart';
import 'package:budget_tracker/widgets/expense_chart_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  String _selectedLocation = 'January';
  ImagePicker picker = ImagePicker();
  File? _image;
  _imgFromCamera() async {
    XFile? image =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 50);
    setState(() {
      _image = File(image!.path);
    });
  }

  _imgFromGallery() async {
    XFile? image =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _image = File(image!.path);
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text('Photo Library'),
                    onTap: () {
                      _imgFromGallery();
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Camera'),
                  onTap: () {
                    _imgFromCamera();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xfff6f6f6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: IconButton(
          onPressed: () => _showPicker(context),
          icon: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: _image != null
                ? Image.file(
                    _image!,
                    width: 200.0,
                    height: 200.0,
                    fit: BoxFit.fitHeight,
                  )
                : Container(
                    decoration: const BoxDecoration(color: Colors.black54),
                    width: 200,
                    height: 200,
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 22.0,
                    ),
                  ),
          ),
        ),
        actions: [
          Center(
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
          const SizedBox(width: 100),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.menu,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Consumer<MoneyData>(
                  builder: (context, money, child) {
                    return const DashboardHeader();
                  },
                ),
                const SizedBox(height: 30),
                const Text(
                  'Incomes by category',
                  style: TextStyle(
                      color: Colors.black54,
                      fontSize: 13,
                      fontWeight: FontWeight.w400),
                ),
                const SizedBox(height: 10),
                Consumer<MoneyData>(
                  builder: (context, money, child) {
                    return ExpenseChartCard(
                        category: 'Income',
                        homeMoney: money.getExpenses[0],
                        transportMoney: money.getExpenses[1],
                        foodMoney: money.getExpenses[2],
                        expenseOthersMoney: money.getExpenses[3],
                        salaryMoney: money.getIncomes[0],
                        profitMoney: money.getIncomes[1],
                        incomeOthersMoney: money.getIncomes[2]);
                  },
                ),
                const SizedBox(height: 30),
                const Text(
                  'Expenses by category',
                  style: TextStyle(
                      color: Colors.black54,
                      fontSize: 13,
                      fontWeight: FontWeight.w400),
                ),
                const SizedBox(height: 10),
                Consumer<MoneyData>(
                  builder: (context, money, child) {
                    return ExpenseChartCard(
                        category: 'Expense',
                        homeMoney: money.getExpenses[0],
                        transportMoney: money.getExpenses[1],
                        foodMoney: money.getExpenses[2],
                        expenseOthersMoney: money.getExpenses[3],
                        salaryMoney: money.getIncomes[0],
                        profitMoney: money.getIncomes[1],
                        incomeOthersMoney: money.getIncomes[2]);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: SpeedDial(
        icon: Icons.monetization_on,
        overlayColor: Colors.black,
        foregroundColor: Colors.black,
        backgroundColor: Colors.amber,
        children: [
          SpeedDialChild(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image(
                height: 40,
                width: 40,
                image: AssetImage(kIncomeImageUrl),
              ),
            ),
            label: 'Income',
            backgroundColor: Colors.amberAccent,
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => AddIncomeScreen(updateIncomes: () {})));
            },
          ),
          SpeedDialChild(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image(
                height: 40,
                width: 40,
                image: AssetImage(kExpenseImageUrl),
              ),
            ),
            label: 'Expense',
            backgroundColor: Colors.amberAccent,
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => AddExpenseScreen(updateExpenses: () {})));
            },
          ),
        ],
      ),
    );
  }
}
