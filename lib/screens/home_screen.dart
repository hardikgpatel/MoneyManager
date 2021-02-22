import 'package:MoneyManager/model/transaction_model.dart';
import 'package:MoneyManager/screens/transaction_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final transactionProvider = StateProvider((ref) => <TransactionModel>[]);

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _titleController;
  TextEditingController _fromController;
  TextEditingController _descriptionController;
  TextEditingController _amountController;

  List<TransactionModel> transactions = [];

  @override
  void initState() {
    _titleController = TextEditingController();
    _fromController = TextEditingController();
    _descriptionController = TextEditingController();
    _amountController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Transaction'),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(10.0),
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
              RaisedButton(
                onPressed: () {
                  print('tap');
                  TransactionModel _transaction = TransactionModel(
                    title: _titleController.text,
                    amount: int.parse(_amountController.text),
                    wallet: _fromController.text,
                    description: _descriptionController.text,
                    transactionDate: DateTime.now(),
                  );

                  final list = context.read(transactionProvider).state;
                  list.add(_transaction);

                  context.read(transactionProvider).state = list;

                  _titleController.clear();
                  _amountController.clear();

                  _fromController.clear();
                  _descriptionController.clear();

                  Navigator.of(context).push(MaterialPageRoute(builder: (_)=>TransactionListScreen()));
                },
                child: Text('Submit'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
