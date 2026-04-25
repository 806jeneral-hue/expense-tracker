import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/app_provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/debt_model.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/l10n/app_localizations.dart';

class DebtScreen extends StatelessWidget {
  const DebtScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final loc = AppLocalizations.of(context);
    final isArabic = provider.isArabic;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          loc.debts,
          style: GoogleFonts.outfit(fontWeight: FontWeight.w700),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.add_circle_outline_rounded, color: Theme.of(context).colorScheme.primary, size: 28),
            onPressed: () => _showAddDebtDialog(context, loc),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: provider.debts.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.handshake_outlined, size: 80, color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.5)),
                  const SizedBox(height: 16),
                  Text(
                    loc.noDebts,
                    style: GoogleFonts.outfit(color: Theme.of(context).textTheme.bodyMedium?.color),
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
                    border: Theme.of(context).brightness == Brightness.dark
                        ? Border.all(color: AppColors.darkBorder, width: 1)
                        : null,
                    boxShadow: const [],
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
                            ? loc.owesYou 
                            : loc.youOwe,
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            color: Theme.of(context).textTheme.bodyMedium?.color,
                          ),
                        ),
                        if (debt.dueDate != null)
                          Text(
                            '${loc.dueDate}: ${Formatters.formatDate(debt.dueDate!)}',
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
                          activeColor: Theme.of(context).colorScheme.primary,
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

  void _showAddDebtDialog(BuildContext context, AppLocalizations loc) {
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
          title: Text(loc.addDebt),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: type,
                  decoration: const InputDecoration(),
                    items: [
                      DropdownMenuItem(value: 'lend', child: Text(loc.owesYou)),
                      DropdownMenuItem(value: 'borrow', child: Text(loc.youOwe)),
                    ],
                  onChanged: (v) => setState(() => type = v!),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(hintText: loc.personName),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(hintText: loc.amount),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: Text(loc.cancel)),
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
              child: Text(loc.save),
            ),
          ],
        ),
      ),
    );
  }
}
