import 'package:MoneyManager/screens/add_transaction_screen.dart';
import 'package:MoneyManager/screens/transaction_list_screen.dart';
import 'package:MoneyManager/screens/wallet_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class AppDrawer extends HookWidget {
  Widget _drawerItem(title, icon, onTap) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            Icon(icon),
            SizedBox(width: 10,),
            Text(
              title,
              style: TextStyle(
                fontSize: 19,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      color: Colors.white,
      height: double.infinity,
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _drawerItem(
            'Transactions',
            Icons.list,
            () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed(
                TransactionListScreen.routeName,
              );
            },
          ),
          _drawerItem(
            'Wallet',
            Icons.account_balance_wallet_outlined,
                () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed(
                WalletScreen.routeName,
              );
            },
          ),
        ],
      ),
    );
  }
}
