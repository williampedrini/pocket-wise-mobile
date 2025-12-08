import '../../domain/entities/account.dart';
import '../../domain/repositories/account_repository.dart';

class GetAccount {
  final AccountRepository repository;

  GetAccount(this.repository);

  Future<Account> call(String iban) async {
    return await repository.getAccount(iban);
  }
}
