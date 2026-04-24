import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/app_provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/budget_model.dart';
import '../../../core/utils/formatters.dart';

class BudgetScreen extends StatelessWidget {
  const BudgetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final isArabic = provider.isArabic;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          isArabic ? 'الميزانية الشهرية' : 'Monthly Budget',
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
            margin: const EdgeInsets.bottom(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadow.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
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
                      icon: const Icon(Icons.edit_note_rounded, color: AppColors.primary),
                      onPressed: () => _showSetBudgetDialog(context, category.id!, budgetAmount),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${isArabic ? 'المصروف:' : 'Spent:'} ${Formatters.formatCurrency(spent, provider.currency)}',
                      style: GoogleFonts.outfit(fontSize: 13, color: AppColors.textSecondary),
                    ),
                    Text(
                      budgetAmount > 0 
                        ? '${isArabic ? 'الميزانية:' : 'Budget:'} ${Formatters.formatCurrency(budgetAmount, provider.currency)}'
                        : (isArabic ? 'لم تحدد ميزانية' : 'No budget set'),
                      style: GoogleFonts.outfit(
                        fontSize: 13, 
                        fontWeight: FontWeight.bold,
                        color: budgetAmount > 0 ? AppColors.primary : AppColors.textLight
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
                    backgroundColor: AppColors.secondary,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isOverBudget ? Colors.red : AppColors.primary
                    ),
                  ),
                ),
                if (isOverBudget) ...[
                  const SizedBox(height: 8),
                  Text(
                    isArabic ? 'لقد تجاوزت الميزانية!' : 'Over budget!',
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

  void _showSetBudgetDialog(BuildContext context, int categoryId, double currentAmount) {
    final controller = TextEditingController(text: currentAmount > 0 ? currentAmount.toString() : '');
    final provider = context.read<AppProvider>();
    final isArabic = provider.isArabic;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          isArabic ? 'تحديد الميزانية' : 'Set Budget',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: isArabic ? 'أدخل المبلغ' : 'Enter amount',
            prefixIcon: const Icon(Icons.account_balance_wallet_rounded),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(isArabic ? 'إلغاء' : 'Cancel'),
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
            child: Text(isArabic ? 'حفظ' : 'Save'),
          ),
        ],
      ),
    );
  }
}
