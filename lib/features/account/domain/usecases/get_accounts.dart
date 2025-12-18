import '../entities/account.dart';
import '../repositories/account_repository.dart';

class GetAccounts {
  final AccountRepository repository;

  GetAccounts(this.repository);

  Future<List<Account>> call() async {
    return await repository.getAccounts();
  }
}
