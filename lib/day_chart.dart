import 'dart:io';

import 'package:daily_expenses_app/transaction.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DayChart extends StatelessWidget {
  final List<Transaction> allTransactions;
  final Object monthname;
  DayChart(this.allTransactions, this.monthname);

  List<Transaction> get dailytransactions {
    return allTransactions
        .where((element) =>
            DateFormat.yMMM().format(element.date).toString() ==
            monthname.toString())
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: Platform.isIOS
          ? CupertinoNavigationBar(
              backgroundColor: Colors.grey[900],
              middle: Text(
                monthname.toString(),
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            )
          : AppBar(
              backgroundColor: Colors.grey[900],
              title: Text(monthname.toString()),
            ),
      body: allTransactions.isEmpty
          ? SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
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
              itemBuilder: (context, i) {
                return InkWell(
                  onTap: () {
                    Platform.isIOS
                        ? showCupertinoDialog(
                            context: context,
                            builder: (context) {
                              return CupertinoAlertDialog(
                                title: Text(dailytransactions[i].title),
                                content: Container(
                                  height: 60,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Divider(
                                        color: Colors.black,
                                      ),
                                      Text("Amount: " +
                                          dailytransactions[i]
                                              .amount
                                              .toString()),
                                      Text("Added: " +
                                          DateFormat.yMMMd().format(
                                              dailytransactions[i].date)),
                                    ],
                                  ),
                                ),
                                actions: [
                                  TextButton(
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
                                title: Text(dailytransactions[i].title),
                                content: Container(
                                  height: 60,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Divider(
                                        color: Colors.black,
                                      ),
                                      Text("Amount: " +
                                          dailytransactions[i]
                                              .amount
                                              .toString()),
                                      Text("Added: " +
                                          DateFormat.yMMMd().format(
                                              dailytransactions[i].date)),
                                    ],
                                  ),
                                ),
                                actions: [
                                  TextButton(
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
                            "₹" +
                                dailytransactions[i].amount.toStringAsFixed(0),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.green,
                            ),
                          ),
                        ),
                      ),
                      title: Text(
                        dailytransactions[i].title,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      trailing: Text(
                        DateFormat.yMMMd().format(dailytransactions[i].date),
                        style: TextStyle(
                          color: Colors.white54,
                        ),
                      ),
                    ),
                  ),
                );
              },
              itemCount: dailytransactions.length,
            ),
    );
  }
}
