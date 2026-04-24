import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:expense_tracker/presentation/providers/app_provider.dart';
import 'package:expense_tracker/core/constants/app_colors.dart';
import 'package:expense_tracker/core/l10n/app_localizations.dart';
import 'package:expense_tracker/core/utils/formatters.dart';
import 'package:expense_tracker/data/models/transaction_model.dart';
import 'package:expense_tracker/presentation/widgets/transaction_card.dart';
import 'package:expense_tracker/presentation/screens/budget/budget_screen.dart';
import 'package:expense_tracker/presentation/screens/debt/debt_screen.dart';
import 'package:expense_tracker/presentation/screens/settings/settings_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final loc = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ---- App Bar ----
          SliverAppBar(
            expandedHeight: 0,
            floating: true,
            backgroundColor: AppColors.background,
            elevation: 0,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  loc.appTitle,
                  style: GoogleFonts.outfit(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  Formatters.formatMonth(provider.selectedMonth),
                  style: GoogleFonts.outfit(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                onPressed: () => _selectMonth(context, provider),
                icon: const Icon(
                  Icons.calendar_month_rounded,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),

          // ---- Content ----
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 8),

                // ---- Balance Hero Card ----
                _BalanceHeroCard(provider: provider, loc: loc),

                const SizedBox(height: 20),

                // ---- Income / Expense Row ----
                Row(
                  children: [
                    Expanded(
                      child: _SummaryCard(
                        label: loc.totalIncome,
                        amount: provider.totalIncome,
                        currency: provider.currency,
                        isIncome: true,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _SummaryCard(
                        label: loc.totalExpense,
                        amount: provider.totalExpense,
                        currency: provider.currency,
                        isIncome: false,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // ---- Quick Actions ----
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 4,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  children: [
                    _QuickActionItem(
                      icon: Icons.pie_chart_outline_rounded,
                      label: loc.reports,
                      onTap: () {
                        // Assuming you have a reports screen or navigation logic
                      },
                    ),
                    _QuickActionItem(
                      icon: Icons.account_balance_wallet_outlined,
                      label: provider.isArabic ? 'الميزانية' : 'Budget',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const BudgetScreen()),
                      ),
                    ),
                    _QuickActionItem(
                      icon: Icons.handshake_outlined,
                      label: provider.isArabic ? 'الديون' : 'Debts',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const DebtScreen()),
                      ),
                    ),
                    _QuickActionItem(
                      icon: Icons.settings_outlined,
                      label: loc.settings,
                      onTap: () {
                         // Navigation to settings usually from drawer or main nav
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // ---- Recent Transactions ----
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      loc.recentTransactions,
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                if (provider.isLoading)
                  const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                    ),
                  )
                else if (provider.transactions.isEmpty)
                  _EmptyState(loc: loc)
                else
                  ...provider
                      .getRecentTransactions(limit: 5)
                      .map(
                        (t) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: TransactionCard(
                            transaction: t,
                            currency: provider.currency,
                            isArabic: provider.isArabic,
                          ),
                        ),
                      ),

                const SizedBox(height: 80),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  void _selectMonth(BuildContext context, AppProvider provider) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: provider.selectedMonth,
      firstDate: DateTime(now.year - 2),
      lastDate: DateTime(now.year + 1),
      initialDatePickerMode: DatePickerMode.year,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      provider.setSelectedMonth(DateTime(picked.year, picked.month));
    }
  }
}

// ---- Balance Hero Card ----
class _BalanceHeroCard extends StatelessWidget {
  final AppProvider provider;
  final AppLocalizations loc;

  const _BalanceHeroCard({required this.provider, required this.loc});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.4),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            loc.totalBalance,
            style: GoogleFonts.outfit(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            Formatters.formatCurrency(
              provider.netBalance,
              currency: provider.currency,
            ),
            style: GoogleFonts.outfit(
              color: Colors.white,
              fontSize: 34,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 24),
          // Accounts chips
          if (provider.accounts.isNotEmpty)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: provider.accounts
                    .map(
                      (a) => Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: Colors.white.withOpacity(0.3)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.account_balance_wallet,
                                color: Colors.white, size: 14),
                            const SizedBox(width: 6),
                            Text(
                              '${a.name}  ${Formatters.formatCurrency(a.balance, currency: a.currency)}',
                              style: GoogleFonts.outfit(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }
}

// ---- Summary Card ----
  }
}

class _QuickActionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickActionItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(icon, color: AppColors.primary, size: 24),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String label;
  final double amount;
  final String currency;
  final bool isIncome;

  const _SummaryCard({
    required this.label,
    required this.amount,
    required this.currency,
    required this.isIncome,
  });

  @override
  Widget build(BuildContext context) {
    final color = isIncome ? AppColors.income : AppColors.expense;
    final bgColor = isIncome ? AppColors.incomeLight : AppColors.expenseLight;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isIncome
                  ? Icons.arrow_downward_rounded
                  : Icons.arrow_upward_rounded,
              color: color,
              size: 18,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            Formatters.formatCurrency(amount, currency: currency),
            style: GoogleFonts.outfit(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// ---- Empty State ----
class _EmptyState extends StatelessWidget {
  final AppLocalizations loc;
  const _EmptyState({required this.loc});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.secondary.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.receipt_long_rounded,
              size: 40,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            loc.noTransactions,
            style: GoogleFonts.outfit(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            loc.addFirstTransaction,
            style: GoogleFonts.outfit(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
