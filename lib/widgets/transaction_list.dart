import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';
import './transaction_item.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTransaction;

  TransactionList(this.transactions, this.deleteTransaction);

  @override
  Widget build(BuildContext context) {
    print('build() TransactionList');
    return transactions.isEmpty
        ? LayoutBuilder(builder: (context, constraints) {
            return Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Text(
                  'No Transactions, Add some!',
                  style: Theme.of(context).textTheme.headline6,
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  height: constraints.maxHeight * 0.6,
                  child: Image.asset(
                    'assets/images/waiting.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            );
          })
        /* (Note: deprecated comment, this was changed again to a map function instead of listview builder) builds a list that contains all transaction item (determined by the length of transactions list)*/
        : ListView(
            children: transactions
                .map(
                  (tx) => TransactionItem(
                    key: ValueKey(tx.id),
                    transaction: tx,
                    deleteTransaction: deleteTransaction,
                  ),
                )
                .toList(),
          );

    /* 
              return Card(
                child: Row(
                  children: [
                    Container(
                      child: Text(
                        '\$${transactions[index].amount.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Theme.of(context).primaryColorDark,
                        ),
                      ),
                      margin: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 10,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).primaryColorDark,
                          width: 2,
                        ),
                      ),
                      padding: EdgeInsets.all(10),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          transactions[index].title,
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        Text(
                          DateFormat('d MMM, yyyy')
                              .format(transactions[index].date),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
              */
  }
}
