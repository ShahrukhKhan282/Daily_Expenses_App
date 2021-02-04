import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import './transaction.dart';

class TransactionList extends StatelessWidget {
  final Function deleteTransaction;
  final Box<Transaction> transactionbox;
  TransactionList(this.transactionbox, this.deleteTransaction);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      child: transactionbox.isEmpty
          ? SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    "No Transactions Added Yet!",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  Image.asset(
                    'assets/images/empty.png',
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemBuilder: (ctx, index) {
                int len = transactionbox.length;
                final todo = transactionbox.getAt(len - index - 1);
                return Dismissible(
                  key: Key(todo.id),
                  background: Container(color: Colors.red),
                  onDismissed: (direction) =>
                      deleteTransaction(len - index - 1),
                  child: InkWell(
                    onTap: () {
                      Platform.isIOS
                          ? showCupertinoDialog(
                              context: context,
                              builder: (context) {
                                return CupertinoAlertDialog(
                                  title: Text("data"),
                                  content: Text("content"),
                                  actions: [
                                    FlatButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text("OK"),
                                    ),
                                  ],
                                );
                              },
                            )
                          : showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("data"),
                                  content: Text("content"),
                                  actions: [
                                    FlatButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text("OK"),
                                    ),
                                  ],
                                );
                              },
                            );
                    },
                    child: Card(
                      color: Colors.grey[850],
                      shadowColor: Colors.black,
                      elevation: 10,
                      margin: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 2,
                      ),
                      child: ListTile(
                        leading: Container(
                          padding: EdgeInsets.symmetric(vertical: 7),
                          width: 70,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              "₹" + todo.amount.toStringAsFixed(0),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.green,
                              ),
                            ),
                          ),
                        ),
                        title: Text(
                          todo.title,
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                        subtitle: Text(
                          DateFormat.yMMMd().format(todo.date),
                          style: TextStyle(
                            color: Colors.white54,
                          ),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          color: Colors.red,
                          onPressed: () => deleteTransaction(len - index - 1),
                        ),
                      ),
                    ),
                  ),
                );
              },
              itemCount: transactionbox.length,
            ),
    );
  }
}
