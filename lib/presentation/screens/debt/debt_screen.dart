import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/app_provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/debt_model.dart';
import '../../../core/utils/formatters.dart';

class DebtScreen extends StatelessWidget {
  const DebtScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final isArabic = provider.isArabic;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          isArabic ? 'الديون والالتزامات' : 'Debts & Lending',
          style: GoogleFonts.outfit(fontWeight: FontWeight.w700),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline_rounded, color: AppColors.primary, size: 28),
            onPressed: () => _showAddDebtDialog(context),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: provider.debts.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.handshake_outlined, size: 80, color: AppColors.textLight.withOpacity(0.5)),
                  const SizedBox(height: 16),
                  Text(
                    isArabic ? 'لا توجد ديون مسجلة' : 'No debts recorded',
                    style: GoogleFonts.outfit(color: AppColors.textSecondary),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: provider.debts.length,
              itemBuilder: (context, index) {
                final debt = provider.debts[index];
                final isLend = debt.type == 'lend';

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).shadowColor,
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    leading: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: (isLend ? Colors.green : Colors.red).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isLend ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
                        color: isLend ? Colors.green : Colors.red,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      debt.personName,
                      style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isLend 
                            ? (isArabic ? 'فلوس ليك' : 'Owes you') 
                            : (isArabic ? 'فلوس عليك' : 'You owe'),
                          style: GoogleFonts.outfit(fontSize: 12, color: AppColors.textSecondary),
                        ),
                        if (debt.dueDate != null)
                          Text(
                            '${isArabic ? 'تاريخ الاستحقاق:' : 'Due:'} ${Formatters.formatDate(debt.dueDate!)}',
                            style: GoogleFonts.outfit(fontSize: 11, color: Colors.orange),
                          ),
                      ],
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          Formatters.formatCurrency(debt.amount, currency: provider.currency, isArabic: isArabic),
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.bold,
                            color: isLend ? Colors.green : Colors.red,
                          ),
                        ),
                        Checkbox(
                          value: debt.isPaid,
                          activeColor: AppColors.primary,
                          onChanged: (val) {
                            provider.updateDebt(DebtModel(
                              id: debt.id,
                              personName: debt.personName,
                              amount: debt.amount,
                              type: debt.type,
                              isPaid: val ?? false,
                              date: debt.date,
                              dueDate: debt.dueDate,
                              note: debt.note,
                            ));
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  void _showAddDebtDialog(BuildContext context) {
    final nameController = TextEditingController();
    final amountController = TextEditingController();
    String type = 'lend';
    final provider = context.read<AppProvider>();
    final isArabic = provider.isArabic;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(isArabic ? 'إضافة دين جديد' : 'Add New Debt'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: type,
                  decoration: const InputDecoration(),
                  items: [
                    DropdownMenuItem(value: 'lend', child: Text(isArabic ? 'فلوس ليك (سلف)' : 'Lend (They owe you)')),
                    DropdownMenuItem(value: 'borrow', child: Text(isArabic ? 'فلوس عليك (دين)' : 'Borrow (You owe them)')),
                  ],
                  onChanged: (v) => setState(() => type = v!),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(hintText: isArabic ? 'اسم الشخص' : 'Person Name'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(hintText: isArabic ? 'المبلغ' : 'Amount'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: Text(isArabic ? 'إلغاء' : 'Cancel')),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isEmpty || amountController.text.isEmpty) return;
                provider.addDebt(DebtModel(
                  personName: nameController.text,
                  amount: double.tryParse(amountController.text) ?? 0,
                  type: type,
                  date: DateTime.now(),
                ));
                Navigator.pop(ctx);
              },
              child: Text(isArabic ? 'إضافة' : 'Add'),
            ),
          ],
        ),
      ),
    );
  }
}
