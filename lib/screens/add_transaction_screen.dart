import 'package:MoneyManager/model/transaction_model.dart';
import 'package:MoneyManager/model/wallet_model.dart';
import 'package:MoneyManager/provider/transaction_provider.dart';
import 'package:MoneyManager/provider/wallet_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AddTransactionScreen extends HookWidget {
  static const routeName = 'AddTransactionScreen';

  @override
  Widget build(BuildContext context) {
    final _titleController = useTextEditingController();
    final _descriptionController = useTextEditingController();
    final _amountController = useTextEditingController();
    final wallets = useProvider(walletProvider.state);
    final selectedWallet = useState(wallets[0].id);

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
              Row(
                children: [
                  Text('Transaction From '),
                  SizedBox(width: 10,),
                  DropdownButton(
                    value: selectedWallet.value ?? WalletModel(id: 'Money'),
                    onChanged: (value) {
                      selectedWallet.value = value;
                    },
                    hint: Text('Select Wallet'),
                    items: wallets.map<DropdownMenuItem<String>>((wallet) {
                      return DropdownMenuItem<String>(
                        value: wallet.id,
                        key: ValueKey(wallet.id),
                        child: Text(wallet.id),
                      );
                    }).toList(),

                  ),
                ],
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
                    wallet: selectedWallet.value,
                    description: _descriptionController.text,
                    transactionDate: DateTime.now(),
                  );

                  context
                      .read(transactionProvider)
                      .addTransaction(_transaction);

                  _titleController.clear();
                  _amountController.clear();
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
