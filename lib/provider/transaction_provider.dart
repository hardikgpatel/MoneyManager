import 'package:MoneyManager/model/transaction_model.dart';
import 'package:MoneyManager/model/transaction_model.dart';
import 'package:MoneyManager/model/transaction_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final transactionProvider =
    StateNotifierProvider<Transaction>((ref) => Transaction([]));

class Transaction extends StateNotifier<List<TransactionModel>> {
  Transaction(state) : super([]);

  void addTransaction(TransactionModel transaction) {
    state.add(transaction);
  }
}
