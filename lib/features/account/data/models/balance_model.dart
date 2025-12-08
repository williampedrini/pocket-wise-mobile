import '../../domain/entities/balance.dart';

class BalanceAmountModel extends BalanceAmount {
  const BalanceAmountModel({
    required super.currency,
    required super.amount,
  });

  factory BalanceAmountModel.fromJson(Map<String, dynamic> json) {
    return BalanceAmountModel(
      currency: json['currency'] as String,
      amount: (json['amount'] as num).toDouble(),
    );
  }
}

class BalanceModel extends Balance {
  const BalanceModel({
    required super.name,
    required super.balanceAmount,
    required super.balanceType,
    super.lastChangeDateTime,
    super.referenceDate,
    super.lastCommittedTransaction,
  });

  factory BalanceModel.fromJson(Map<String, dynamic> json) {
    return BalanceModel(
      name: json['name'] as String,
      balanceAmount: BalanceAmountModel.fromJson(json['balance_amount']),
      balanceType: json['balance_type'] as String,
      lastChangeDateTime: json['last_change_date_time'] != null
          ? DateTime.parse(json['last_change_date_time'] as String)
          : null,
      referenceDate: json['reference_date'] as String?,
      lastCommittedTransaction: json['last_committed_transaction'] as String?,
    );
  }

  /// Returns the most recent balance from a list, filtering out null lastChangeDateTime
  static BalanceModel? getMostRecent(List<BalanceModel> balances) {
    final validBalances = balances
        .where((b) => b.lastChangeDateTime != null)
        .toList();

    if (validBalances.isEmpty) return null;

    validBalances.sort((a, b) =>
        b.lastChangeDateTime!.compareTo(a.lastChangeDateTime!));

    return validBalances.first;
  }
}
