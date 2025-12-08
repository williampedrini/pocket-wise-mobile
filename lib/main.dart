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
import 'features/account/presentation/bloc/account_bloc.dart';
import 'features/account/presentation/pages/home_page.dart';

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
    final repository = AccountRepositoryImpl(
      remoteDataSource: AccountRemoteDataSourceImpl(
        client: http.Client(),
        baseUrl: ApiConstants.baseUrl,
      ),
    );

    return MaterialApp(
      title: 'PocketWise',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: BlocProvider(
        create: (_) => AccountBloc(
          getAccount: GetAccount(repository),
          getAccountBalance: GetAccountBalance(repository),
        ),
        child: const HomePage(),
      ),
    );
  }
}
