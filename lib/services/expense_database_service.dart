import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:budget_tracker/models/expense_model.dart';

class ExpensesDatabaseService {
  static const ExpensesDatabaseService instance = ExpensesDatabaseService._();

  //Private constructor because DataBase service class is going to be singleton
  //only one instance for data class becasuse to access same database over and over
  const ExpensesDatabaseService._();

  static const String _expenseTable = 'expense_table';
  static const String _colId = 'id';
  static const String _colName = 'name';
  static const String _colDate = 'date';
  static const String _colTypeOfExpense = 'type_of_expense';
  static const String _colMoney = 'money';

  static Database? _db;

  Future<Database> get db async {
    _db ??= await _openDb();
    return _db!;
  }

  Future<Database> _openDb() async {
    final dir = await getApplicationSupportDirectory();
    final path = dir.path + '/expense_list.db';
    final expenseListDb = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
          CREATE TABLE $_expenseTable(
            $_colId INTEGER PRIMARY KEY AUTOINCREMENT,
            $_colName TEXT,
            $_colDate TEXT,
            $_colTypeOfExpense TEXT,
            $_colMoney TEXT
          )
          ''');
    });
    return expenseListDb;
  }

  Future<Expense> insert(Expense expense) async {
    final db = await this.db;
    final id = await db.insert(_expenseTable, expense.toMap());
    final expenseWithId = expense.copyWith(id: id);
    return expenseWithId;
  }

  Future<List<Expense>> getAllExpenses() async {
    final db = await this.db;
    final expensesData =
        await db.query(_expenseTable, orderBy: '$_colDate DESC');
    return expensesData.map((e) => Expense.fromMap(e)).toList();
  }

  Future<int> update(Expense expense) async {
    final db = await this.db;
    return await db.update(
      _expenseTable,
      expense.toMap(),
      where: '$_colId = ?',
      whereArgs: [expense.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await this.db;
    return await db.delete(
      _expenseTable,
      where: '$_colId = ?',
      whereArgs: [id],
    );
  }
}
