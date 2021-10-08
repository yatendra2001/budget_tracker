import 'package:budget_tracker/models/income_model.dart';
import 'package:budget_tracker/services/income_database_service.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:budget_tracker/extension/string_extension.dart';

class AddIncomeScreen extends StatefulWidget {
  final VoidCallback updateIncomes;
  final Income? income;

  // ignore: use_key_in_widget_constructors
  const AddIncomeScreen({required this.updateIncomes, this.income});

  @override
  _AddIncomeScreenState createState() => _AddIncomeScreenState();
}

class _AddIncomeScreenState extends State<AddIncomeScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _dateController;
  late TextEditingController _moneyController;

  Income? _income;
  bool get _isEditing => widget.income != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _income = widget.income;
    } else {
      _income = Income(
        name: '',
        date: DateTime.now(),
        typeOfIncome: TypeOfIncome.salary,
        money: 00,
      );
    }

    _nameController = TextEditingController(text: _income!.name);
    _moneyController = TextEditingController(text: _income!.money.toString());
    _dateController = TextEditingController(
        text: DateFormat.MMMMEEEEd().format(_income!.date));
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
        title: Text(!_isEditing ? 'Add Income' : 'Update Income',
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
                          _income = _income!.copyWith(name: value)),
                  const SizedBox(height: 32.0),
                  TextFormField(
                    controller: _moneyController,
                    style: const TextStyle(fontSize: 16.0),
                    decoration: const InputDecoration(labelText: 'Money'),
                    validator: (value) =>
                        value!.trim().isEmpty ? 'Please enter income' : null,
                    onSaved: (value) => _income = _income!.copyWith(
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
                  DropdownButtonFormField<TypeOfIncome>(
                    value: _income!.typeOfIncome,
                    icon: const Icon(
                      Icons.arrow_drop_down_circle,
                      color: Colors.black,
                    ),
                    iconSize: 22.0,
                    iconEnabledColor: Colors.black,
                    items: TypeOfIncome.values
                        .map(
                          (typeOfIncome) => DropdownMenuItem(
                            value: typeOfIncome,
                            child: Text(
                              EnumToString.convertToString(typeOfIncome)
                                  .capitalize(),
                              style: const TextStyle(
                                  fontSize: 16.0, color: Colors.black),
                            ),
                          ),
                        )
                        .toList(),
                    style: const TextStyle(fontSize: 16.0),
                    decoration: const InputDecoration(labelText: 'Date'),
                    onChanged: (value) => setState(
                        () => _income = _income!.copyWith(typeOfIncome: value)),
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
                        IncomeDatabaseService.instance.delete(_income!.id!);
                        widget.updateIncomes();
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
      initialDate: _income!.date,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) {
      _dateController.text = DateFormat.MMMMEEEEd().format(date);
      setState(() => _income = _income!.copyWith(date: date));
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (!_isEditing) {
        IncomeDatabaseService.instance.insert(_income!);
      } else {
        IncomeDatabaseService.instance.update(_income!);
      }
      widget.updateIncomes();
      Navigator.pop(context);
    }
  }
}
