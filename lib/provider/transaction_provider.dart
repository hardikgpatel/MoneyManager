import 'package:MoneyManager/model/transaction_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final transactionProvider =
    StateNotifierProvider<Transaction>((ref) => Transaction());

class Transaction extends StateNotifier<List<TransactionModel>> {
  Transaction() : super([]);

  void addTransaction(TransactionModel transaction) {
    final List<TransactionModel> transactions = state;
    transactions.add(transaction);
    state = transactions;
  }
}
