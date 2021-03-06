import 'dart:io';
import 'package:daily_expenses_app/chart.dart';
import 'package:daily_expenses_app/new_transaction.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import './transaction_list.dart';
import 'package:flutter/material.dart';
import './transaction.dart';
import './chart.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  final appdirectory = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appdirectory.path);
  Hive.registerAdapter(TransactionAdapter());
  await Hive.openBox<Transaction>('tran');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void startAddNewTransaction(BuildContext ctx) {
    showDialog(
      context: ctx,
      builder: (bCtx) {
        return NewTransaction(addTransaction);
      },
    );
  }

  Box<Transaction> transactionbox;
  @override
  void initState() {
    super.initState();
    transactionbox = Hive.box<Transaction>('tran');
  }

  void addTransaction(Transaction tx) {
    setState(() {
      transactionbox.add(tx);
      Navigator.of(context).pop();
    });
  }

  void deletetransaction(index) {
    Platform.isIOS
        ? showCupertinoDialog(
            context: context,
            builder: (context) {
              return CupertinoAlertDialog(
                title: Text("Deleting Transaction..."),
                content: Text("Are you sure?"),
                actions: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        transactionbox.deleteAt(index);
                      });
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Transaction removed")));
                    },
                    child: Text("Yes"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      setState(() {});
                    },
                    child: Text("No"),
                  ),
                ],
              );
            })
        : showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Deleting Transaction..."),
                content: Text("Are you sure?"),
                actions: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        transactionbox.deleteAt(index);
                      });
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Transaction removed")));
                    },
                    child: Text("Yes"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      setState(() {});
                    },
                    child: Text("No"),
                  ),
                ],
              );
            },
          );
  }

  @override
  Widget build(BuildContext context) {
    final PreferredSizeWidget appBar = Platform.isIOS
        ? CupertinoNavigationBar(
            backgroundColor: Colors.grey[900],
            middle: Text(
              "Daily Expenses",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  child: Icon(
                    CupertinoIcons.add,
                    color: Colors.white,
                  ),
                  onTap: () => startAddNewTransaction(context),
                )
              ],
            ),
          )
        : AppBar(
            backgroundColor: Colors.grey[900],
            title: Text(
              "Daily Expenses",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            actions: [
              IconButton(
                color: Colors.white,
                icon: Icon(Icons.add),
                onPressed: () => startAddNewTransaction(context),
              )
            ],
          );
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: appBar,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: (MediaQuery.of(context).size.height -
                        appBar.preferredSize.height -
                        MediaQuery.of(context).padding.top) *
                    0.25,
                child: Chart(transactionbox),
              ),
              FutureBuilder(
                future: Hive.openBox<Transaction>('tran'),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return Text(snapshot.error.toString());
                    } else
                      return Container(
                          height: (MediaQuery.of(context).size.height -
                                  appBar.preferredSize.height -
                                  MediaQuery.of(context).padding.top) *
                              0.70,
                          child: TransactionList(
                              transactionbox, deletetransaction));
                  } else
                    return Text('Loading');
                },
              )
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => startAddNewTransaction(context),
      ),
    );
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }
}
