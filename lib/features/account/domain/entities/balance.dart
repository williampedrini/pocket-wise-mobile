class BalanceAmount {
  final String currency;
  final double amount;

  const BalanceAmount({
    required this.currency,
    required this.amount,
  });
}

class Balance {
  final String name;
  final BalanceAmount balanceAmount;
  final String balanceType;
  final DateTime? lastChangeDateTime;
  final String? referenceDate;
  final String? lastCommittedTransaction;

  const Balance({
    required this.name,
    required this.balanceAmount,
    required this.balanceType,
    this.lastChangeDateTime,
    this.referenceDate,
    this.lastCommittedTransaction,
  });
}
