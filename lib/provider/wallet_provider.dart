import 'package:MoneyManager/model/wallet_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final defaultWallet = WalletModel(
  amount: 100,
  createdDate: DateTime.now(),
  id: 'Cash',
  isDefault: true,
);

final walletProvider = StateNotifierProvider<WalletStateNotifier>(
    (ref) => WalletStateNotifier([defaultWallet]));

class WalletStateNotifier extends StateNotifier<List<WalletModel>> {

  WalletStateNotifier(state) : super([]);

  void addWallet(WalletModel walletModel) {
    final wallets = state;
    wallets.add(walletModel);
    state = wallets;
  }
}
