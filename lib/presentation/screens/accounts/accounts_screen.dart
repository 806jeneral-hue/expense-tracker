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
import 'account_details_screen.dart';

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
    // Get basic transaction counts for this account
    final accountTransactions = provider.transactions.where((t) => t.accountId == account.id).toList();
    final transactionCount = accountTransactions.length;

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => AccountDetailsScreen(account: account),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
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
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Color(int.parse(account.color.replaceFirst('#', '0xFF'))).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getAccountIcon(account.icon),
                color: Color(int.parse(account.color.replaceFirst('#', '0xFF'))),
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
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).textTheme.titleLarge?.color,
                    ),
                  ),
                  Text(
                    _getAccountTypeLabel(account.type, loc),
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
                    ),
                  ),
                  if (transactionCount > 0)
                    Text(
                      '$transactionCount ${loc.transactions.toLowerCase()}',
                      style: GoogleFonts.outfit(
                        fontSize: 11,
                        color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.5),
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
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.titleLarge?.color,
                  ),
                ),
                Text(
                  provider.currency,
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
                  ),
                ),
              ],
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

  void _showAddAccountDialog(BuildContext context, AppProvider provider, AppLocalizations loc) {
    final _nameController = TextEditingController();
    final _balanceController = TextEditingController(text: '0.0');
    String _selectedType = 'cash';
    String _selectedColor = '#102C26';
    String _selectedIcon = 'wallet';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          border: Theme.of(context).brightness == Brightness.dark
              ? Border.all(color: AppColors.darkBorder)
              : null,
        ),
        child: StatefulBuilder(
          builder: (context, setState) => Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                loc.addAccount,
                style: GoogleFonts.outfit(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),

              // Account Name
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: loc.accountName,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Account Type
              Text(
                loc.accountType,
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  _buildTypeChip('cash', loc.cash, _selectedType, (type) {
                    setState(() => _selectedType = type);
                  }),
                  _buildTypeChip('bank', loc.bank, _selectedType, (type) {
                    setState(() => _selectedType = type);
                  }),
                  _buildTypeChip('credit', loc.credit, _selectedType, (type) {
                    setState(() => _selectedType = type);
                  }),
                  _buildTypeChip('savings', loc.savings, _selectedType, (type) {
                    setState(() => _selectedType = type);
                  }),
                ],
              ),
              const SizedBox(height: 16),

              // Initial Balance
              TextField(
                controller: _balanceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: loc.initialBalance,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(loc.cancel),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_nameController.text.trim().isEmpty) return;

                        final account = AccountModel(
                          name: _nameController.text.trim(),
                          type: _selectedType,
                          balance: double.tryParse(_balanceController.text) ?? 0.0,
                          color: _selectedColor,
                          icon: _selectedIcon,
                        );

                        await provider.addAccount(account);
                        Navigator.pop(ctx);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(loc.save),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeChip(String type, String label, String selectedType, Function(String) onSelected) {
    final isSelected = type == selectedType;
    return GestureDetector(
      onTap: () => onSelected(type),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Theme.of(context).colorScheme.primary : AppColors.darkBorder,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : Theme.of(context).textTheme.bodyMedium?.color,
          ),
        ),
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