import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/app_provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/budget_model.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/l10n/app_localizations.dart';

class BudgetScreen extends StatelessWidget {
  const BudgetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final loc = AppLocalizations.of(context);
    final isArabic = provider.isArabic;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          loc.monthlyBudget,
          style: GoogleFonts.outfit(fontWeight: FontWeight.w700),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: provider.expenseCategories.length,
        itemBuilder: (context, index) {
          final category = provider.expenseCategories[index];
          final budgetAmount = provider.getBudgetForCategory(category.id!);
          
          // Calculate spending for this category in current month
          final spent = provider.transactions
              .where((t) => t.categoryId == category.id && t.type == 'expense')
              .fold(0.0, (sum, t) => sum + t.amount);
          
          final percent = budgetAmount > 0 ? (spent / budgetAmount).clamp(0.0, 1.0) : 0.0;
          final isOverBudget = spent > budgetAmount && budgetAmount > 0;

          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(20),
              border: Theme.of(context).brightness == Brightness.dark
                  ? Border.all(color: AppColors.darkBorder, width: 1)
                  : null,
              boxShadow: const [],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Color(int.parse(category.color.replaceFirst('#', '0xFF'))).withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.category_rounded, // Should use icon from category
                            color: Color(int.parse(category.color.replaceFirst('#', '0xFF'))),
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          isArabic ? category.nameAr : category.name,
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: Icon(Icons.edit_note_rounded, color: Theme.of(context).colorScheme.primary),
                      onPressed: () => _showSetBudgetDialog(context, category.id!, budgetAmount, loc),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${loc.spent}: ${Formatters.formatCurrency(spent, currency: provider.currency, isArabic: isArabic)}',
                      style: GoogleFonts.outfit(
                        fontSize: 13,
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                    ),
                    Text(
                      budgetAmount > 0 
                        ? '${loc.budget}: ${Formatters.formatCurrency(budgetAmount, currency: provider.currency, isArabic: isArabic)}'
                        : loc.noBudgetSet,
                      style: GoogleFonts.outfit(
                        fontSize: 13, 
                        fontWeight: FontWeight.bold,
                        color: budgetAmount > 0 
                            ? Theme.of(context).colorScheme.primary 
                            : Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.5)
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: percent,
                    minHeight: 8,
                    backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isOverBudget ? Colors.red : Theme.of(context).colorScheme.primary
                    ),
                  ),
                ),
                if (isOverBudget) ...[
                  const SizedBox(height: 8),
                  Text(
                    loc.overBudget,
                    style: GoogleFonts.outfit(color: Colors.red, fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ]
              ],
            ),
          );
        },
      ),
    );
  }

  void _showSetBudgetDialog(BuildContext context, int categoryId, double currentAmount, AppLocalizations loc) {
    final controller = TextEditingController(text: currentAmount > 0 ? currentAmount.toString() : '');
    final provider = context.read<AppProvider>();
    final isArabic = provider.isArabic;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          loc.setBudget,
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: loc.amount,
            prefixIcon: const Icon(Icons.account_balance_wallet_rounded),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(loc.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              final amount = double.tryParse(controller.text) ?? 0;
              final monthStr = '${provider.selectedMonth.year}-${provider.selectedMonth.month.toString().padLeft(2, '0')}-01';
              provider.addBudget(BudgetModel(
                categoryId: categoryId,
                amount: amount,
                month: monthStr,
              ));
              Navigator.pop(ctx);
            },
            child: Text(loc.save),
          ),
        ],
      ),
    );
  }
}
