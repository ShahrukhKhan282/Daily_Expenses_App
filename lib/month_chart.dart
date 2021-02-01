import 'package:daily_expenses_app/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MonthChart extends StatelessWidget {
  final List<Transaction> allTransactions;
  MonthChart(this.allTransactions);
  // final List<Map<String, Object>> monthly_transactions = [
  // {
  //   'month': "Jan 2021",
  //   'sum': 15000.0,
  // },
  // {
  //   'month': "Feb 2021",
  //   'sum': 10510.0,
  // },
  // {
  //   'month': "Mar 2021",
  //   'sum': 5201.0,
  // },
  // {
  //   'month': "Apr 2021",
  //   'sum': 20000.0,
  // },
  //];
  List<Map<String, Object>> get monthlytransactions {
    var temp = allTransactions.first.date.month;
    var length = 0;

    List<Object> tempmonth = [];
    List<double> tempsum = [];
    print("temp1:" + temp.toString());
    for (var i = 0; i < allTransactions.length; i++) {
      if (allTransactions.elementAt(i).date.month != temp) {
        length++;
        temp = allTransactions.elementAt(i).date.month;
      }
    }
    print("lenght:" + length.toString());
    temp = allTransactions.first.date.month;

    for (var i = 0; i < length; i++) {
      var j;
      DateTime date = DateTime.now();
      double sum = 0;
      for (j = 0; j < allTransactions.length; j++) {
        if (allTransactions[j].date.month == temp) {
          date = allTransactions[j].date;
          sum = sum + allTransactions[j].amount;
        }
      }
      tempmonth.add(date);
      tempsum.add(sum);
      print("temp2:" + temp.toString());
      temp = allTransactions[i].date.month;
    }

    return List.generate(length, (index) {
      return {
        'month': DateFormat.yMMM().format(tempmonth[index]).toString(),
        'sum': tempsum[index]
      };
    }).toList();
  }

  double get totalSpending {
    return monthlytransactions.fold(0.0, (sum, item) {
      return sum + item['sum'];
    });
  }

  @override
  Widget build(BuildContext context) {
    //print(allTransactions);
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: Text("Monthly Chart"),
      ),
      body: ListView.builder(
        itemBuilder: (context, i) {
          return Card(
            color: Colors.grey[900],
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black38, width: 1.0),
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
                    widthFactor: (monthlytransactions[i]['sum'] as double) /
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
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 17),
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
          );
        },
        itemCount: monthlytransactions.length,
      ),
    );
  }
}
