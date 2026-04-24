import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../providers/app_provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/recurring_model.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/l10n/app_localizations.dart';

class RecurringScreen extends StatelessWidget {
  const RecurringScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final loc = AppLocalizations.of(context);
    final isArabic = provider.isArabic;
    final recurringItems = provider.recurring;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          loc.recurringTransactions,
          style: GoogleFonts.outfit(fontWeight: FontWeight.w700),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: recurringItems.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.autorenew_rounded, size: 80, color: AppColors.divider),
                  const SizedBox(height: 16),
                  Text(
                    loc.noRecurringTransactions,
                    style: GoogleFonts.outfit(color: AppColors.textSecondary, fontSize: 16),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: recurringItems.length,
              itemBuilder: (context, index) {
                final item = recurringItems[index];
                final isExpense = item.type == 'expense';
                final color = isExpense ? AppColors.expense : AppColors.income;
                final bgColor = isExpense ? AppColors.expenseLight : AppColors.incomeLight;

                final category = provider.categories.firstWhere(
                  (c) => c.id == item.categoryId,
                  orElse: () => provider.categories.first,
                );

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    leading: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        Icons.autorenew_rounded,
                        color: color,
                        size: 22,
                      ),
                    ),
                    title: Text(
                      isArabic ? category.nameAr : category.name,
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          '${loc.next}: ${DateFormat.yMd().format(item.nextExecution)}',
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          '${loc.every}: ${item.frequency}',
                          style: GoogleFonts.outfit(
                            fontSize: 11,
                            color: AppColors.textLight,
                          ),
                        ),
                      ],
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          Formatters.formatCurrency(item.amount, currency: provider.currency),
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.bold,
                            color: color,
                            fontSize: 15,
                          ),
                        ),
                        Switch(
                          value: item.isActive,
                          onChanged: (val) {
                            provider.toggleRecurringStatus(item);
                          },
                          activeColor: AppColors.primary,
                        ),
                      ],
                    ),
                    onLongPress: () {
                      _showDeleteDialog(context, item.id!, provider, loc);
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddRecurringDialog(context, provider, loc),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, int id, AppProvider provider, AppLocalizations loc) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(loc.deleteRecurring),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(loc.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              provider.deleteRecurring(id);
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.expense),
            child: Text(loc.delete, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showAddRecurringDialog(BuildContext context, AppProvider provider, AppLocalizations loc) {
    final amountCtrl = TextEditingController();
    final noteCtrl = TextEditingController();
    String type = 'expense';
    String frequency = 'monthly';
    int? categoryId = provider.expenseCategories.isNotEmpty ? provider.expenseCategories.first.id : null;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) {
          final categories = type == 'expense' ? provider.expenseCategories : provider.incomeCategories;
          if (categoryId == null || !categories.any((c) => c.id == categoryId)) {
            categoryId = categories.isNotEmpty ? categories.first.id : null;
          }

          return Container(
            height: MediaQuery.of(context).size.height * 0.75,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  loc.addTransaction,
                  style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                // Type Toggle
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => type = 'expense'),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: type == 'expense' ? AppColors.expense : Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: type == 'expense' ? Colors.transparent : AppColors.divider),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            loc.expense,
                            style: TextStyle(color: type == 'expense' ? Colors.white : AppColors.textPrimary),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => type = 'income'),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: type == 'income' ? AppColors.income : Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: type == 'income' ? Colors.transparent : AppColors.divider),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            loc.income,
                            style: TextStyle(color: type == 'income' ? Colors.white : AppColors.textPrimary),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: amountCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: loc.amount,
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<int>(
                  value: categoryId,
                  decoration: InputDecoration(
                    hintText: loc.category,
                  ),
                  items: categories.map((c) {
                    return DropdownMenuItem(
                      value: c.id,
                      child: Text(provider.isArabic ? c.nameAr : c.name),
                    );
                  }).toList(),
                  onChanged: (val) => setState(() => categoryId = val),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: frequency,
                  decoration: InputDecoration(
                    hintText: loc.every,
                  ),
                  items: [
                    DropdownMenuItem(value: 'daily', child: Text(loc.daily)),
                    DropdownMenuItem(value: 'weekly', child: Text(loc.weekly)),
                    DropdownMenuItem(value: 'monthly', child: Text(loc.monthly)),
                    DropdownMenuItem(value: 'yearly', child: Text(loc.yearly)),
                  ],
                  onChanged: (val) => setState(() => frequency = val!),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      final amt = double.tryParse(amountCtrl.text) ?? 0;
                      if (amt > 0 && categoryId != null) {
                        provider.addRecurring(RecurringModel(
                          accountId: provider.accounts.first.id!, // Assuming first account is default
                          categoryId: categoryId!,
                          amount: amt,
                          type: type,
                          note: noteCtrl.text,
                          frequency: frequency,
                          nextExecution: DateTime.now().add(const Duration(days: 30)), // Basic logic for next month
                        ));
                        Navigator.pop(ctx);
                      }
                    },
                    child: Text(loc.saveRecurring),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
