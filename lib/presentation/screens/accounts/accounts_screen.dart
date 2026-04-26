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

class AccountsScreen extends StatefulWidget {
  const AccountsScreen({super.key});

  @override
  State<AccountsScreen> createState() => _AccountsScreenState();
}

class _AccountsScreenState extends State<AccountsScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final loc = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          loc.accounts,
          style: GoogleFonts.outfit(fontWeight: FontWeight.w700),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddAccountDialog(context, provider, loc),
          ),
        ],
      ),
      body: provider.accounts.isEmpty
          ? _buildEmptyState(loc)
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: provider.accounts.length,
              itemBuilder: (context, index) {
                final account = provider.accounts[index];
                return _buildAccountCard(context, account, provider, loc);
              },
            ),
    );
  }

  Widget _buildEmptyState(AppLocalizations loc) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.account_balance_wallet_outlined,
            size: 64,
            color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'لا توجد حسابات',
            style: GoogleFonts.outfit(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'أضف حسابك الأول',
            style: GoogleFonts.outfit(
              fontSize: 14,
              color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountCard(BuildContext context, AccountModel account, AppProvider provider, AppLocalizations loc) {
    // Get transactions for this account
    final accountTransactions = provider.transactions.where((t) => t.accountId == account.id).toList();
    final income = accountTransactions.where((t) => t.type == 'income').fold(0.0, (sum, t) => sum + t.amount);
    final expense = accountTransactions.where((t) => t.type == 'expense').fold(0.0, (sum, t) => sum + t.amount);
    final net = income - expense;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Theme.of(context).brightness == Brightness.dark
            ? Border.all(color: AppColors.darkBorder, width: 1)
            : null,
        boxShadow: const [],
      ),
      child: Column(
        children: [
          // Account Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(int.parse(account.color.replaceFirst('#', '0xFF'))), Color(int.parse(account.color.replaceFirst('#', '0xFF'))).withOpacity(0.7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _getAccountIcon(account.icon),
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        account.name,
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _getAccountTypeLabel(account.type, loc),
                        style: GoogleFonts.outfit(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      Formatters.formatCurrency(account.balance, currency: provider.currency, isArabic: provider.isArabic),
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      provider.currency,
                      style: GoogleFonts.outfit(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Account Summary
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
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
          ),

          // Recent Transactions
          if (accountTransactions.isNotEmpty) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    loc.recentTransactions,
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).textTheme.titleLarge?.color,
                    ),
                  ),
                  TextButton(
                    onPressed: () => _showAllTransactions(context, account, provider, loc),
                    child: Text(
                      loc.seeAll,
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ...accountTransactions.take(3).map(
                  (t) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
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
            const SizedBox(height: 16),
          ],
        ],
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

  void _showAddAccountDialog(BuildContext context, AppProvider provider, AppLocalizations loc) {
    // TODO: Implement add account dialog
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(loc.addAccount),
        content: const Text('Add account functionality coming soon'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(loc.cancel),
          ),
        ],
      ),
    );
  }

  void _showAllTransactions(BuildContext context, AccountModel account, AppProvider provider, AppLocalizations loc) {
    // TODO: Show all transactions for this account
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('${loc.transactions} - ${account.name}'),
        content: const Text('View all transactions functionality coming soon'),
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