import '../../domain/entities/account.dart';

class AccountIdModel extends AccountId {
  const AccountIdModel({required super.iban});

  factory AccountIdModel.fromJson(Map<String, dynamic> json) {
    return AccountIdModel(iban: json['iban'] as String);
  }
}

class AccountServicerModel extends AccountServicer {
  const AccountServicerModel({super.bicFi, super.clearingSystemMemberId, super.name});

  factory AccountServicerModel.fromJson(Map<String, dynamic> json) {
    return AccountServicerModel(
      bicFi: json['bic_fi'] as String?,
      clearingSystemMemberId: json['clearing_system_member_id'] as String?,
      name: json['name'] as String?,
    );
  }
}

class AccountModel extends Account {
  const AccountModel({
    required super.accountId,
    required super.accountServicer,
    required super.name,
    super.details,
    super.usage,
    required super.cashAccountType,
    super.product,
    required super.currency,
    super.psuStatus,
    super.creditLimit,
    super.postalAddress,
    required super.uid,
  });

  factory AccountModel.fromJson(Map<String, dynamic> json) {
    return AccountModel(
      accountId: AccountIdModel.fromJson(json['account_id']),
      accountServicer: AccountServicerModel.fromJson(json['account_servicer']),
      name: json['name'] as String,
      details: json['details'] as String?,
      usage: json['usage'] as String?,
      cashAccountType: json['cash_account_type'] as String,
      product: json['product'] as String?,
      currency: json['currency'] as String,
      psuStatus: json['psu_status'] as String?,
      creditLimit: (json['credit_limit'] as num?)?.toDouble(),
      postalAddress: json['postal_address'] as String?,
      uid: json['uid'] as String,
    );
  }
}
