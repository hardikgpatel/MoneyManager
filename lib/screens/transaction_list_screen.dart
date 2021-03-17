import 'package:MoneyManager/provider/transaction_provider.dart';
import 'package:MoneyManager/screens/add_transaction_screen.dart';
import 'package:MoneyManager/utils/images.dart';
import 'package:MoneyManager/widget/ListWidget.dart';
import 'package:MoneyManager/widget/transaction_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TransactionListScreen extends HookWidget {
  static const routeName = 'TransactionListScreen';

  @override
  Widget build(BuildContext context) {
    final transactions = useProvider(transactionProvider.state);
    return Scaffold(
      appBar: AppBar(
        title: Text('Transactions'),
      ),
      body: Stack(
        children: [
          ListWidget(
            emptyListImage: Images.EMPTY_LIST,
            emptyListMessage: 'No transactions found',
            itemBuilder: (context, i) {
              return TransactionItem(transaction: transactions[i]);
            },
            itemCount: transactions.length,
          ),
          Positioned(
            right: 10,
            bottom: 10,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  AddTransactionScreen.routeName,
                );
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
