import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/account.dart';
import '../../domain/entities/balance.dart';
import '../../domain/usecases/get_account.dart';
import '../../domain/usecases/get_account_balance.dart';

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

  AccountLoaded(this.account, {this.balance});

  @override
  List<Object?> get props => [account, balance];
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

  AccountBloc({
    required this.getAccount,
    required this.getAccountBalance,
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
      
      emit(AccountLoaded(account, balance: balance));
    } catch (e) {
      emit(AccountError(e.toString()));
    }
  }
}
