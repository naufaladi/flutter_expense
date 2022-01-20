import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './widgets/chart.dart';
import './widgets/new_transaction.dart';
import './widgets/transaction_list.dart';
import './models/transaction.dart';

void main() {
  // code below is to prevent Landscape mode
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations(
  //     [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      // sets or overwrite the Theme setup
      theme: ThemeData(
        primarySwatch: Colors.blue,
        accentColor: Colors.orange,
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
              headline6: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                fontFamily: 'OpenSans',
              ),
            ),
        appBarTheme: AppBarTheme(
          titleTextStyle: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  final List<Transaction> _userTransactions = [];

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(Duration(days: 7)),
      );
    }).toList();
  }

  bool _showChart = true;

  // tells flutter: whenever my lifecycle state changes, i want you to go to a certain observer and call the didChangeAppLifeCycleState method)
  // "this" refers to this class' observer which is written below (didChangeAppLifeCycleState)
  // therefore, didChangeAppLifeCycleState will get called whenver the initState is called/ the app lifecycle changes
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  didChangeAppLifecycleState(AppLifecycleState state) {
    print(state);
  }

  // to avoid memory leaks. Clears or erase the listener/observer that we created above, whenever that widget is closed/disposed
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _addNewTransaction(
      String txTitle, double txAmount, DateTime selectedDate) {
    final newTx = Transaction(
      id: DateTime.now().toString(),
      title: txTitle,
      amount: txAmount,
      date: selectedDate,
    );

    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void showAddNewTransaction(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (bContext) {
          // i'm not sure why we call builder here. need further look later
          return NewTransaction(_addNewTransaction);
        });
  }

  void deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) => id == tx.id);
    });
  }

  List<Widget> _buildLandscapeContent(MediaQueryData mediaQuery,
      PreferredSizeWidget appBar, Widget txListWidget) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Show Chart', style: Theme.of(context).textTheme.headline6),
          Switch.adaptive(
            activeColor: Theme.of(context).colorScheme.secondary,
            value: _showChart,
            onChanged: (val) {
              setState(() {
                _showChart = val;
              });
            },
          ),
        ],
      ),

      // if showChart switch is on, show Chart, otherwise just show the Transaction List
      _showChart
          ? Container(
              height: (mediaQuery.size.height -
                      appBar.preferredSize.height -
                      mediaQuery.padding.top) *
                  0.60,
              child: Chart(_recentTransactions),
            )
          : txListWidget
    ];
  }

  List<Widget> _buildPortraitContent(MediaQueryData mediaQuery,
      PreferredSizeWidget appBar, Widget txListWidget) {
    return [
      Container(
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.23,
        child: Chart(_recentTransactions),
      ),
      txListWidget
    ];
  }

  PreferredSizeWidget _buildAppBar() {
    return Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text('Personal Expense (iOS)'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  child: Icon(CupertinoIcons.add_circled),
                  onTap: () {
                    showAddNewTransaction(context);
                  },
                )
              ],
            ),
          )
        : AppBar(
            title: Text('Expenses'),
            actions: [
              IconButton(
                onPressed: () {
                  showAddNewTransaction(context);
                },
                icon: Icon(Icons.add),
              )
            ],
          );
  }

  @override
  Widget build(BuildContext context) {
    print('build() myHomePageState');
    final mediaQuery = MediaQuery.of(context);
    final bool isLandscape = mediaQuery.orientation == Orientation.landscape;

    // we use PreferredSizeWidget type because apparently AppBar doesnt work with Cupertino (iOS)
    final PreferredSizeWidget appBar = _buildAppBar();

    final txListWidget = Container(
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top -
                mediaQuery.padding.bottom) *
            0.75,
        child: TransactionList(_userTransactions, deleteTransaction));

    final appBody = SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (isLandscape)
            ..._buildLandscapeContent(mediaQuery, appBar, txListWidget),
          if (!isLandscape)
            ..._buildPortraitContent(mediaQuery, appBar, txListWidget)
        ],
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: appBody,
            navigationBar: appBar,
          )
        : Scaffold(
            appBar: appBar,
            body: appBody,
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    onPressed: () {
                      showAddNewTransaction(context);
                    },
                    child: Icon(Icons.add),
                  ),
          );
  }
}
