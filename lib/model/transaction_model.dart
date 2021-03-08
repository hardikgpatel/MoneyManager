class TransactionModel {
  final String title;
  final String wallet;
  final String description;
  final DateTime transactionDate;
  final int amount;

  TransactionModel({
    required this.title,
    required this.wallet,
    this.description = '',
    required this.transactionDate,
    required this.amount,
  });
}
