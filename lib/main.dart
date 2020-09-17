import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import './widgets/new_transaction.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './models/Transaction.dart';
import './widgets/transaction_list.dart';
import './widgets/chart.dart';
import 'package:better_uuid/uuid.dart';

void main() {
  /*WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);*/
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expenses',
      theme: ThemeData(
        primarySwatch: Colors.red,
        accentColor: Colors.amber,
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
              title: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 18,
              ),
              button: TextStyle(color: Colors.white),
            ),
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
                title: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isLandScape = false;
  final List<Transaction> _userTransaction = [
/*    Transaction(
        id: 't1', title: 'New Shoes', amount: 69.98, date: DateTime.now()),
    Transaction(
        id: 't2',
        title: 'Weekly Groceries',
        amount: 58.90,
        date: DateTime.now())*/
  ];

  List<Transaction> get _recentTransaction {
    return _userTransaction.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(
        Duration(days: 7),
      ));
    }).toList();
  }

  void _addNewTransaction(
      String txTitle, double txAmount, DateTime selectedDate) {
    final newTx = Transaction(
        title: txTitle,
        amount: txAmount,
        date: selectedDate,
        id: Uuid.v1().time.toString());

    setState(() {
      this._userTransaction.add(newTx);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: NewTransaction(_addNewTransaction),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  void _deleteTransaction(String uid) {
    if (this._userTransaction != null && _userTransaction.length > 0) {
      setState(() {
        _userTransaction.removeWhere((x) => x.id == uid);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final PreferredSizeWidget appBar = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text('Expanse Planner'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Builder(
                  builder: (_ctx) => GestureDetector(
                    child: Icon(CupertinoIcons.add),
                    onTap: () => _startAddNewTransaction(context),
                  ),
                )
              ],
            ),
          )
        : AppBar(
            title: const Text('Expanse Planner'),
            actions: <Widget>[
              Builder(
                  builder: (_ctx) => IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () => _startAddNewTransaction(_ctx),
                      ))
            ],
          );

    final pageBody = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          /*mainAxisAlignment: MainAxisAlignment.spaceAround,*/
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            mediaQuery.orientation == Orientation.landscape
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Show Chart',
                        style: Theme.of(context).textTheme.title,
                      ),
                      Switch.adaptive(
                          value: _isLandScape,
                          activeColor: Theme.of(context).accentColor,
                          onChanged: (val) {
                            setState(() {
                              _isLandScape = val;
                            });
                          }),
                    ],
                  )
                : Column(
                    children: <Widget>[
                      Container(
                        height: (mediaQuery.size.height -
                                appBar.preferredSize.height -
                                mediaQuery.padding.top) *
                            .3,
                        child: Chart(_recentTransaction),
                      ),
                      Container(
                        height: (mediaQuery.size.height -
                                appBar.preferredSize.height -
                                mediaQuery.padding.top) *
                            .7,
                        child: TransactionList(
                            _userTransaction, _deleteTransaction),
                      )
                    ],
                  ),
            _isLandScape
                ? Container(
                    height: (mediaQuery.size.height -
                            appBar.preferredSize.height -
                            mediaQuery.padding.top) *
                        .7,
                    child: Chart(_recentTransaction),
                  )
                : Container(
                    height: (mediaQuery.size.height -
                            appBar.preferredSize.height -
                            mediaQuery.padding.top) *
                        .7,
                    child:
                        TransactionList(_userTransaction, _deleteTransaction),
                  ),
          ],
        ),
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: pageBody,
          )
        : Scaffold(
            appBar: appBar,
            body: pageBody,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Builder(
              builder: (_ctx) => Platform.isIOS
                  ? Container()
                  : FloatingActionButton(
                      child: Icon(Icons.add),
                      onPressed: () => _startAddNewTransaction(_ctx),
                    ),
            ),
          );
  }
}
