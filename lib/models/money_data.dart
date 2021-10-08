import 'package:budget_tracker/models/expense_model.dart';
import 'package:budget_tracker/models/income_model.dart';
import 'package:budget_tracker/services/database_services.dart';
import 'package:budget_tracker/services/income_database_service.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/foundation.dart';

class MoneyData extends ChangeNotifier {
  List<Expense> _expense = [];
  List<Income> _income = [];

  Future<void> getExpense() async {
    final expense = await ExpensesDatabaseService.instance.getAllExpenses();
    _expense = expense;
  }

  Future<void> getIncome() async {
    final income = await IncomeDatabaseService.instance.getAllIncomes();
    _income = income;
  }

  List get getExpenses {
    getExpense();
    double homeMoney = 0.0;
    double transportMoney = 0.0;
    double foodMoney = 0.0;
    double expenseOthersMoney = 0.0;
    double totalSum = 0.0;
    for (var i = 0; i < _expense.length; i++) {
      totalSum += _expense[i].money;
      if (EnumToString.convertToString(_expense[i].typeOfExpense) == 'home') {
        homeMoney += _expense[i].money;
      }
      if (EnumToString.convertToString(_expense[i].typeOfExpense) ==
          'transport') {
        transportMoney += _expense[i].money;
      }
      if (EnumToString.convertToString(_expense[i].typeOfExpense) == 'food') {
        foodMoney += _expense[i].money;
      }
      if (EnumToString.convertToString(_expense[i].typeOfExpense) == 'others') {
        expenseOthersMoney += _expense[i].money;
      }
    }
    return [homeMoney, transportMoney, foodMoney, expenseOthersMoney, totalSum];
  }

  List get getIncomes {
    getIncome();
    double salaryMoney = 0.0;
    double profitMoney = 0.0;
    double incomeOthersMoney = 0.0;
    double totalSum = 0.0;

    for (var i = 0; i < _income.length; i++) {
      totalSum += _expense[i].money;
      if (EnumToString.convertToString(_income[i].typeOfIncome) == 'salary') {
        salaryMoney += _income[i].money;
      }
      if (EnumToString.convertToString(_income[i].typeOfIncome) == 'profit') {
        profitMoney += _income[i].money;
      }
      if (EnumToString.convertToString(_income[i].typeOfIncome) == 'others') {
        incomeOthersMoney += _income[i].money;
      }
    }
    return [salaryMoney, profitMoney, incomeOthersMoney, totalSum];
  }

  double get getRemainingMoney {
    return (getIncomes[3] - getExpenses[4]);
  }
}
