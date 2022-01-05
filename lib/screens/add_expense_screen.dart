import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:budget_tracker/models/expense_model.dart';
import 'package:budget_tracker/extension/string_extension.dart';
import 'package:budget_tracker/services/expense_database_service.dart';

class AddExpenseScreen extends StatefulWidget {
  final VoidCallback updateExpenses;
  final Expense? expense;

  // ignore: use_key_in_widget_constructors
  const AddExpenseScreen({required this.updateExpenses, this.expense});

  @override
  _AddExpenseScreenState createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _dateController;
  late TextEditingController _moneyController;

  Expense? _expense;
  bool get _isEditing => widget.expense != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _expense = widget.expense;
    } else {
      _expense = Expense(
        name: '',
        date: DateTime.now(),
        typeOfExpense: TypeOfExpense.food,
        money: 00,
      );
    }

    _nameController = TextEditingController(text: _expense!.name);
    _moneyController = TextEditingController(text: _expense!.money.toString());
    _dateController = TextEditingController(
        text: DateFormat.MMMMEEEEd().format(_expense!.date));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dateController.dispose();
    _moneyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(!_isEditing ? 'Add Expense' : 'Update Expense',
            style: const TextStyle(color: Colors.black54)),
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
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            padding:
                const EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                      controller: _nameController,
                      style: const TextStyle(fontSize: 16.0),
                      decoration: const InputDecoration(labelText: 'Name'),
                      validator: (value) =>
                          value!.trim().isEmpty ? 'Please enter a name' : null,
                      onSaved: (value) =>
                          _expense = _expense!.copyWith(name: value)),
                  const SizedBox(height: 32.0),
                  TextFormField(
                    controller: _moneyController,
                    style: const TextStyle(fontSize: 16.0),
                    decoration: const InputDecoration(labelText: 'Money'),
                    validator: (value) => value!.trim().isEmpty
                        ? 'Please enter expenditure'
                        : null,
                    onSaved: (value) => _expense = _expense!.copyWith(
                      money: double.parse(value!),
                    ),
                  ),
                  const SizedBox(
                    height: 32.0,
                  ),
                  TextFormField(
                    controller: _dateController,
                    readOnly: true,
                    style: const TextStyle(fontSize: 16.0),
                    decoration: const InputDecoration(labelText: 'Date'),
                    onTap: _handleDatePicker,
                  ),
                  const SizedBox(height: 32.0),
                  DropdownButtonFormField<TypeOfExpense>(
                    value: _expense!.typeOfExpense,
                    icon: const Icon(
                      Icons.arrow_drop_down_circle,
                      color: Colors.black,
                    ),
                    iconSize: 22.0,
                    iconEnabledColor: Colors.black,
                    items: TypeOfExpense.values
                        .map(
                          (typeOfExpense) => DropdownMenuItem(
                            value: typeOfExpense,
                            child: Text(
                              EnumToString.convertToString(typeOfExpense)
                                  .capitalize(),
                              style: const TextStyle(
                                  fontSize: 16.0, color: Colors.black),
                            ),
                          ),
                        )
                        .toList(),
                    style: const TextStyle(fontSize: 16.0),
                    decoration: const InputDecoration(labelText: 'Date'),
                    onChanged: (value) => setState(() =>
                        _expense = _expense!.copyWith(typeOfExpense: value)),
                  ),
                  const SizedBox(height: 32.0),
                  ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                        primary: Colors.black,
                        minimumSize: const Size.fromHeight(45.0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0))),
                    child: Text(
                      !_isEditing ? 'Add' : 'Save',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  if (_isEditing)
                    ElevatedButton(
                      onPressed: () {
                        ExpensesDatabaseService.instance.delete(_expense!.id!);
                        widget.updateExpenses();
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                          primary: Colors.redAccent,
                          minimumSize: const Size.fromHeight(45.0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0))),
                      child: const Text(
                        'Delete',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleDatePicker() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _expense!.date,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) {
      _dateController.text = DateFormat.MMMMEEEEd().format(date);
      setState(() => _expense = _expense!.copyWith(date: date));
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (!_isEditing) {
        ExpensesDatabaseService.instance.insert(_expense!);
      } else {
        ExpensesDatabaseService.instance.update(_expense!);
      }
      widget.updateExpenses();

      Navigator.pop(context);
    }
  }
}
