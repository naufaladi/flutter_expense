import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';

class TransactionItem extends StatefulWidget {
  const TransactionItem({
    Key key,
    @required this.transaction,
    @required this.deleteTransaction,
  }) : super(key: key);

  final Transaction transaction;
  final Function deleteTransaction;

  @override
  State<TransactionItem> createState() => _TransactionItemState();
}

class _TransactionItemState extends State<TransactionItem> {
  Color bgColor;

  @override
  void initState() {
    const availableBgColor = [
      Colors.blue,
      Colors.amber,
      Colors.green,
      Colors.pink,
    ];

    bgColor = availableBgColor[Random().nextInt(4)];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: bgColor,
          radius: 30,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FittedBox(
              child: Text('\$${widget.transaction.amount.toStringAsFixed(2)}'),
            ),
          ),
        ),
        title: Text(
          widget.transaction.title,
          style: Theme.of(context).textTheme.headline6,
        ),
        subtitle: Text(
          DateFormat.yMMMd().format(widget.transaction.date),
        ),
        trailing: MediaQuery.of(context).size.width > 450
            ? FlatButton.icon(
                onPressed: () {
                  widget.deleteTransaction(widget.transaction.id);
                },
                label: const Text(
                    'Erase'), // when the widget tree rebuild (due to setState() or similar etc., this text will not be re-instatiated because we are saying that this object will never ever change when i create it (i already know the value beforehand)
                icon: const Icon(Icons.delete),
                textColor: Theme.of(context).errorColor)
            : IconButton(
                onPressed: () {
                  widget.deleteTransaction(widget.transaction.id);
                },
                icon: const Icon(Icons.delete)),
      ),
    );
  }
}
