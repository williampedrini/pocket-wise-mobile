import '../../domain/entities/account.dart';
import '../../domain/entities/balance.dart';
import '../../domain/entities/transaction.dart';

abstract class AccountRepository {
  Future<List<Account>> getAccounts();
  Future<Account> getAccount(String iban);
  Future<Balance?> getAccountBalance(String iban);
  Future<TransactionsResponse> getTransactions(String iban);
}
