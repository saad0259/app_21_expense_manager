import 'dart:io';

import 'package:app_21_expense_manager/Widgets/adaptiveWidgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import './adaptiveWidgets.dart';

class NewTransaction extends StatefulWidget {
  final Function addTx;
  NewTransaction(this.addTx) {
    print('Constructor New Transactions');
  }

  @override
  _NewTransactionState createState() {
    // print(' Create State of New Transaction');
    return _NewTransactionState();

  }
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();

  DateTime? _txdate;

  // _NewTransactionState(){
  //   print('New Transaction state constructor');
  // }
  //
  // @override
  // void initState() {
  //   super.initState();
  //   print('Init State Called');
  // }
  // @override
  // void didUpdateWidget(covariant NewTransaction oldWidget) {
  //   // TODO: implement didUpdateWidget
  //   super.didUpdateWidget(oldWidget);
  //   print('Something updated');
  // }
  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   super.dispose();
  //   print('Disposed');
  // }


  void _popDatePicker() {
    showDatePicker(
            context: this.context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1990),
            lastDate: DateTime.now())
        .then((pickedDate) {
      if (pickedDate == null) return;

      setState(() {
        _txdate = pickedDate;
      });
    });
  }

  void _submitData() {
    if (_titleController.text.isEmpty ||
        double.parse(_amountController.text) <= 0 ||
        _txdate == null) {
      return;
    }

    widget.addTx(
        _titleController.text, double.parse(_amountController.text), _txdate);

    Navigator.of(this.context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        child: Container(
          padding: EdgeInsets.only(
              top: 10,
              left: 10,
              right: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom + 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
                onSubmitted: (_) => _submitData(),
              ),
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Amount'),
                onSubmitted: (_) => _submitData(),
              ),
              Container(
                height: 60,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(_txdate == null
                          ? 'No Date Chosen!'
                          : 'Date: ${DateFormat.yMd().format(_txdate!)}'),
                    ),
                    AdaptiveFlatButton(
                      child: Text(
                        'Choose Date',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      handler: _popDatePicker,
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                  onPressed: _submitData,
                  child: Text(
                    'New Transaction',
                  )),
            ],
          ),
        ),
      ),
    ); //Text Fields;
  }
}
