import 'package:flutter/material.dart';

class MonthChart extends StatelessWidget {
  final List<Map<String, Object>> monthly_transactions = [
    {
      'month': "Jan 2021",
      'sum': 15000.0,
    },
    {
      'month': "Feb 2021",
      'sum': 10510.0,
    },
    {
      'month': "Mar 2021",
      'sum': 5201.0,
    },
    {
      'month': "Apr 2021",
      'sum': 20000.0,
    },
  ];
  double get totalSpending {
    return monthly_transactions.fold(0.0, (sum, item) {
      return sum + item['sum'];
    });
  }

  @override
  Widget build(BuildContext context) {
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
                      monthly_transactions[i]['month'],
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Container(
                  child: FractionallySizedBox(
                    widthFactor: (monthly_transactions[i]['sum'] as double) /
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
                    '₹${(monthly_transactions[i]['sum'] as double).toStringAsFixed(0)}',
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
        itemCount: monthly_transactions.length,
      ),
    );
  }
}
