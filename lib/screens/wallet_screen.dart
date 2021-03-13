import 'dart:async';

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
    wallets.sort((a, b) {
      if (b.isDefault) {
        return 1;
      }
      return -1;
    });

    PopupMenuItem renderPopupMenuItem(String title, String value) {
      return PopupMenuItem(
        textStyle: TextStyle(
          fontSize: 12,
          color: Colors.black87,
        ),
        child: Text(
          title,
        ),
        value: value,
      );
    }

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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(wallets[index].id),
                          if (!wallets[index].isDefault)
                            PopupMenuButton(
                              onSelected: (dynamic value) {
                                if (value == 'default') {
                                  context.read(walletProvider).markAsDefault(
                                      walletId: wallets[index].id);
                                } else if (value == 'delete') {
                                  context.read(walletProvider).removeWallet(
                                      walletId: wallets[index].id);
                                }
                              },
                              itemBuilder: (context) => [
                                renderPopupMenuItem(
                                    'Mark as default', 'default'),
                                renderPopupMenuItem('Remove wallet', 'delete'),
                              ],
                              child: Container(
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Icon(
                                    Icons.more_vert,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
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
