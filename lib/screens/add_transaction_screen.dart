import 'package:MoneyManager/model/transaction_model.dart';
import 'package:MoneyManager/provider/transaction_provider.dart';
import 'package:MoneyManager/screens/transaction_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddTransactionScreen extends HookWidget {
  static const routeName = 'AddTransactionScreen';

  @override
  Widget build(BuildContext context) {
    final _titleController = useTextEditingController();
    final _fromController = useTextEditingController();
    final _descriptionController = useTextEditingController();
    final _amountController = useTextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Transaction'),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(hintText: 'Title'),
              ),
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(hintText: 'Amount'),
              ),
              TextField(
                controller: _fromController,
                decoration: InputDecoration(hintText: 'Transaction From'),
              ),
              TextField(
                minLines: 5,
                maxLines: 5,
                controller: _descriptionController,
                decoration: InputDecoration(hintText: 'Description'),
              ),
              SizedBox(
                height: 18.0,
              ),
              ElevatedButton.icon(
                onPressed: () {
                  TransactionModel _transaction = TransactionModel(
                    title: _titleController.text,
                    amount: int.parse(_amountController.text),
                    wallet: _fromController.text,
                    description: _descriptionController.text,
                    transactionDate: DateTime.now(),
                  );

                  context
                      .read(transactionProvider)
                      .addTransaction(_transaction);

                  _titleController.clear();
                  _amountController.clear();
                  _fromController.clear();
                  _descriptionController.clear();

                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.add_to_photos_outlined),
                label: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
                  child: Text(
                    'Add Transaction',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
