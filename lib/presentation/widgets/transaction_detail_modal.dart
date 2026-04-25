import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/transaction_model.dart';
import '../providers/app_provider.dart';
import '../screens/add_transaction/add_transaction_screen.dart';

class TransactionDetailModal extends StatelessWidget {
  final TransactionModel transaction;
  final AppProvider provider;

  const TransactionDetailModal({
    super.key,
    required this.transaction,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final isIncome = transaction.type == 'income';
    
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        border: Theme.of(context).brightness == Brightness.dark
            ? Border.all(color: AppColors.darkBorder, width: 1)
            : null,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.bottom(20),
            decoration: BoxDecoration(
              color: AppColors.divider,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Icon and Category
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: (isIncome ? AppColors.income : AppColors.expense).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isIncome ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
              color: isIncome ? AppColors.income : AppColors.expense,
              size: 32,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            transaction.categoryName ?? loc.other,
            style: GoogleFonts.outfit(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.titleLarge?.color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            Formatters.formatCurrency(transaction.amount, currency: provider.currency, isArabic: provider.isArabic),
            style: GoogleFonts.outfit(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: isIncome ? AppColors.income : AppColors.expense,
            ),
          ),
          const Divider(height: 40),

          // Details List
          _buildDetailRow(loc.date, Formatters.getRelativeDate(transaction.date, today: loc.today, yesterday: loc.yesterday, daysAgo: loc.daysAgo), context),
          _buildDetailRow(loc.account, transaction.accountName ?? loc.mainWallet, context),
          if (transaction.note != null && transaction.note!.isNotEmpty)
            _buildDetailRow(loc.note, transaction.note!, context),

          const SizedBox(height: 32),

          // Actions
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    _showDeleteConfirm(context, loc);
                  },
                  icon: const Icon(Icons.delete_outline_rounded, color: Colors.red),
                  label: Text(loc.delete, style: const TextStyle(color: Colors.red)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.red),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    _editTransaction(context);
                  },
                  icon: const Icon(Icons.edit_rounded),
                  label: Text(loc.edit),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.outfit(color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6))),
          Text(value, style: GoogleFonts.outfit(fontWeight: FontWeight.w600, color: Theme.of(context).textTheme.titleLarge?.color)),
        ],
      ),
    );
  }

  void _showDeleteConfirm(BuildContext context, AppLocalizations loc) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(loc.deleteTransaction),
        content: Text(loc.confirmDelete),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(loc.cancel)),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              provider.deleteTransaction(transaction);
              Navigator.pop(ctx);
            },
            child: Text(loc.delete),
          ),
        ],
      ),
    );
  }

  void _editTransaction(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => AddTransactionScreen(existingTransaction: transaction),
    );
  }
}
