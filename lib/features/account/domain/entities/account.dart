class AccountId {
  final String iban;

  const AccountId({required this.iban});
}

class AccountServicer {
  final String? bicFi;
  final String? clearingSystemMemberId;
  final String? name;

  const AccountServicer({this.bicFi, this.clearingSystemMemberId, this.name});
}

class Account {
  final AccountId accountId;
  final AccountServicer accountServicer;
  final String name;
  final String? details;
  final String? usage;
  final String cashAccountType;
  final String? product;
  final String currency;
  final String? psuStatus;
  final double? creditLimit;
  final String? postalAddress;
  final String uid;

  const Account({
    required this.accountId,
    required this.accountServicer,
    required this.name,
    this.details,
    this.usage,
    required this.cashAccountType,
    this.product,
    required this.currency,
    this.psuStatus,
    this.creditLimit,
    this.postalAddress,
    required this.uid,
  });
}
