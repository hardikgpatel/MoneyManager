import 'package:MoneyManager/model/transaction_model.dart';
import 'package:MoneyManager/provider/transaction_provider.dart';
import 'package:MoneyManager/provider/wallet_provider.dart';
import 'package:MoneyManager/screens/transaction_list_screen.dart';
import 'package:MoneyManager/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AddTransactionScreen extends HookWidget {
  static const routeName = 'AddTransactionScreen';

  @override
  Widget build(BuildContext context) {
    final TextEditingController? _titleController = useTextEditingController();
    final TextEditingController? _descriptionController =
        useTextEditingController();
    final TextEditingController? _amountController = useTextEditingController();
    final wallets = useProvider(walletProvider.state);
    wallets.sort((a, b) {
      if (b.isDefault) {
        return 1;
      }
      return -1;
    });
    final selectedWallet = useState(wallets[0].id);
    final isExpense = useState('Expense');

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
                  SizedBox(
                    width: 10,
                  ),
                  DropdownButton(
                    value: selectedWallet.value,
                    onChanged: (dynamic value) {
                      selectedWallet.value = value;
                    },
                    hint: Text('Select Wallet'),
                    items: wallets.map<DropdownMenuItem<String>>((wallet) {
                      if (wallet.isDefault) {
                        selectedWallet.value = wallet.id;
                      }
                      return DropdownMenuItem<String>(
                        value: wallet.id,
                        key: ValueKey(wallet.id),
                        child: Text('${wallet.id} (\u20B9${wallet.amount})'),
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
                height: 10.0,
              ),
              Row(
                children: [
                  Text('Transaction as '),
                  SizedBox(
                    width: 10,
                  ),
                  DropdownButton(
                    value: isExpense.value,
                    onChanged: (dynamic value) {
                      isExpense.value = value;
                    },
                    hint: Text('Select Transaction Type'),
                    items: ['Expense', 'Income']
                        .map<DropdownMenuItem<String>>((tType) {
                      return DropdownMenuItem<String>(
                        value: tType,
                        key: ValueKey(tType),
                        child: Text(tType),
                      );
                    }).toList(),
                  ),
                ],
              ),
              SizedBox(
                height: 18.0,
              ),
              ElevatedButton.icon(
                onPressed: () {
                  final int selectedAmount = int.parse(_amountController!.text);
                  final int selectedWalletAmount = wallets
                      .firstWhere(
                          (element) => element.id == selectedWallet.value)
                      .amount;
                  if (selectedAmount <= selectedWalletAmount || isExpense.value == 'Income') {
                    TransactionModel _transaction = TransactionModel(
                      title: _titleController!.text,
                      amount: int.parse(_amountController.text),
                      wallet: selectedWallet.value,
                      description: _descriptionController!.text,
                      transactionDate: DateTime.now(),
                      isExpance: isExpense.value == 'Expense',
                    );

                    context
                        .read(transactionProvider)
                        .addTransaction(_transaction);

                    _titleController.clear();
                    _amountController.clear();
                    _descriptionController.clear();

                    Navigator.of(context)
                        .pop(TransactionListScreen.routeName);
                  } else {
                    Utils.showCustomDialog(
                      context: context,
                      title: 'Insufficient fund',
                      content:
                          'Your wallet \'${selectedWallet.value}\' does not have enough fund to complete this transaction, you required more \u20B9${selectedAmount - selectedWalletAmount} to complete this transaction',
                    );
                  }
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
