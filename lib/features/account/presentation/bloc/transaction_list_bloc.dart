import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/account.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/usecases/get_accounts.dart';
import '../../domain/usecases/get_transactions.dart';

// Events
abstract class TransactionListEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadTransactionList extends TransactionListEvent {}

class FilterByAccount extends TransactionListEvent {
  final String? iban;

  FilterByAccount({this.iban});

  @override
  List<Object?> get props => [iban];
}

class SearchTransactions extends TransactionListEvent {
  final String query;

  SearchTransactions({required this.query});

  @override
  List<Object?> get props => [query];
}

// States
abstract class TransactionListState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TransactionListInitial extends TransactionListState {}

class TransactionListLoading extends TransactionListState {}

class TransactionListLoaded extends TransactionListState {
  final List<Account> accounts;
  final List<Transaction> transactions;
  final List<Transaction> filteredTransactions;
  final String? selectedAccountIban;
  final String searchQuery;

  TransactionListLoaded({
    required this.accounts,
    required this.transactions,
    required this.filteredTransactions,
    this.selectedAccountIban,
    this.searchQuery = '',
  });

  TransactionListLoaded copyWith({
    List<Account>? accounts,
    List<Transaction>? transactions,
    List<Transaction>? filteredTransactions,
    String? selectedAccountIban,
    String? searchQuery,
    bool clearSelectedAccount = false,
  }) {
    return TransactionListLoaded(
      accounts: accounts ?? this.accounts,
      transactions: transactions ?? this.transactions,
      filteredTransactions: filteredTransactions ?? this.filteredTransactions,
      selectedAccountIban: clearSelectedAccount ? null : (selectedAccountIban ?? this.selectedAccountIban),
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [accounts, transactions, filteredTransactions, selectedAccountIban, searchQuery];
}

class TransactionListError extends TransactionListState {
  final String message;

  TransactionListError(this.message);

  @override
  List<Object?> get props => [message];
}

// BLoC
class TransactionListBloc extends Bloc<TransactionListEvent, TransactionListState> {
  final GetAccounts getAccounts;
  final GetTransactions getTransactions;

  TransactionListBloc({
    required this.getAccounts,
    required this.getTransactions,
  }) : super(TransactionListInitial()) {
    on<LoadTransactionList>(_onLoadTransactionList);
    on<FilterByAccount>(_onFilterByAccount);
    on<SearchTransactions>(_onSearchTransactions);
  }

  Future<void> _onLoadTransactionList(
    LoadTransactionList event,
    Emitter<TransactionListState> emit,
  ) async {
    emit(TransactionListLoading());
    try {
      final accounts = await getAccounts();

      // Load transactions from all accounts
      final List<Transaction> allTransactions = [];
      for (final account in accounts) {
        try {
          final response = await getTransactions(account.accountId.iban);
          allTransactions.addAll(response.transactions);
        } catch (e) {
          // Continue loading other accounts if one fails
        }
      }

      // Sort by date (most recent first)
      allTransactions.sort((a, b) {
        final dateA = a.effectiveDate ?? DateTime(1970);
        final dateB = b.effectiveDate ?? DateTime(1970);
        return dateB.compareTo(dateA);
      });

      emit(TransactionListLoaded(
        accounts: accounts,
        transactions: allTransactions,
        filteredTransactions: allTransactions,
      ));
    } catch (e) {
      emit(TransactionListError(e.toString()));
    }
  }

  Future<void> _onFilterByAccount(
    FilterByAccount event,
    Emitter<TransactionListState> emit,
  ) async {
    final currentState = state;
    if (currentState is TransactionListLoaded) {
      if (event.iban == null) {
        // Show all transactions
        emit(currentState.copyWith(
          filteredTransactions: _applySearchFilter(
            currentState.transactions,
            currentState.searchQuery,
          ),
          clearSelectedAccount: true,
        ));
      } else {
        emit(TransactionListLoading());
        try {
          final response = await getTransactions(event.iban!);
          final transactions = response.transactions;

          // Sort by date (most recent first)
          transactions.sort((a, b) {
            final dateA = a.effectiveDate ?? DateTime(1970);
            final dateB = b.effectiveDate ?? DateTime(1970);
            return dateB.compareTo(dateA);
          });

          emit(currentState.copyWith(
            filteredTransactions: _applySearchFilter(
              transactions,
              currentState.searchQuery,
            ),
            selectedAccountIban: event.iban,
          ));
        } catch (e) {
          emit(TransactionListError(e.toString()));
        }
      }
    }
  }

  void _onSearchTransactions(
    SearchTransactions event,
    Emitter<TransactionListState> emit,
  ) {
    final currentState = state;
    if (currentState is TransactionListLoaded) {
      final baseTransactions = currentState.selectedAccountIban != null
          ? currentState.filteredTransactions
          : currentState.transactions;

      emit(currentState.copyWith(
        filteredTransactions: _applySearchFilter(baseTransactions, event.query),
        searchQuery: event.query,
      ));
    }
  }

  List<Transaction> _applySearchFilter(List<Transaction> transactions, String query) {
    if (query.isEmpty) return transactions;

    final lowerQuery = query.toLowerCase();
    return transactions.where((tx) {
      final counterparty = tx.counterpartyName?.toLowerCase() ?? '';
      final iban = (tx.isCredit ? tx.debtor?.iban : tx.creditor?.iban)?.toLowerCase() ?? '';
      final amount = tx.transactionAmount.amount.toStringAsFixed(2);
      return counterparty.contains(lowerQuery) ||
             iban.contains(lowerQuery) ||
             amount.contains(lowerQuery);
    }).toList();
  }
}
