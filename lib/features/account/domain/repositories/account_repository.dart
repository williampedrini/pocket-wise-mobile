import '../../domain/entities/account.dart';
import '../../domain/entities/balance.dart';

abstract class AccountRepository {
  Future<Account> getAccount(String iban);
  Future<Balance?> getAccountBalance(String iban);
}
