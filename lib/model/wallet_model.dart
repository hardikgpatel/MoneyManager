class WalletModel {
  final String id;
  int amount;
  final DateTime createdDate;
  bool isDefault;

  WalletModel({
    required this.id,
    required this.amount,
    required this.createdDate,
    required this.isDefault,
  });

  deductAmount(int value) {
    amount -= value;
  }

  addAmount(int value) {
    amount += value;
  }

  changeDefault(bool value) {
    isDefault = value;
  }
}
