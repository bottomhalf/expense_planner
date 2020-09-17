import 'package:flutter/material.dart';
import '../models/Transaction.dart';
import './transaction_item.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> _userTransaction;
  final Function deleteTransaction;

  TransactionList(this._userTransaction, this.deleteTransaction);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _userTransaction.isEmpty
          ? LayoutBuilder(
              builder: (ctx, constraints) {
                return Column(
                  children: <Widget>[
                    Text(
                      'No transaction order get!',
                      style: Theme.of(context).textTheme.title,
                    ),
                    SizedBox(
                      height: constraints.maxHeight * .05,
                    ),
                    Container(
                      height: constraints.maxHeight * .7,
                      child: Image.asset(
                        'assets/images/waiting.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                );
              },
            )
          : ListView.builder(
              itemBuilder: (ctx, index) {
                return TransactionItem(
                    userTransaction: _userTransaction.elementAt(index),
                    deleteTransaction: deleteTransaction);

                /*return Card(
                  child: Row(
                    children: <Widget>[
                      Container(
                        child: Text(
                          '\$${_userTransaction[index].amount.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.title,
                        ),
                        margin:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Theme.of(context).primaryColor,
                            width: 2,
                          ),
                        ),
                        padding: EdgeInsets.all(10),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            _userTransaction[index].title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            DateFormat.yMMMd()
                                .format(_userTransaction[index].date),
                            style: TextStyle(color: Colors.grey),
                          )
                        ],
                      )
                    ],
                  ),
                );*/
              },
              itemCount: _userTransaction.length,
            ),
    );
  }
}
