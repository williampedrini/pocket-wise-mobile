import '../../domain/entities/transaction.dart';
import '../../domain/repositories/account_repository.dart';

class GetTransactions {
  final AccountRepository repository;

  GetTransactions(this.repository);

  Future<TransactionsResponse> call(String iban) async {
    return await repository.getTransactions(iban);
  }
}
