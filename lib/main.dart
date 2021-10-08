import 'package:budget_tracker/models/money_data.dart';
import 'package:budget_tracker/screens/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MoneyData(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Budget Tracker Application',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const DashBoard(),
      ),
    );
  }
}
