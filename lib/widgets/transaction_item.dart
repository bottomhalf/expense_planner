import 'package:flutter/material.dart';
import '../models/Transaction.dart';
import 'package:intl/intl.dart';

class TransactionItem extends StatelessWidget {
  const TransactionItem({
    Key key,
    @required Transaction userTransaction,
    @required this.deleteTransaction,
  })  : _userTransaction = userTransaction,
        super(key: key);

  final Transaction _userTransaction;
  final Function deleteTransaction;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      elevation: 4,
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          child: FittedBox(
            child: Text('\$${_userTransaction.amount}'),
          ),
        ),
        title: Text(
          '${_userTransaction.title}',
          style: Theme.of(context).textTheme.title,
        ),
        subtitle: Text(
          DateFormat.yMMMd().format(_userTransaction.date),
        ),
        trailing: MediaQuery.of(context).size.width > 460
            ? FlatButton.icon(
                icon: const Icon(Icons.delete),
                label: const Text('Delete'),
                onPressed: () => this.deleteTransaction(_userTransaction.id))
            : IconButton(
                icon: const Icon(Icons.delete),
                color: Theme.of(context).errorColor,
                onPressed: () => this.deleteTransaction(_userTransaction.id),
              ),
      ),
    );
  }
}
