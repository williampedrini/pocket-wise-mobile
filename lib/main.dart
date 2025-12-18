import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import 'core/constants/api_constants.dart';
import 'core/theme/app_theme.dart';
import 'features/account/data/datasources/account_remote_datasource.dart';
import 'features/account/data/repositories/account_repository_impl.dart';
import 'features/account/domain/usecases/get_account.dart';
import 'features/account/domain/usecases/get_account_balance.dart';
import 'features/account/domain/usecases/get_accounts.dart';
import 'features/account/domain/usecases/get_transactions.dart';
import 'features/account/presentation/bloc/account_bloc.dart';
import 'features/account/presentation/bloc/transaction_list_bloc.dart';
import 'features/account/presentation/pages/main_shell_page.dart';
import 'features/auth/data/datasources/auth_datasource.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/usecases/sign_in_with_google.dart';
import 'features/auth/domain/usecases/sign_out.dart';
import 'features/auth/domain/usecases/get_current_user.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/pages/login_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const PocketWiseApp());
}

class PocketWiseApp extends StatelessWidget {
  const PocketWiseApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Auth dependencies
    final authDataSource = AuthDataSourceImpl();
    final authRepository = AuthRepositoryImpl(dataSource: authDataSource);

    // Account dependencies
    final accountRepository = AccountRepositoryImpl(
      remoteDataSource: AccountRemoteDataSourceImpl(
        client: http.Client(),
        baseUrl: ApiConstants.baseUrl,
      ),
    );

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthBloc(
            signInWithGoogle: SignInWithGoogle(authRepository),
            signOut: SignOut(authRepository),
            getCurrentUser: GetCurrentUser(authRepository),
          ),
        ),
        BlocProvider(
          create: (_) => AccountBloc(
            getAccount: GetAccount(accountRepository),
            getAccountBalance: GetAccountBalance(accountRepository),
            getTransactions: GetTransactions(accountRepository),
          ),
        ),
        BlocProvider(
          create: (_) => TransactionListBloc(
            getAccounts: GetAccounts(accountRepository),
            getTransactions: GetTransactions(accountRepository),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'PocketWise',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const AppNavigator(),
      ),
    );
  }
}

class AppNavigator extends StatefulWidget {
  const AppNavigator({super.key});

  @override
  State<AppNavigator> createState() => _AppNavigatorState();
}

class _AppNavigatorState extends State<AppNavigator> {
  bool _isAuthenticated = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          setState(() => _isAuthenticated = true);
        } else if (state is Unauthenticated) {
          setState(() => _isAuthenticated = false);
        }
      },
      child: _isAuthenticated
          ? const MainShellPage()
          : LoginPage(
              onLoginSuccess: () {
                setState(() => _isAuthenticated = true);
              },
            ),
    );
  }
}
