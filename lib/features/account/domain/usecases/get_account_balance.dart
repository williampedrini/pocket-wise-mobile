import '../../domain/entities/balance.dart';
import '../../domain/repositories/account_repository.dart';

class GetAccountBalance {
  final AccountRepository repository;

  GetAccountBalance(this.repository);

  Future<Balance?> call(String iban) async {
    return await repository.getAccountBalance(iban);
  }
}
