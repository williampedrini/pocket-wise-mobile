import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/account.dart';
import '../../domain/entities/balance.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/usecases/get_account.dart';
import '../../domain/usecases/get_account_balance.dart';
import '../../domain/usecases/get_transactions.dart';

// Events
abstract class AccountEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadAccount extends AccountEvent {
  final String iban;

  LoadAccount({required this.iban});

  @override
  List<Object?> get props => [iban];
}

// States
abstract class AccountState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AccountInitial extends AccountState {}

class AccountLoading extends AccountState {}

class AccountLoaded extends AccountState {
  final Account account;
  final Balance? balance;
  final List<Transaction> transactions;
  final double totalIncome;
  final double totalExpense;

  AccountLoaded(
    this.account, {
    this.balance,
    this.transactions = const [],
    this.totalIncome = 0.0,
    this.totalExpense = 0.0,
  });

  @override
  List<Object?> get props => [account, balance, transactions, totalIncome, totalExpense];
}

class AccountError extends AccountState {
  final String message;

  AccountError(this.message);

  @override
  List<Object?> get props => [message];
}

// BLoC
class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final GetAccount getAccount;
  final GetAccountBalance getAccountBalance;
  final GetTransactions getTransactions;

  AccountBloc({
    required this.getAccount,
    required this.getAccountBalance,
    required this.getTransactions,
  }) : super(AccountInitial()) {
    on<LoadAccount>(_onLoadAccount);
  }

  static const String defaultIban = 'PT50001000006264381000137';

  Future<void> _onLoadAccount(LoadAccount event, Emitter<AccountState> emit) async {
    emit(AccountLoading());
    try {
      final account = await getAccount(defaultIban);

      // Fetch balance using hardcoded IBAN from event
      Balance? balance;
      try {
        balance = await getAccountBalance(event.iban);
      } catch (e) {
        // Balance fetch failed, continue without it
        balance = null;
      }

      // Fetch transactions
      List<Transaction> transactions = [];
      double totalIncome = 0.0;
      double totalExpense = 0.0;
      try {
        final transactionsResponse = await getTransactions(event.iban);
        transactions = transactionsResponse.transactions;

        // Calculate totals
        for (final tx in transactions) {
          if (tx.isCredit) {
            totalIncome += tx.transactionAmount.amount;
          } else {
            totalExpense += tx.transactionAmount.amount;
          }
        }
      } catch (e) {
        emit(AccountError(e.toString()));
      }

      emit(AccountLoaded(
        account,
        balance: balance,
        transactions: transactions,
        totalIncome: totalIncome,
        totalExpense: totalExpense,
      ));
    } catch (e) {
      emit(AccountError(e.toString()));
    }
  }
}
