import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  final String label;
  final double spendingAmount;
  final double spendingPercentage;
  ChartBar(this.label, this.spendingAmount, this.spendingPercentage);
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        SizedBox(
          height: 4,
        ),
        FittedBox(
          child: Text(
            '₹${spendingAmount.toStringAsFixed(0)}',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(
          height: 4,
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.1,
          width: 10,
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[700], width: 1.0),
                  color: Colors.grey[700],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Container(
                alignment: Alignment.bottomCenter,
                child: FractionallySizedBox(
                  alignment: Alignment.bottomCenter,
                  heightFactor: spendingPercentage,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 4,
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        SizedBox(
          height: 4,
        ),
      ],
    );
  }
}
