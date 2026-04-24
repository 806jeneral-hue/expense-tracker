import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/app_provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../widgets/transaction_card.dart';
import '../add_transaction/add_transaction_screen.dart';
import '../../../data/models/transaction_model.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final loc = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(loc.transactions),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
            child: Column(
              children: [
                // ---- Search Bar ----
                TextField(
                  controller: _searchController,
                  onChanged: (v) => provider.setSearch(v),
                  decoration: InputDecoration(
                    hintText: loc.search,
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      color: AppColors.textLight,
                    ),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              _searchController.clear();
                              provider.setSearch('');
                            },
                            icon: const Icon(Icons.clear_rounded,
                                color: AppColors.textLight),
                          )
                        : null,
                  ),
                ),

                const SizedBox(height: 12),

                // ---- Filter Chips ----
                Row(
                  children: [
                    _FilterChip(
                      label: loc.all,
                      isSelected: provider.transactionFilter == 'all',
                      onTap: () => provider.setFilter('all'),
                    ),
                    const SizedBox(width: 8),
                    _FilterChip(
                      label: loc.income,
                      isSelected: provider.transactionFilter == 'income',
                      onTap: () => provider.setFilter('income'),
                      color: AppColors.income,
                    ),
                    const SizedBox(width: 8),
                    _FilterChip(
                      label: loc.expense,
                      isSelected: provider.transactionFilter == 'expense',
                      onTap: () => provider.setFilter('expense'),
                      color: AppColors.expense,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ---- Transaction List ----
          Expanded(
            child: provider.isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: AppColors.primary))
                : provider.transactions.isEmpty
                    ? _buildEmpty(loc)
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 80),
                        itemCount: provider.transactions.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final tx = provider.transactions[index];
                          return Dismissible(
                            key: Key(tx.id.toString()),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              margin: const EdgeInsets.symmetric(vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.darkExpense.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Icon(
                                Icons.delete_rounded,
                                color: AppColors.expense,
                              ),
                            ),
                            confirmDismiss: (_) => _confirmDelete(context, loc),
                            onDismissed: (_) =>
                                provider.deleteTransaction(tx),
                            child: TransactionCard(
                              transaction: tx,
                              currency: provider.currency,
                              isArabic: provider.isArabic,
                              onTap: () => _editTransaction(context, tx),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty(AppLocalizations loc) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.secondary.withOpacity(0.4),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.receipt_long_rounded,
              size: 48,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            loc.noTransactions,
            style: GoogleFonts.outfit(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).textTheme.titleLarge?.color,
            ),
          ),
        ],
      ),
    );
  }

  Future<bool?> _confirmDelete(BuildContext context, AppLocalizations loc) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(loc.deleteTransaction),
        content: Text(loc.deleteConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(loc.cancel,
                style: const TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.expense,
            ),
            child: Text(loc.delete),
          ),
        ],
      ),
    );
  }

  void _editTransaction(BuildContext context, TransactionModel tx) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddTransactionScreen(existingTransaction: tx),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? color;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = color ?? AppColors.primary;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? activeColor : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? activeColor.withOpacity(0.3)
                  : Theme.of(context).shadowColor,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
