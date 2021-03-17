import 'package:MoneyManager/model/transaction_model.dart';
import 'package:MoneyManager/model/wallet_model.dart';
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
    final transactionAmount = useState(0);
    _amountController?.addListener(() {
      transactionAmount.value = int.parse(_amountController.text);
      print(transactionAmount);
    });
    wallets.sort((a, b) {
      if (b.isDefault) {
        return 1;
      }
      return -1;
    });
    final selectedWallet = useState(wallets[0].id);
    final isExpense = useState('Expense');

    Widget buildWallets() {
      return Container(
        height: 130,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            final bool isValid = isExpense.value == 'Expense' ? transactionAmount.value <= wallets[index].amount : true;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  selectedWallet.value = wallets[index].id;
                },
                child: Card(
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    width: 130,
                    decoration: BoxDecoration(
                      border: Border.all(color: isValid ? selectedWallet.value == wallets[index].id ? Colors.blue : Colors.grey : Colors.red),
                      borderRadius: BorderRadius.circular(5)
                    ),
                    child: Column(
                      children: [
                        Text(wallets[index].id, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
                        SizedBox(height: 10,),
                        Text(wallets[index].amount.toString(), style: TextStyle(fontSize: 18),),
                        SizedBox(height: 10,),
                        if(!isValid)
                          Text('Insufficient balance', style: TextStyle(color: Colors.red, fontSize: 12),),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
          itemCount: wallets.length,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Transaction'),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Container(
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Text('Transaction From '),
                      buildWallets(),
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
                      if (selectedAmount <= selectedWalletAmount ||
                          isExpense.value == 'Income') {
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

                        Navigator.of(context).pop(TransactionListScreen.routeName);
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
            )
          ],
        ),
      ),
    );
  }
}
