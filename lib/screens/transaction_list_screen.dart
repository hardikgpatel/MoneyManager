import 'package:MoneyManager/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransactionListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transactions'),
      ),
      body: Consumer(
        builder: (context, ref, _) {
          final transactions = ref(transactionProvider).state;
          return ListView.builder(
            itemBuilder: (context, index) {
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(transactions[index].title),
                      Text(transactions[index].amount.toString()),
                      Text(transactions[index].description),
                      Text(transactions[index].transactionDate.toLocal().toString()),
                      Text(transactions[index].wallet),
                    ],
                  ),
                ),
              );
            },
            itemCount: transactions.length,
          );
        },
      ),
    );
  }
}
