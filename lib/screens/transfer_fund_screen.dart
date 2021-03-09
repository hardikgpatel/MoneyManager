import 'package:MoneyManager/model/transaction_model.dart';
import 'package:MoneyManager/provider/transaction_provider.dart';
import 'package:MoneyManager/provider/wallet_provider.dart';
import 'package:MoneyManager/screens/transaction_list_screen.dart';
import 'package:MoneyManager/screens/wallet_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TransferFund extends HookWidget {
  static const routeName = 'TransferFundScreen';

  @override
  Widget build(BuildContext context) {
    final TextEditingController? _titleController = useTextEditingController();
    final TextEditingController? _descriptionController =
        useTextEditingController();
    final TextEditingController? _amountController = useTextEditingController();
    final wallets = useProvider(walletProvider.state);
    final selectedWalletFrom = useState(wallets[0].id);
    final selectedWalletTo = useState(wallets[1].id);

    return Scaffold(
      appBar: AppBar(
        title: Text('Fund Transfer'),
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
                  Text('Transfer from From '),
                  SizedBox(
                    width: 10,
                  ),
                  DropdownButton(
                    value: selectedWalletFrom.value,
                    onChanged: (dynamic value) {
                      selectedWalletFrom.value = value;
                    },
                    hint: Text('Select Wallet'),
                    items: wallets.map<DropdownMenuItem<String>>((wallet) {
                      if (wallet.isDefault) {
                        selectedWalletFrom.value = wallet.id;
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
              SizedBox(
                height: 10.0,
              ),
              Row(
                children: [
                  Text('Transfer to '),
                  SizedBox(
                    width: 10,
                  ),
                  DropdownButton(
                    value: selectedWalletTo.value,
                    onChanged: (dynamic value) {
                      selectedWalletTo.value = value;
                    },
                    hint: Text('Select Wallet'),
                    items: wallets.map<DropdownMenuItem<String>>((wallet) {
                      if (wallet.isDefault) {
                        selectedWalletTo.value = wallet.id;
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
              SizedBox(
                height: 10.0,
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
                  TransactionModel transactionTransferFrom = TransactionModel(
                    title: _titleController!.text,
                    amount: int.parse(_amountController!.text),
                    wallet: selectedWalletFrom.value,
                    description: 'Transfer to ${selectedWalletTo.value} for ${_descriptionController!.text}',
                    transactionDate: DateTime.now(),
                    isExpance: true,
                  );

                  context
                      .read(transactionProvider)
                      .addTransaction(transactionTransferFrom);

                  TransactionModel transactionTransferTo = TransactionModel(
                    title: _titleController!.text,
                    amount: int.parse(_amountController!.text),
                    wallet: selectedWalletTo.value,
                    description: 'Transfer from ${selectedWalletFrom.value} for ${_descriptionController!.text}',
                    transactionDate: DateTime.now(),
                    isExpance: false,
                  );

                  context
                      .read(transactionProvider)
                      .addTransaction(transactionTransferTo);

                  _titleController.clear();
                  _amountController.clear();
                  _descriptionController.clear();

                  Navigator.of(context)
                      .pushReplacementNamed(WalletScreen.routeName);
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
