import 'package:MoneyManager/model/transaction_model.dart';
import 'package:MoneyManager/provider/wallet_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final transactionProvider =
    StateNotifierProvider<Transaction>((ref) => Transaction(ref.read));

class Transaction extends StateNotifier<List<TransactionModel>> {
  final Reader reader;

  Transaction(this.reader) : super([]);

  void addTransaction(TransactionModel transaction) {
    final List<TransactionModel> transactions = state;
    transactions.add(transaction);
    state = transactions;
    if(transaction.isExpance) {
      reader(walletProvider).deductAmount(amount: transaction.amount, walletId: transaction.wallet);
    } else {
      reader(walletProvider).addAmount(amount: transaction.amount, walletId: transaction.wallet);
    }
  }
}
