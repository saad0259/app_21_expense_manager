import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';

import './Widgets/transaction_list.dart';
import './Widgets/new_transaction.dart';
import './Widgets/chart.dart';

import '../Models/transactions.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations(
  //     [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expense Manager',
      theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          accentColor: Colors.amber,
          fontFamily: 'Quicksand',
          textTheme: ThemeData.light().textTheme.copyWith(
                headline6: const TextStyle(
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black,
                ),
                // button: TextStyle(
                //   color: Colors.yellow,
                // )
              ),
          appBarTheme: AppBarTheme(
              textTheme: ThemeData.light().textTheme.copyWith(
                      headline6: const TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 18,
                  )))),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  final titleController = TextEditingController();
  final amountController = TextEditingController();

  var _showChart = false;

  void _showTransactionForm(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return NewTransaction(_addNewTransaction);
        });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print('App State: $state');
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance!.removeObserver(this);
  }

  final List<Transactions> _transactions = [
    // Transactions(
    //     id: 't1', amount: 69.69, date: DateTime.now(), title: 'Beard Comb'),
    // Transactions(
    //     id: 't2', amount: 499.49, date:
    //     DateTime.now(), title: 'New Shoes'),
    // Transactions(
    //     id: 't2', amount: 4999.49, date: DateTime.now(), title: 'New Shoes'),
    // Transactions(
    //     id: 't2', amount: 49999.49, date: DateTime.now(), title: 'New Shoes'),
    // Transactions(
    //     id: 't2', amount: 499999.49, date: DateTime.now(), title: 'New Shoes'),
  ];

  List<Transactions> get _recentTransactions {
    return _transactions.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  void _addNewTransaction(String txTitle, double txAmount, DateTime _txDate) {
    final newTx = Transactions(
        amount: txAmount,
        title: txTitle,
        date: _txDate,
        id: DateTime.now().toString());
    setState(() {
      _transactions.add(newTx);
    });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _transactions.removeWhere((element) => element.id == id);
    });
  }

  List<Widget> _landScapeBuilder(
      AppBar appBar, MediaQueryData mediaQuery, Widget txList) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            'Show Chart',
            style: Theme.of(context).textTheme.headline6,
          ),
          Switch.adaptive(
              value: _showChart,
              onChanged: (val) {
                setState(() {
                  _showChart = val;
                });
              })
        ],
      ),
      _showChart
          ? Container(
              height: (mediaQuery.size.height -
                      appBar.preferredSize.height -
                      mediaQuery.padding.top) *
                  0.7,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
              child: Chart(_recentTransactions))
          : txList
    ];
  }

  List<Widget> _portraitBuilder(
      AppBar appBar, MediaQueryData mediaQuery, Widget txList) {
    return [
      Container(
          height: (mediaQuery.size.height -
                  appBar.preferredSize.height -
                  mediaQuery.padding.top) *
              0.35,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
          child: Chart(_recentTransactions)),
      txList
    ];
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandScape = mediaQuery.orientation == Orientation.landscape;
    final dynamic appBar = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: const Text("Expense Manager"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  child: const Icon(CupertinoIcons.add),
                  onTap: () => _showTransactionForm(context),
                )
              ],
            ),
          )
        : AppBar(
            title: const Text("Expense Manager"),
            actions: [
              IconButton(
                onPressed: () => _showTransactionForm(context),
                icon: const Icon(Icons.add),
              )
            ],
          );
    final txList = Container(
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.7,
        child: TransactionList(
            _transactions.reversed.toList(), _deleteTransaction));

    final pageBody = SingleChildScrollView(
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (isLandScape) ..._landScapeBuilder(appBar, mediaQuery, txList),
          if (!isLandScape) ..._portraitBuilder(appBar, mediaQuery, txList),
          // if (!isLandScape) txList,
        ],
      ),
    );
    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: pageBody,
            navigationBar: appBar,
          )
        : Scaffold(
            appBar: appBar,
            body: SafeArea(
              child: pageBody,
            ),
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    onPressed: () => _showTransactionForm(context),
                    child: const Icon(Icons.add),
                  ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
  }
}
