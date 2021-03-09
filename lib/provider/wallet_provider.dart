import 'package:MoneyManager/model/wallet_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final defaultWallet = WalletModel(
  amount: 100,
  createdDate: DateTime.now(),
  id: 'Cash',
  isDefault: true,
);

final walletProvider = StateNotifierProvider<WalletStateNotifier>(
    (ref) => WalletStateNotifier(ref.read));

class WalletStateNotifier extends StateNotifier<List<WalletModel>> {
  final Reader reader;
  WalletStateNotifier(this.reader) : super([defaultWallet]);

  void addWallet(WalletModel walletModel) {
    final List<WalletModel> wallets = state;
    wallets.forEach((element) {
      element.changeDefault(false);
    });
    wallets.add(walletModel);
    state = wallets;
  }

  void deductAmount({required int amount, String? walletId}) {
    final WalletModel wallet = state.firstWhere((w) => w.id == walletId);
    wallet.deductAmount(amount);
  }

  void addAmount({required int amount, required String walletId}) {
    final WalletModel wallet = state.firstWhere((w) => w.id == walletId);
    wallet.addAmount(amount);
  }

  void markAsDefault({String? walletId}) {
    final List<WalletModel> list = state;
    list.forEach((wallet) {
      if (wallet.id == walletId) {
        wallet.changeDefault(true);
      } else {
        wallet.changeDefault(false);
      }
    });
    state = list;
  }

  void removeWallet({String? walletId}) {
    final List<WalletModel> list = state;
    list.removeAt(list.indexWhere((element) => element.id == walletId));
    state = list;
  }
}
