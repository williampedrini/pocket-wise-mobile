import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../bloc/account_bloc.dart';
import '../widgets/home_header.dart';
import '../widgets/balance_card.dart';
import '../widgets/monthly_overview_chart.dart';
import '../widgets/transaction_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static const String defaultIban = 'PT50001000006264381000137';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return const HomeContent();
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<AccountBloc, AccountState>(
        builder: (context, state) {
          if (state is AccountInitial) {
            context.read<AccountBloc>().add(LoadAccount(iban: HomePage.defaultIban));
            return const SizedBox();
          }
          if (state is AccountLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }
          if (state is AccountLoaded) {
            final balance = state.balance;
            final totalBalance = balance?.balanceAmount.amount ?? 0.0;
            final currency = balance?.balanceAmount.currency ?? state.account.currency;
            final currencySymbol = currency == 'EUR' ? '€' : '\$';

            // Get user info from AuthBloc
            final authState = context.watch<AuthBloc>().state;
            final userPhotoUrl = authState is Authenticated ? authState.user.photoUrl : null;
            final userName = authState is Authenticated
                ? (authState.user.displayName?.split(' ').first ?? 'User')
                : 'User';

            return SingleChildScrollView(
              child: Column(
                children: [
                  HomeHeader(
                    userName: userName,
                    avatarUrl: userPhotoUrl,
                  ),
                  BalanceCard(
                    totalBalance: totalBalance,
                    income: state.totalIncome,
                    expense: state.totalExpense,
                    currency: currencySymbol,
                    balanceType: balance?.name,
                    lastUpdated: balance?.lastChangeDateTime,
                    onReload: () => context.read<AccountBloc>().add(
                      LoadAccount(iban: HomePage.defaultIban),
                    ),
                  ),
                  const SizedBox(height: 16),
                  MonthlyOverviewChart(
                    transactions: state.transactions,
                    currency: currencySymbol,
                  ),
                  const SizedBox(height: 8),
                  TransactionList(
                    transactions: state.transactions,
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          }
          if (state is AccountError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<AccountBloc>().add(
                      LoadAccount(iban: HomePage.defaultIban),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
