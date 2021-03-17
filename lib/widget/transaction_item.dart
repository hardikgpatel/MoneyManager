import 'package:MoneyManager/model/transaction_model.dart';
import 'package:MoneyManager/widget/timer_widget.dart';
import 'package:flutter/material.dart';

class TransactionItem extends StatelessWidget {
  
  final TransactionModel transaction;

  const TransactionItem({Key? key, required this.transaction}) : super(key: key);
  
  @override
  Widget build( BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 10.0,
        vertical: 5.0,
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              transaction.title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${transaction.isExpance ? '-' : '+'}${transaction.amount.toString()}',
                  style: TextStyle(
                    fontSize: 16,
                    color: transaction.isExpance
                        ? Colors.red
                        : Colors.green,
                  ),
                ),
                TimerWidget(time: transaction.transactionDate),
              ],
            ),

          ],
        ),
      ),
    );
  }
}
