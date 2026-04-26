import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/app_provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/account_model.dart';
import '../../../data/models/transaction_model.dart';
import '../../widgets/transaction_card.dart';
import '../../widgets/transaction_detail_modal.dart';
import '../add_transaction/add_transaction_screen.dart';

class AccountDetailsScreen extends StatefulWidget {
  final AccountModel account;

  const AccountDetailsScreen({super.key, required this.account});

  @override
  State<AccountDetailsScreen> createState() => _AccountDetailsScreenState();
}

class _AccountDetailsScreenState extends State<AccountDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final loc = AppLocalizations.of(context);
    final account = widget.account;

    // Get transactions for this account
    final accountTransactions = provider.transactions.where((t) => t.accountId == account.id).toList();
    final income = accountTransactions.where((t) => t.type == 'income').fold(0.0, (sum, t) => sum + t.amount);
    final expense = accountTransactions.where((t) => t.type == 'expense').fold(0.0, (sum, t) => sum + t.amount);
    final net = income - expense;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          account.name,
          style: GoogleFonts.outfit(fontWeight: FontWeight.w700),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _showEditAccountDialog(context, provider, loc, account),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Account Header Card
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(int.parse(account.color.replaceFirst('#', '0xFF'))), Color(int.parse(account.color.replaceFirst('#', '0xFF'))).withOpacity(0.7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _getAccountIcon(account.icon),
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            account.name,
                            style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            _getAccountTypeLabel(account.type, loc),
                            style: GoogleFonts.outfit(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      Formatters.formatCurrency(account.balance, currency: provider.currency, isArabic: provider.isArabic),
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      provider.currency,
                      style: GoogleFonts.outfit(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Quick Actions
          Row(
            children: [
              Expanded(
                child: _buildQuickActionButton(
                  context,
                  Icons.arrow_downward,
                  loc.income,
                  AppColors.income,
                  () => _addTransaction(context, 'income', account),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickActionButton(
                  context,
                  Icons.arrow_upward,
                  loc.expense,
                  AppColors.expense,
                  () => _addTransaction(context, 'expense', account),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Account Summary
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(20),
              border: Theme.of(context).brightness == Brightness.dark
                  ? Border.all(color: AppColors.darkBorder, width: 1)
                  : null,
            ),
            child: Column(
              children: [
                Text(
                  loc.thisMonthSummary,
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).textTheme.titleLarge?.color,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildSummaryItem(loc.totalIncome, income, AppColors.income, provider),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildSummaryItem(loc.totalExpense, expense, AppColors.expense, provider),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildSummaryItem(loc.remaining, net, net >= 0 ? AppColors.income : AppColors.expense, provider),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Transactions List
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                loc.transactions,
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).textTheme.titleLarge?.color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          if (accountTransactions.isEmpty)
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(20),
                border: Theme.of(context).brightness == Brightness.dark
                    ? Border.all(color: AppColors.darkBorder, width: 1)
                    : null,
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    size: 48,
                    color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    loc.noTransactions,
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                  ),
                ],
              ),
            )
          else
            ...accountTransactions.map(
                  (t) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
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
    );
  }

  Widget _buildQuickActionButton(BuildContext context, IconData icon, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3), width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.outfit(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, double amount, Color color, AppProvider provider) {
    return Column(
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 11,
            color: Theme.of(context).textTheme.bodyMedium?.color,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          Formatters.formatCurrency(amount, currency: provider.currency, isArabic: provider.isArabic),
          style: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  void _addTransaction(BuildContext context, String type, AccountModel account) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddTransactionScreen(
          initialAccount: account,
          initialType: type,
        ),
      ),
    );
  }

  void _showEditAccountDialog(BuildContext context, AppProvider provider, AppLocalizations loc, AccountModel account) {
    // TODO: Implement edit account dialog
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('تعديل الحساب'),
        content: const Text('Edit account functionality coming soon'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(loc.cancel),
          ),
        ],
      ),
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

  IconData _getAccountIcon(String iconName) {
    switch (iconName) {
      case 'wallet':
        return Icons.account_balance_wallet;
      case 'bank':
        return Icons.account_balance;
      case 'credit':
        return Icons.credit_card;
      case 'savings':
        return Icons.savings;
      default:
        return Icons.account_balance_wallet;
    }
  }

  String _getAccountTypeLabel(String type, AppLocalizations loc) {
    switch (type) {
      case 'cash':
        return loc.cash;
      case 'bank':
        return loc.bank;
      case 'credit':
        return loc.credit;
      case 'savings':
        return loc.savings;
      default:
        return type;
    }
  }
}