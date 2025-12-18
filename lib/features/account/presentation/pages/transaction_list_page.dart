import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/account.dart';
import '../../domain/entities/transaction.dart';
import '../bloc/transaction_list_bloc.dart';

class TransactionListPage extends StatefulWidget {
  const TransactionListPage({super.key});

  @override
  State<TransactionListPage> createState() => _TransactionListPageState();
}

class _TransactionListPageState extends State<TransactionListPage> {
  @override
  Widget build(BuildContext context) {
    return const TransactionListContent();
  }
}

class TransactionListContent extends StatefulWidget {
  const TransactionListContent({super.key});

  @override
  State<TransactionListContent> createState() => _TransactionListContentState();
}

class _TransactionListContentState extends State<TransactionListContent> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    context.read<TransactionListBloc>().add(LoadTransactionList());
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    setState(() {});
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(seconds: 1), () {
      context.read<TransactionListBloc>().add(SearchTransactions(query: query));
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: BlocBuilder<TransactionListBloc, TransactionListState>(
              builder: (context, state) {
                if (state is TransactionListInitial || state is TransactionListLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  );
                }

                if (state is TransactionListError) {
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
                          onPressed: () => context.read<TransactionListBloc>().add(LoadTransactionList()),
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

                if (state is TransactionListLoaded) {
                  return Column(
                    children: [
                      _AccountFilterDropdown(
                        accounts: state.accounts,
                        selectedIban: state.selectedAccountIban,
                        onChanged: (iban) {
                          context.read<TransactionListBloc>().add(FilterByAccount(iban: iban));
                        },
                      ),
                      Expanded(
                        child: state.filteredTransactions.isEmpty
                            ? _buildEmptyState()
                            : _TransactionListView(
                                transactions: state.filteredTransactions,
                                searchQuery: state.searchQuery,
                              ),
                      ),
                    ],
                  );
                }

                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        controller: _searchController,
        onChanged: _onSearchChanged,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          hintText: 'Search transactions',
          hintStyle: TextStyle(color: Colors.grey.shade500),
          prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: AppColors.textSecondary),
                  onPressed: () {
                    _searchController.clear();
                    _debounceTimer?.cancel();
                    setState(() {});
                    context.read<TransactionListBloc>().add(SearchTransactions(query: ''));
                  },
                )
              : null,
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'No transactions found',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

}

class _AccountFilterDropdown extends StatelessWidget {
  final List<Account> accounts;
  final String? selectedIban;
  final ValueChanged<String?> onChanged;

  const _AccountFilterDropdown({
    required this.accounts,
    required this.selectedIban,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Filter by Account',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String?>(
                value: selectedIban,
                isExpanded: true,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                borderRadius: BorderRadius.circular(8),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
                hint: const Text(
                  'All Accounts',
                  style: TextStyle(color: Colors.black),
                ),
                selectedItemBuilder: (BuildContext context) {
                  return [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'All Accounts',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    ...accounts.map((account) {
                      return Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          account.name,
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }),
                  ];
                },
                items: [
                  const DropdownMenuItem<String?>(
                    value: null,
                    child: Text(
                      'All Accounts',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  ...accounts.map((account) {
                    return DropdownMenuItem<String?>(
                      value: account.accountId.iban,
                      child: Text(
                        account.name,
                        style: const TextStyle(color: Colors.black),
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }),
                ],
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TransactionListView extends StatelessWidget {
  final List<Transaction> transactions;
  final String searchQuery;

  const _TransactionListView({
    required this.transactions,
    this.searchQuery = '',
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        return _TransactionCard(
          transaction: transactions[index],
          searchQuery: searchQuery,
        );
      },
    );
  }
}

class _TransactionCard extends StatelessWidget {
  final Transaction transaction;
  final String searchQuery;

  const _TransactionCard({
    required this.transaction,
    this.searchQuery = '',
  });

  Widget _buildHighlightedText(
    String text, {
    required TextStyle style,
    int? maxLines,
    TextOverflow? overflow,
  }) {
    if (searchQuery.isEmpty) {
      return Text(
        text,
        style: style,
        maxLines: maxLines,
        overflow: overflow,
      );
    }

    final lowerText = text.toLowerCase();
    final lowerQuery = searchQuery.toLowerCase();
    final startIndex = lowerText.indexOf(lowerQuery);

    if (startIndex == -1) {
      return Text(
        text,
        style: style,
        maxLines: maxLines,
        overflow: overflow,
      );
    }

    final endIndex = startIndex + searchQuery.length;
    final beforeMatch = text.substring(0, startIndex);
    final match = text.substring(startIndex, endIndex);
    final afterMatch = text.substring(endIndex);

    return RichText(
      maxLines: maxLines,
      overflow: overflow ?? TextOverflow.clip,
      text: TextSpan(
        style: style,
        children: [
          TextSpan(text: beforeMatch),
          TextSpan(
            text: match,
            style: style.copyWith(
              backgroundColor: AppColors.primary.withValues(alpha: 0.3),
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(text: afterMatch),
        ],
      ),
    );
  }

  IconData _getTransactionIcon() {
    final description = transaction.description?.toLowerCase() ?? '';
    final counterparty = transaction.counterpartyName?.toLowerCase() ?? '';

    if (description.contains('salary') || description.contains('deposit') || transaction.isCredit) {
      if (description.contains('salary')) return Icons.arrow_downward;
      if (description.contains('transfer')) return Icons.swap_horiz;
    }

    if (counterparty.contains('amazon') || description.contains('payment')) {
      return Icons.credit_card;
    }
    if (counterparty.contains('coffee') || counterparty.contains('starbucks')) {
      return Icons.coffee;
    }
    if (counterparty.contains('gas') || counterparty.contains('shell') || counterparty.contains('fuel')) {
      return Icons.local_gas_station;
    }
    if (counterparty.contains('grocery') || counterparty.contains('store') || counterparty.contains('market')) {
      return Icons.shopping_cart;
    }
    if (description.contains('transfer') || counterparty.contains('transfer')) {
      return Icons.swap_horiz;
    }

    return transaction.isCredit ? Icons.arrow_downward : Icons.arrow_upward;
  }

  Color _getIconBackgroundColor() {
    final description = transaction.description?.toLowerCase() ?? '';
    final counterparty = transaction.counterpartyName?.toLowerCase() ?? '';

    if (description.contains('salary')) {
      return const Color(0xFFFFF3E0);
    }
    if (counterparty.contains('coffee') || counterparty.contains('starbucks')) {
      return const Color(0xFFFFEBEE);
    }
    if (counterparty.contains('gas') || counterparty.contains('shell')) {
      return const Color(0xFFFFF8E1);
    }
    if (description.contains('transfer')) {
      return const Color(0xFFE3F2FD);
    }
    if (counterparty.contains('grocery') || counterparty.contains('store')) {
      return const Color(0xFFFFEBEE);
    }
    if (counterparty.contains('amazon')) {
      return const Color(0xFFE3F2FD);
    }

    return transaction.isCredit
        ? AppColors.income.withValues(alpha: 0.1)
        : AppColors.expense.withValues(alpha: 0.1);
  }

  Color _getIconColor() {
    final description = transaction.description?.toLowerCase() ?? '';
    final counterparty = transaction.counterpartyName?.toLowerCase() ?? '';

    if (description.contains('salary')) {
      return Colors.orange;
    }
    if (counterparty.contains('coffee') || counterparty.contains('starbucks')) {
      return Colors.red.shade400;
    }
    if (counterparty.contains('gas') || counterparty.contains('shell')) {
      return Colors.amber.shade700;
    }
    if (description.contains('transfer')) {
      return Colors.blue;
    }
    if (counterparty.contains('grocery') || counterparty.contains('store')) {
      return Colors.red.shade400;
    }
    if (counterparty.contains('amazon')) {
      return Colors.blue;
    }

    return transaction.isCredit ? AppColors.income : AppColors.expense;
  }

  String _formatIban(String? iban) {
    if (iban == null || iban.isEmpty) return '';
    return iban.replaceAllMapped(
      RegExp(r'.{4}'),
      (match) => '${match.group(0)} ',
    ).trim();
  }

  @override
  Widget build(BuildContext context) {
    final isCredit = transaction.isCredit;
    final amount = transaction.transactionAmount.amount.abs();
    final currency = transaction.transactionAmount.currency == 'EUR' ? '\$' : '\$';
    final amountText = '${isCredit ? '+' : '-'}$currency${amount.toStringAsFixed(2)}';
    final amountColor = isCredit ? AppColors.income : AppColors.expense;

    final counterparty = transaction.counterpartyName ?? 'Unknown';
    final date = transaction.effectiveDate;
    final dateText = date != null
        ? '${DateFormat('MMM d, yyyy').format(date)} \u2022 ${DateFormat('HH:mm').format(date)}'
        : '';

    // Get IBAN from creditor or debtor
    final iban = isCredit ? transaction.debtor?.iban : transaction.creditor?.iban;
    final formattedIban = _formatIban(iban);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _getIconBackgroundColor(),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _getTransactionIcon(),
                color: _getIconColor(),
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: _buildHighlightedText(
                          counterparty,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      _buildHighlightedText(
                        amountText,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: amountColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dateText,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade500,
                    ),
                  ),
                  if (formattedIban.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    _buildHighlightedText(
                      formattedIban,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
