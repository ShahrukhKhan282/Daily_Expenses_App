import 'package:daily_expenses_app/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class NewTransaction extends StatefulWidget {
  Function addTransaction;

  NewTransaction(this.addTransaction);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final titleController = TextEditingController();

  DateTime dateNow = DateTime.now();

  final amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Card(
          elevation: 5,
          child: Container(
            padding: EdgeInsets.only(
              top: 10,
              left: 10,
              right: 10,
              bottom: 10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextField(
                  controller: titleController,
                  autofocus: true,
                  decoration: InputDecoration(labelText: "Title"),
                  textCapitalization: TextCapitalization.sentences,
                ),
                TextField(
                  controller: amountController,
                  decoration: InputDecoration(labelText: "Amount"),
                  keyboardType: TextInputType.number,
                ),
                Row(
                  children: [
                    Text(dateNow == null
                        ? 'No Date Choosen'
                        : DateFormat.yMMMd().format(dateNow)),
                    FlatButton(
                      onPressed: () {
                        showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2021),
                                lastDate: DateTime.now())
                            .then((value) {
                          if (value == null) {
                            return;
                          }
                          setState(() {
                            dateNow = value;
                          });
                        });
                      },
                      child: Text(
                        "Choose a Date",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor),
                      ),
                    )
                  ],
                ),
                MaterialButton(
                  color: Theme.of(context).primaryColor,
                  onPressed: () {
                    final newTx = Transaction(
                      id: DateTime.now().toString(),
                      title: titleController.text,
                      amount: double.parse(amountController.text),
                      date: dateNow,
                    );
                    widget.addTransaction(newTx);
                  },
                  child: Text("Add Transaction"),
                  textColor: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
