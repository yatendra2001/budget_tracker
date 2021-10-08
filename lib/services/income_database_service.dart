import 'package:budget_tracker/models/income_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class IncomeDatabaseService {
  static const IncomeDatabaseService instance = IncomeDatabaseService._();

  //Private constructor because DataBase service class is going to be singleton
  //only one instance for data class becasuse to access same database over and over
  const IncomeDatabaseService._();

  static const String _incomeTable = 'income_table';
  static const String _colId = 'id';
  static const String _colName = 'name';
  static const String _colDate = 'date';
  static const String _colTypeOfIncome = 'type_of_income';
  static const String _colMoney = 'money';

  static Database? _db;

  Future<Database> get db async {
    _db ??= await _openDb();
    return _db!;
  }

  Future<Database> _openDb() async {
    final dir = await getApplicationSupportDirectory();
    final path = dir.path + '/income_list.db';
    final incomeListDb = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
          CREATE TABLE $_incomeTable(
            $_colId INTEGER PRIMARY KEY AUTOINCREMENT,
            $_colName TEXT,
            $_colDate TEXT,
            $_colTypeOfIncome TEXT,
            $_colMoney TEXT
          )
          ''');
    });
    return incomeListDb;
  }

  Future<Income> insert(Income income) async {
    final db = await this.db;
    final id = await db.insert(_incomeTable, income.toMap());
    final incomeWithId = income.copyWith(id: id);
    return incomeWithId;
  }

  Future<List<Income>> getAllIncomes() async {
    final db = await this.db;
    final incomesData = await db.query(_incomeTable, orderBy: '$_colDate DESC');
    return incomesData.map((e) => Income.fromMap(e)).toList();
  }

  Future<int> update(Income income) async {
    final db = await this.db;
    return await db.update(
      _incomeTable,
      income.toMap(),
      where: '$_colId = ?',
      whereArgs: [income.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await this.db;
    return await db.delete(
      _incomeTable,
      where: '$_colId = ?',
      whereArgs: [id],
    );
  }
}
