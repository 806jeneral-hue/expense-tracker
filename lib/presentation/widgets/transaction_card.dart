import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/transaction_model.dart';
import '../../../core/l10n/app_localizations.dart';

class TransactionCard extends StatelessWidget {
  final TransactionModel transaction;
  final String currency;
  final bool isArabic;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const TransactionCard({
    super.key,
    required this.transaction,
    required this.currency,
    this.isArabic = false,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final isExpense = transaction.isExpense;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = isExpense 
        ? (isDark ? AppColors.darkExpense : AppColors.expense) 
        : (isDark ? AppColors.darkIncome : AppColors.income);
    final bgColor = isExpense 
        ? (isDark ? AppColors.darkExpense.withOpacity(0.15) : AppColors.expenseLight) 
        : (isDark ? AppColors.darkIncome.withOpacity(0.15) : AppColors.incomeLight);
    final categoryName = isArabic
        ? (transaction.categoryNameAr ?? transaction.categoryName ?? '')
        : (transaction.categoryName ?? '');

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Theme.of(context).brightness == Brightness.dark
              ? Border.all(color: AppColors.darkBorder, width: 1)
              : null,
          boxShadow: const [],
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                _getCategoryIcon(transaction.categoryIcon),
                color: color,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),

            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    categoryName.isNotEmpty ? categoryName : 'Transaction',
                    style: GoogleFonts.outfit(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).textTheme.titleLarge?.color,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    transaction.note?.isNotEmpty == true
                        ? transaction.note!
                        : Formatters.getRelativeDate(transaction.date,
                            today: loc.today,
                            yesterday: loc.yesterday,
                            daysAgo: loc.daysAgo),
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (transaction.note?.isNotEmpty == true)
                    Text(
                      Formatters.getRelativeDate(transaction.date,
                          today: loc.today,
                          yesterday: loc.yesterday,
                          daysAgo: loc.daysAgo),
                      style: GoogleFonts.outfit(
                        fontSize: 11,
                        color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
                      ),
                    ),
                ],
              ),
            ),

            // Amount
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${isExpense ? '-' : '+'}${Formatters.formatCurrency(transaction.amount, currency: currency, isArabic: isArabic)}',
                  style: GoogleFonts.outfit(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
                if (transaction.accountName != null)
                  Text(
                    transaction.accountName!,
                    style: GoogleFonts.outfit(
                      fontSize: 11,
                      color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
                    ),
                  ),
              ],
            ),

            // Delete button
            if (onDelete != null)
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: GestureDetector(
                  onTap: onDelete,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.expenseLight,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.delete_outline_rounded,
                      size: 16,
                      color: AppColors.expense,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String? iconName) {
    switch (iconName) {
      case 'restaurant':
        return Icons.restaurant_rounded;
      case 'directions_car':
        return Icons.directions_car_rounded;
      case 'shopping_bag':
        return Icons.shopping_bag_rounded;
      case 'local_hospital':
        return Icons.local_hospital_rounded;
      case 'movie':
        return Icons.movie_rounded;
      case 'school':
        return Icons.school_rounded;
      case 'receipt':
        return Icons.receipt_rounded;
      case 'work':
        return Icons.work_rounded;
      case 'laptop':
        return Icons.laptop_rounded;
      case 'trending_up':
        return Icons.trending_up_rounded;
      case 'card_giftcard':
        return Icons.card_giftcard_rounded;
      case 'wallet':
        return Icons.account_balance_wallet_rounded;
      default:
        return Icons.category_rounded;
    }
  }
}
