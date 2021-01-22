import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import './transaction.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TransactionList extends StatelessWidget {
  final Function deleteTransaction;
  final Box<Transaction> transactionbox;
  TransactionList(this.transactionbox, this.deleteTransaction);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height * 0.8,
        child: transactionbox.isEmpty
            ? Column(
                children: [
                  Text(
                    "No Transactions Added Yet!",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  Image.asset('assets/images/empty.png')
                ],
              )
            : ValueListenableBuilder(
                valueListenable: transactionbox.listenable(),
                builder: (BuildContext ctx, Box<Transaction> box, _) {
                  return ListView.builder(
                    itemBuilder: (ctx, index) {
                      int len = box.length;
                      final todo = box.getAt(len - index - 1);
                      return Card(
                        color: Colors.grey[800],
                        shadowColor: Colors.black,
                        elevation: 10,
                        margin: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 2,
                        ),
                        child: ListTile(
                          leading: Container(
                            margin: EdgeInsets.symmetric(vertical: 5),
                            child: Text(
                              "₹" + todo.amount.toStringAsFixed(0),
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
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
                      );
                    },
                    itemCount: box.length,
                  );
                },
              ));
  }
}
