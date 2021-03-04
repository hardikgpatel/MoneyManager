import 'package:MoneyManager/provider/transaction_provider.dart';
import 'package:MoneyManager/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TransactionListScreen extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final transactions = useProvider(transactionProvider.state);
    return Scaffold(
      appBar: AppBar(
        title: Text('Transactions'),
      ),
      body: Stack(
        children: [
          ListView.builder(
            itemBuilder: (context, i) {
              return Card(
                margin:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        transactions[i].title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        transactions[i].wallet,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        transactions[i].amount.toString(),
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        transactions[i].description,
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        '${transactions[i].transactionDate.day}/${transactions[i].transactionDate.month}/${transactions[i].transactionDate.year}  ${transactions[i].transactionDate.hour}:${transactions[i].transactionDate.minute}',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            itemCount: transactions.length,
          ),
          Positioned(
            right: 10,
            bottom: 10,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => HomeScreen()));
              },
              child: Icon(
                Icons.add,
              ),
            ),
          )
        ],
      ),
    );
  }
}
