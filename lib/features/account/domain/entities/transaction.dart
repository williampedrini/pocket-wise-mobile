class TransactionAmount {
  final String currency;
  final double amount;

  const TransactionAmount({
    required this.currency,
    required this.amount,
  });
}

class TransactionParty {
  final String? name;
  final String? iban;

  const TransactionParty({this.name, this.iban});
}

class Transaction {
  final String? transactionId;
  final String? entryReference;
  final DateTime? transactionDate;
  final DateTime? bookingDate;
  final DateTime? valueDate;
  final TransactionAmount transactionAmount;
  final String creditDebitIndicator;
  final String status;
  final TransactionParty? creditor;
  final TransactionParty? debtor;
  final String? referenceNumber;
  final List<String>? remittanceInformation;
  final String? merchantCategoryCode;
  final TransactionAmount? balanceAfterTransaction;
  final String? note;

  const Transaction({
    this.transactionId,
    this.entryReference,
    this.transactionDate,
    this.bookingDate,
    this.valueDate,
    required this.transactionAmount,
    required this.creditDebitIndicator,
    required this.status,
    this.creditor,
    this.debtor,
    this.referenceNumber,
    this.remittanceInformation,
    this.merchantCategoryCode,
    this.balanceAfterTransaction,
    this.note,
  });

  DateTime? get effectiveDate => transactionDate ?? bookingDate ?? valueDate;

  bool get isCredit => creditDebitIndicator == 'CRDT';
  bool get isDebit => creditDebitIndicator == 'DBIT';
  bool get isBooked => status == 'BOOK';
  bool get isPending => status == 'PDNG';

  String? get description {
    if (remittanceInformation != null && remittanceInformation!.isNotEmpty) {
      return remittanceInformation!.join(' - ');
    }
    return note;
  }

  String? get counterpartyName {
    if (isCredit) {
      return debtor?.name;
    } else {
      return creditor?.name;
    }
  }
}

class TransactionsResponse {
  final List<Transaction> transactions;

  const TransactionsResponse({
    required this.transactions,
  });
}
