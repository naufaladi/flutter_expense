import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import './adaptive_button.dart';

class NewTransaction extends StatefulWidget {
  final Function addNewTx;

  NewTransaction(this.addNewTx) {
    print('constructor NewTransaction Widget');
  }

  @override
  State<NewTransaction> createState() {
    print('Create State in NewTransaction Widget');
    return _NewTransactionState();
  }
}

class _NewTransactionState extends State<NewTransaction> {
  final titleController = TextEditingController();
  final amountController = TextEditingController();

  DateTime selectedDate;

  _NewTransactionState() {
    print('Constructor NewTransaction State');
  }

  @override
  void initState() {
    print('initState()');
    super.initState();
  }

  @override
  void didUpdateWidget(covariant NewTransaction oldWidget) {
    print('didUpdateWidget');
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    print('Disposed');
    super.dispose();
  }

  void submitData() {
    if (amountController.text.isEmpty) {
      return;
    }
    final enteredTitle = titleController.text;
    final enteredAmount = double.parse(amountController.text);

    if (enteredTitle.isEmpty || enteredAmount <= 0 || selectedDate == null) {
      return;
    }

    widget.addNewTx(
      enteredTitle,
      enteredAmount,
      selectedDate,
    );

    Navigator.of(context).pop();
  }

  void _openDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      } else {
        setState(() {
          selectedDate = pickedDate;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
            top: 15,
            left: 15,
            right: 15,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
          ),
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Description'),
                controller: titleController,
                onSubmitted: (_) => submitData(),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Amount in USD'),
                controller: amountController,
                keyboardType: TextInputType.number,
                onSubmitted: (_) => submitData(),
              ),
              Container(
                height: 80,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        selectedDate == null
                            ? 'No date chosen'
                            : 'Transaction Date : ${DateFormat.yMMMd().format(selectedDate)}',
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 5),
                      child: FlatButton(
                        onPressed: _openDatePicker,
                        textColor: Theme.of(context).primaryColor,
                        child: Text(
                          'Date picker',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              AdaptiveButton('Add Transaction', submitData),
            ],
          ),
        ),
      ),
    );
  }
}
