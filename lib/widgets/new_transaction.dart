import 'dart:io';

import 'package:expense_planner/widgets/adaptive_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function newTransaction;

  NewTransaction(this.newTransaction);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleInput = TextEditingController();
  final _amountInput = TextEditingController();
  DateTime _selectedDate;

  void _onDataSubmission() {
    final String _enteredTitle = _titleInput.text;
    if (_amountInput.text.isEmpty) return;

    final double _enteredAmount = double.parse(_amountInput.text);

    if (_enteredAmount <= 0 && _enteredTitle.isEmpty && _selectedDate == null)
      return;

    this.widget.newTransaction(_enteredTitle, _enteredAmount, _selectedDate);
    Navigator.of(context).pop();
  }

  void _persentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 6,
        child: Container(
          padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(labelText: 'Title'),
                controller: _titleInput,
                onSubmitted: (_) => _onDataSubmission(),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Amount'),
                controller: _amountInput,
                keyboardType: TextInputType.number,
                onSubmitted: (_) => _onDataSubmission(),
              ),
              Container(
                height: 70,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(_selectedDate == null
                          ? 'No Date Chosen!'
                          : 'Picked data: ${DateFormat.yMd().format(_selectedDate)}'),
                    ),
                    AdaptiveFlatButtom('Pick Date', _persentDatePicker),
                  ],
                ),
              ),
              RaisedButton(
                child: Text('Add Transaction'),
                color: Theme.of(context).primaryColor,
                textColor: Theme.of(context).textTheme.button.color,
                onPressed: _onDataSubmission,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
