import 'dart:io';

import 'package:daily_expenses_app/day_chart.dart';
import 'package:daily_expenses_app/transaction.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MonthChart extends StatelessWidget {
  final List<Transaction> allTransactions;
  MonthChart(this.allTransactions);
  List<Map<String, Object>> get monthlytransactions {
    var temp = allTransactions.first.date.month;
    var length = 1;
    List<Object> tempmonth = [];
    List<double> tempsum = [];
    DateTime date = DateTime.now();
    double sum = 0;
    for (var i = 0; i < allTransactions.length; i++) {
      if (allTransactions[i].date.month == temp) {
        date = allTransactions[i].date;
        sum = sum + allTransactions[i].amount;
      } else {
        length++;
        tempmonth.add(date);
        tempsum.add(sum);
        temp = allTransactions[i].date.month;
        sum = 0.0;
        date = DateTime.now();
        i--;
      }
    }
    tempmonth.add(date);
    tempsum.add(sum);

    return List.generate(length, (index) {
      return {
        'month': DateFormat.yMMM().format(tempmonth[index]).toString(),
        'sum': tempsum[index]
      };
    }).reversed.toList();
  }

  double get totalSpending {
    return monthlytransactions.fold(0.0, (sum, item) {
      return sum + item['sum'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: Platform.isIOS
          ? CupertinoNavigationBar(
              backgroundColor: Colors.grey[900],
              middle: Text(
                "Monthly Graph",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            )
          : AppBar(
              backgroundColor: Colors.grey[900],
              title: Text("Monthly Graph"),
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
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => DayChart(
                          allTransactions, monthlytransactions[i]['month']),
                    ),
                  ),
                  child: Card(
                    color: Colors.grey[900],
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: Colors.black38, width: 1.0),
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.grey[850],
                          ),
                          child: ListTile(
                            trailing: Text(
                              monthlytransactions[i]['month'],
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          child: FractionallySizedBox(
                            widthFactor:
                                (monthlytransactions[i]['sum'] as double) /
                                    totalSpending,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white12,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              height: 58,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 17),
                          child: Text(
                            '₹${(monthlytransactions[i]['sum'] as double).toStringAsFixed(0)}',
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.green,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              itemCount: monthlytransactions.length,
            ),
    );
  }
}
