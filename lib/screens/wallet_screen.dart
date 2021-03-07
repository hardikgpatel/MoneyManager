import 'package:MoneyManager/provider/wallet_provider.dart';
import 'package:MoneyManager/screens/add_wallet_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class WalletScreen extends HookWidget {
  static const routeName = 'WalletScreen';

  @override
  Widget build(BuildContext context) {
    final wallets = useProvider(walletProvider.state);
    return Scaffold(
      appBar: AppBar(
        title: Text('Wallets'),
      ),
      body: Stack(
        children: [
          ListView.builder(
            itemBuilder: (context, index) {
              return Card(
                margin: EdgeInsets.all(10.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(wallets[index].id),
                      Text(wallets[index].amount.toString()),
                      Text(
                        wallets[index].isDefault
                            ? 'Primary Wallet'
                            : 'Secondary Waller',
                      ),
                    ],
                  ),
                ),
              );
            },
            itemCount: wallets.length,
          ),
          Positioned(
            right: 10,
            bottom: 10,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  AddWalletScreen.routeName,
                );
              },
              child: Icon(
                Icons.add,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
