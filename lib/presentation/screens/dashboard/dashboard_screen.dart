import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:expense_tracker/presentation/providers/app_provider.dart';
import 'package:expense_tracker/core/constants/app_colors.dart';
import 'package:expense_tracker/core/l10n/app_localizations.dart';
import 'package:expense_tracker/core/utils/formatters.dart';
import 'package:expense_tracker/data/models/transaction_model.dart';
import 'package:expense_tracker/presentation/widgets/transaction_card.dart';
import 'package:expense_tracker/presentation/widgets/category_manager_modal.dart';
import 'package:expense_tracker/presentation/widgets/transaction_detail_modal.dart';
import 'package:expense_tracker/presentation/screens/budget/budget_screen.dart';
import 'package:expense_tracker/presentation/screens/debt/debt_screen.dart';
import 'package:expense_tracker/presentation/screens/recurring/recurring_screen.dart';
import 'package:expense_tracker/presentation/screens/transactions/transactions_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool obscureBalance = false;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final loc = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          children: [
            // ---- Custom Top App Bar ----
            _buildTopBar(provider, context, loc),
            const SizedBox(height: 24),

            // ---- Balance Hero Card ----
            _buildBalanceCard(provider, loc),
            const SizedBox(height: 24),

            // ---- This Month Summary ----
            Text(
              loc.thisMonthSummary,
              style: GoogleFonts.outfit(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).textTheme.titleLarge?.color,
              ),
            ),
            const SizedBox(height: 12),
            _buildSummaryCard(provider, loc),
            const SizedBox(height: 24),

            // ---- Quick Actions ----
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 5,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              children: [
                _QuickActionItem(
                  icon: Icons.account_balance_wallet_outlined,
                  label: loc.budget,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const BudgetScreen()),
                  ),
                ),
                _QuickActionItem(
                  icon: Icons.handshake_outlined,
                  label: loc.debts,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const DebtScreen()),
                  ),
                ),
                _QuickActionItem(
                  icon: Icons.autorenew_rounded,
                  label: loc.recurringTransactions,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RecurringScreen()),
                  ),
                ),
                _QuickActionItem(
                  icon: Icons.category_outlined,
                  label: loc.categories,
                  onTap: () => _showCategoriesSheet(context, provider, loc),
                ),
                _QuickActionItem(
                  icon: Icons.receipt_long_outlined,
                  label: loc.transactions,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const TransactionsScreen()),
                  ),
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
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).textTheme.titleLarge?.color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (provider.isLoading)
              const Center(child: CircularProgressIndicator(color: AppColors.primary))
            else if (provider.transactions.isEmpty)
              _EmptyState(loc: loc)
            else
              ...provider.getRecentTransactions(limit: 5).map(
                    (t) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: GestureDetector(
                        onTap: () => _showTransactionDetails(context, t, provider),
                        child: TransactionCard(
                          transaction: t,
                          currency: provider.currency,
                          isArabic: provider.isArabic,
                        ),
                      ),
                    ),
                  ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  // --- TOP BAR ---
  Widget _buildTopBar(AppProvider provider, BuildContext context, AppLocalizations loc) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              child: Icon(Icons.person, color: Theme.of(context).colorScheme.primary, size: 28),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  loc.welcome + ' 👋',
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).textTheme.titleLarge?.color,
                  ),
                ),
                Text(
                  loc.manageExpenses,
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                ),
              ],
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            shape: BoxShape.circle,
            border: Theme.of(context).brightness == Brightness.dark
                ? Border.all(color: AppColors.darkBorder, width: 1)
                : null,
            boxShadow: const [],
          ),
          child: Icon(
            Icons.notifications_none_rounded,
            color: Theme.of(context).colorScheme.primary,
            size: 24,
          ),
        ),
      ],
    );
  }

  // --- BALANCE HERO CARD ---
  Widget _buildBalanceCard(AppProvider provider, AppLocalizations loc) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.darkSurface, AppColors.darkFab],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [],
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    loc.currentBalance,
                    style: GoogleFonts.outfit(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => setState(() => obscureBalance = !obscureBalance),
                    child: Icon(
                      obscureBalance ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      color: Colors.white.withOpacity(0.8),
                      size: 20,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 8),
              Text(
                obscureBalance
                    ? '••••••••'
                    : Formatters.formatCurrency(provider.netBalance, currency: provider.currency, isArabic: provider.isArabic),
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                loc.totalIncome + ' - ' + loc.totalExpense,
                style: GoogleFonts.outfit(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
          Positioned(
            bottom: 0,
            right: provider.isArabic ? null : 0,
            left: provider.isArabic ? 0 : null,
            child: GestureDetector(
              onTap: () => _showBalanceDetails(context, provider, loc),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  loc.viewDetails,
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  // --- SUMMARY CARD (Donut + Income/Expense) ---
  Widget _buildSummaryCard(AppProvider provider, AppLocalizations loc) {
    final double income = provider.totalIncome;
    final double expense = provider.totalExpense;
    final double total = income + expense;
    final double remaining = income - expense;
    
    // Fallback if empty
    final double incomePct = total == 0 ? 50 : (income / total) * 100;
    final double expensePct = total == 0 ? 50 : (expense / total) * 100;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Theme.of(context).brightness == Brightness.dark
            ? Border.all(color: AppColors.darkBorder, width: 1)
            : null,
        boxShadow: const [],
      ),
      child: Row(
        children: [
          // Left side (Income/Expense indicators)
          Expanded(
            flex: 5,
            child: Column(
              children: [
                _buildSmallIndicator(
                  label: loc.totalIncome,
                  amount: income,
                  currency: provider.currency,
                  isIncome: true,
                  context: context,
                  isArabic: provider.isArabic,
                ),
                const SizedBox(height: 12),
                _buildSmallIndicator(
                  label: loc.totalExpense,
                  amount: expense,
                  currency: provider.currency,
                  isIncome: false,
                  context: context,
                  isArabic: provider.isArabic,
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Right side (Donut Chart)
          Expanded(
            flex: 4,
            child: SizedBox(
              height: 120,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  PieChart(
                    PieChartData(
                      sectionsSpace: 0,
                      centerSpaceRadius: 40,
                      startDegreeOffset: -90,
                      sections: [
                        PieChartSectionData(
                          color: Theme.of(context).colorScheme.primary,
                          value: incomePct,
                          title: '',
                          radius: 12,
                        ),
                        PieChartSectionData(
                          color: Theme.of(context).colorScheme.secondary,
                          value: expensePct,
                          title: '',
                          radius: 12,
                        ),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        loc.remaining,
                        style: GoogleFonts.outfit(
                          fontSize: 10,
                          color: Theme.of(context).textTheme.bodyMedium?.color,
                        ),
                      ),
                      Text(
                        Formatters.formatCurrency(remaining, currency: ''),
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.titleLarge?.color,
                        ),
                      ),
                      Text(
                        provider.currency,
                        style: GoogleFonts.outfit(
                          fontSize: 10,
                          color: Theme.of(context).textTheme.bodyMedium?.color,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmallIndicator({
    required String label,
    required double amount,
    required String currency,
    required bool isIncome,
    required BuildContext context,
    required bool isArabic,
  }) {
    final color = isIncome ? AppColors.income : AppColors.expense;
    final bgColor = isIncome ? AppColors.incomeLight.withOpacity(0.3) : AppColors.expenseLight.withOpacity(0.3);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Theme.of(context).brightness == Brightness.dark
            ? Border.all(color: AppColors.darkBorder, width: 1)
            : null,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isIncome ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
              color: color,
              size: 14,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.outfit(
                    fontSize: 11,
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                ),
                Text(
                  Formatters.formatCurrency(amount, currency: currency, isArabic: isArabic),
                  style: GoogleFonts.outfit(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.titleLarge?.color,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- CATEGORIES BOTTOM SHEET ---
  void _showCategoriesSheet(BuildContext context, AppProvider provider, AppLocalizations loc) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const CategoryManagerModal(),
    );
  }

  void _showTransactionDetails(BuildContext context, TransactionModel t, AppProvider provider) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => TransactionDetailModal(transaction: t, provider: provider),
    );
  }

  void _showBalanceDetails(BuildContext context, AppProvider provider, AppLocalizations loc) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          border: Theme.of(context).brightness == Brightness.dark ? Border.all(color: AppColors.darkBorder) : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              loc.currentBalance,
              style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            _buildDetailRow(loc.totalIncome, provider.totalIncome, AppColors.income, provider),
            const SizedBox(height: 12),
            _buildDetailRow(loc.totalExpense, provider.totalExpense, AppColors.expense, provider),
            const Divider(height: 32),
            _buildDetailRow(loc.remaining, provider.totalIncome - provider.totalExpense, Theme.of(context).colorScheme.primary, provider, isBold: true),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  provider.setNavigationIndex(1);
                },
                child: Text(loc.viewDetails), // Using "View All" logic
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, double amount, Color color, AppProvider provider, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: GoogleFonts.outfit(fontSize: 14)),
        Text(
          Formatters.formatCurrency(amount, currency: provider.currency, isArabic: provider.isArabic),
          style: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
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
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(15),
              border: Theme.of(context).brightness == Brightness.dark
                  ? Border.all(color: AppColors.darkBorder, width: 1)
                  : null,
              boxShadow: const [],
            ),
            child: Icon(icon, color: Theme.of(context).colorScheme.primary, size: 24),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).textTheme.titleLarge?.color,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final AppLocalizations loc;
  const _EmptyState({required this.loc});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Theme.of(context).brightness == Brightness.dark
            ? Border.all(color: AppColors.darkBorder, width: 1)
            : null,
        boxShadow: const [],
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
              color: Theme.of(context).textTheme.titleLarge?.color,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            loc.addFirstTransaction,
            style: GoogleFonts.outfit(
              fontSize: 13,
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
          ),
        ],
      ),
    );
  }
}
