import '../../domain/entities/transaction.dart';

class TransactionAmountModel extends TransactionAmount {
  const TransactionAmountModel({
    required super.currency,
    required super.amount,
  });

  factory TransactionAmountModel.fromJson(Map<String, dynamic> json) {
    return TransactionAmountModel(
      currency: json['currency'] as String,
      amount: double.parse(json['amount'] as String),
    );
  }
}

class TransactionPartyModel extends TransactionParty {
  const TransactionPartyModel({super.name, super.iban});

  factory TransactionPartyModel.fromJson(Map<String, dynamic>? json, Map<String, dynamic>? accountJson) {
    if (json == null && accountJson == null) {
      return const TransactionPartyModel();
    }
    return TransactionPartyModel(
      name: json?['name'] as String?,
      iban: accountJson?['iban'] as String?,
    );
  }
}

class TransactionModel extends Transaction {
  const TransactionModel({
    super.transactionId,
    super.entryReference,
    super.transactionDate,
    super.bookingDate,
    super.valueDate,
    required super.transactionAmount,
    required super.creditDebitIndicator,
    required super.status,
    super.creditor,
    super.debtor,
    super.referenceNumber,
    super.remittanceInformation,
    super.merchantCategoryCode,
    super.balanceAfterTransaction,
    super.note,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      transactionId: json['transaction_id'] as String?,
      entryReference: json['entry_reference'] as String?,
      transactionDate: json['transaction_date'] != null
          ? DateTime.parse(json['transaction_date'] as String)
          : null,
      bookingDate: json['booking_date'] != null
          ? DateTime.parse(json['booking_date'] as String)
          : null,
      valueDate: json['value_date'] != null
          ? DateTime.parse(json['value_date'] as String)
          : null,
      transactionAmount: TransactionAmountModel.fromJson(
        json['transaction_amount'] as Map<String, dynamic>,
      ),
      creditDebitIndicator: json['credit_debit_indicator'] as String,
      status: json['status'] as String,
      creditor: json['creditor'] != null || json['creditor_account'] != null
          ? TransactionPartyModel.fromJson(
              json['creditor'] as Map<String, dynamic>?,
              json['creditor_account'] as Map<String, dynamic>?,
            )
          : null,
      debtor: json['debtor'] != null || json['debtor_account'] != null
          ? TransactionPartyModel.fromJson(
              json['debtor'] as Map<String, dynamic>?,
              json['debtor_account'] as Map<String, dynamic>?,
            )
          : null,
      referenceNumber: json['reference_number'] as String?,
      remittanceInformation: json['remittance_information'] != null
          ? List<String>.from(json['remittance_information'] as List)
          : null,
      merchantCategoryCode: json['merchant_category_code'] as String?,
      balanceAfterTransaction: json['balance_after_transaction'] != null
          ? TransactionAmountModel.fromJson(
              json['balance_after_transaction'] as Map<String, dynamic>,
            )
          : null,
      note: json['note'] as String?,
    );
  }
}

class TransactionsResponseModel extends TransactionsResponse {
  const TransactionsResponseModel({
    required super.transactions,
  });

  factory TransactionsResponseModel.fromJson(List<dynamic> transactionsList) {
    return TransactionsResponseModel(
      transactions: transactionsList
          .map((tx) => TransactionModel.fromJson(tx as Map<String, dynamic>))
          .toList(),
    );
  }
}
