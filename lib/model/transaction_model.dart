class TransactionModel {
  final String title;
  final String wallet;
  final String description;
  final DateTime transactionDate;
  final int amount;
  final bool isExpance;

  TransactionModel({
    required this.title,
    required this.wallet,
    this.description = '',
    required this.transactionDate,
    required this.amount,
    this.isExpance = true,
  });
}
