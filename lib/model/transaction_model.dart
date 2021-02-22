class TransactionModel {
  final String title;
  final String wallet;
  final String description;
  final DateTime transactionDate;
  final int amount;

  TransactionModel({
    this.title,
    this.wallet,
    this.description = '',
    this.transactionDate,
    this.amount,
  });
}
