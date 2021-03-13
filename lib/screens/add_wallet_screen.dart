import 'package:MoneyManager/model/wallet_model.dart';
import 'package:MoneyManager/provider/wallet_provider.dart';
import 'package:MoneyManager/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AddWalletScreen extends HookWidget {
  static const routeName = 'AddWalletScreen';

  @override
  Widget build(BuildContext context) {
    final wallets = useProvider(walletProvider.state);
    final isDefaultWallet =
        useState(wallets.length == 0);
    final TextEditingController? nameTextController =
        useTextEditingController();
    final TextEditingController? openingAmountController =
        useTextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Wallet'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: nameTextController,
              decoration: InputDecoration(hintText: 'Wallet Name'),
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              controller: openingAmountController,
              decoration: InputDecoration(
                hintText: 'Opening Amount',
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Checkbox(
                  value: isDefaultWallet.value,
                  onChanged: (value) {
                    isDefaultWallet.value = value!;
                  },
                ),
                SizedBox(
                  width: 10.0,
                ),
                Text('Is default Wallet')
              ],
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton.icon(
              onPressed: () {
                if (nameTextController != null &&
                    nameTextController.text.isNotEmpty && openingAmountController != null && openingAmountController.text.isNotEmpty) {

                  final isWallet = wallets.where(
                      (element) => element.id == nameTextController.text);
                  if (isWallet.length == 0) {
                    final walletModel = WalletModel(
                      id: nameTextController.text,
                      amount: int.parse(openingAmountController!.text),
                      isDefault: isDefaultWallet.value,
                      createdDate: DateTime.now(),
                    );

                    context.read(walletProvider).addWallet(walletModel);

                    nameTextController.clear();
                    openingAmountController.clear();
                    Navigator.of(context).pop();
                  } else {
                    Utils.showCustomDialog(
                        context: context,
                        title: 'Invalid Detail',
                        content:
                            'Please enter another name this wallet already exist');
                  }
                } else {
                  Utils.showCustomDialog(
                      context: context,
                      title: 'Invalid Detail',
                      content: 'Please enter wallet name, and amount');
                }
              },
              icon: Icon(Icons.account_balance_wallet_outlined),
              label: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
                child: Text(
                  'Add Wallet',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
