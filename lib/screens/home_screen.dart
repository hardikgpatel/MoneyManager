import 'dart:math';

import 'package:MoneyManager/model/transaction_model.dart';
import 'package:MoneyManager/provider/transaction_provider.dart';
import 'package:MoneyManager/provider/wallet_provider.dart';
import 'package:MoneyManager/screens/Speech.dart';
import 'package:MoneyManager/screens/add_transaction_screen.dart';
import 'package:MoneyManager/screens/transaction_list_screen.dart';
import 'package:MoneyManager/widget/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class HomeScreen extends HookWidget {
  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    final wallets = useProvider(walletProvider.state);
    final transactions = useProvider(transactionProvider.state);
    var totalAmountInHand = 0;
    var totalExpanse = 0;
    var totalIncome = 0;

    wallets.forEach((element) {
      totalAmountInHand += element.amount;
    });

    transactions.forEach((element) {
      if (element.isExpance) {
        totalExpanse += element.amount;
      } else {
        totalIncome += element.amount;
      }
    });

    var profitLoss = totalIncome - totalExpanse;

    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
        actions: [
          IconButton(
            icon: Icon(Icons.mic),
            onPressed: () {
              Navigator.pushNamed(context, SpeechCommandScreen.routeName);
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Text(
                          '\u20B9${totalAmountInHand.toString()}',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Center(
                        child: Text(
                          'total wallet balance you have.',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Row(
                children: [
                  if (totalExpanse > 0)
                    Flexible(
                      child: Card(
                        color: Colors.red[50],
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20.0, horizontal: 10.0),
                          child: Column(
                            children: [
                              Center(
                                child: Text(
                                  '\u20B9${totalExpanse.toString()}',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Center(
                                child: Text(
                                  'You spent.',
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  if (totalIncome > 0)
                    Flexible(
                      child: Card(
                        color: Colors.green[50],
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20.0, horizontal: 10.0),
                          child: Column(
                            children: [
                              Center(
                                child: Text(
                                  '\u20B9${totalIncome.toString()}',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Center(
                                child: Text(
                                  'You gain.',
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              if (totalIncome > 0 || totalExpanse > 0)
                Card(
                  color: profitLoss > 0 ? Colors.green[50] : Colors.red[50],
                  margin: const EdgeInsets.only(top: 10),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                          child: Text(
                            '\u20B9 ${profitLoss.toString()}',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Center(
                          child: Text(
                            'Your outcome',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ),
                      ],
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
