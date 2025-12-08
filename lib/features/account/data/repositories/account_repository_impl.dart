import '../../domain/entities/account.dart';
import '../../domain/entities/balance.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/repositories/account_repository.dart';
import '../datasources/account_remote_datasource.dart';

class AccountRepositoryImpl implements AccountRepository {
  final AccountRemoteDataSource remoteDataSource;

  AccountRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Account> getAccount(String iban) async {
    return await remoteDataSource.getAccount(iban);
  }

  @override
  Future<Balance?> getAccountBalance(String iban) async {
    return await remoteDataSource.getAccountBalance(iban);
  }

  @override
  Future<TransactionsResponse> getTransactions(String iban) async {
    return await remoteDataSource.getTransactions(iban);
  }
}
