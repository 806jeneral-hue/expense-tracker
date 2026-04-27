import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/app_provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../data/models/account_model.dart';

import '../auth/pin_lock_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final loc = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(loc.settings),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 80),
        children: [
          // ---- Accounts Section ----
          _SectionHeader(title: loc.accounts),
          const SizedBox(height: 10),
          _AccountsCard(provider: provider, loc: loc),

          const SizedBox(height: 24),

          // ---- Preferences Section ----
          _SectionHeader(title: loc.language),
          const SizedBox(height: 10),
          _PreferencesCard(provider: provider, loc: loc),

          const SizedBox(height: 24),

          // ---- Currency Section ----
          _SectionHeader(title: loc.currency),
          const SizedBox(height: 10),
          _CurrencyCard(provider: provider, loc: loc),

          const SizedBox(height: 24),

          // ---- Data Management Section ----
          _SectionHeader(title: loc.data),
          const SizedBox(height: 10),
          _DataCard(provider: provider, loc: loc),

          const SizedBox(height: 24),

          // ---- About Section ----
          _SectionHeader(title: loc.about),
          const SizedBox(height: 10),
          _AboutCard(loc: loc),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title.toUpperCase(),
      style: GoogleFonts.outfit(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
        color: AppColors.textSecondary,
      ),
    );
  }
}

// ---- Accounts Card ----
class _AccountsCard extends StatelessWidget {
  final AppProvider provider;
  final AppLocalizations loc;
  const _AccountsCard({required this.provider, required this.loc});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [],
      ),
      child: Column(
        children: [
          // Primary Account Selection
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            leading: Container(
              width: 42, height: 42,
              decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
              child: Icon(Icons.star_rounded, color: Theme.of(context).colorScheme.primary, size: 20),
            ),
            title: Text(loc.isArabic ? 'الحساب الأساسي' : 'Primary Account', 
                style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w600, color: Theme.of(context).textTheme.titleLarge?.color)),
            subtitle: Text(provider.primaryAccount?.name ?? (loc.isArabic ? 'لم يتم تحديد حساب أساسي' : 'No primary account selected'),
                style: GoogleFonts.outfit(fontSize: 12, color: AppColors.textSecondary)),
            trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: AppColors.textSecondary),
            onTap: () => _showPrimaryAccountDialog(context, provider, loc),
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),

          ...provider.accounts.asMap().entries.map((entry) {
            final i = entry.key;
            final acc = entry.value;
            final isPrimary = provider.primaryAccountId == acc.id;
            return Column(
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  leading: Container(
                    width: 42, height: 42,
                    decoration: BoxDecoration(
                      color: isPrimary ? Theme.of(context).colorScheme.primary.withOpacity(0.1) : Theme.of(context).dividerTheme.color?.withOpacity(0.1), 
                      borderRadius: BorderRadius.circular(12)
                    ),
                    child: Icon(
                      isPrimary ? Icons.star_rounded : Icons.account_balance_wallet_rounded, 
                      color: Theme.of(context).colorScheme.primary, 
                      size: 20
                    ),
                  ),
                  title: Row(
                    children: [
                      Text(acc.name, style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w600, color: Theme.of(context).textTheme.titleLarge?.color)),
                      if (isPrimary) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            loc.isArabic ? 'أساسي' : 'Primary',
                            style: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.primary),
                          ),
                        ),
                      ],
                    ],
                  ),
                  subtitle: Text('${acc.type.toUpperCase()} • ${acc.currency}',
                      style: GoogleFonts.outfit(fontSize: 11, color: AppColors.textSecondary)),
                  trailing: Text(
                    '${acc.currency} ${acc.balance.toStringAsFixed(2)}',
                    style: GoogleFonts.outfit(
                        fontSize: 13, fontWeight: FontWeight.w700,
                        color: acc.balance >= 0 ? AppColors.income : AppColors.expense),
                  ),
                ),
                if (i < provider.accounts.length - 1)
                  const Divider(height: 1, indent: 16, endIndent: 16),
              ],
            );
          }),
          const Divider(height: 1),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            leading: Container(
              width: 42, height: 42,
              decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
              child: Icon(Icons.add_rounded, color: Theme.of(context).colorScheme.primary, size: 20),
            ),
            title: Text(loc.addAccount, style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w500, color: Theme.of(context).colorScheme.primary)),
            onTap: () => _showAddAccountDialog(context, provider, loc),
          ),
        ],
      ),
    );
  }

  void _showPrimaryAccountDialog(BuildContext context, AppProvider provider, AppLocalizations loc) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(loc.isArabic ? 'اختر الحساب الأساسي' : 'Select Primary Account'),
        content: provider.accounts.isEmpty
            ? Text(loc.isArabic ? 'لا توجد حسابات متاحة' : 'No accounts available')
            : SizedBox(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: provider.accounts.length + 1, // +1 for "None" option
                  itemBuilder: (context, index) {
                    if (index == provider.accounts.length) {
                      // "None" option
                      final isSelected = provider.primaryAccountId == null;
                      return ListTile(
                        leading: Icon(
                          isSelected ? Icons.star_rounded : Icons.star_border_rounded,
                          color: isSelected ? Theme.of(context).colorScheme.primary : AppColors.textSecondary,
                        ),
                        title: Text(loc.isArabic ? 'لا يوجد حساب أساسي' : 'No Primary Account'),
                        subtitle: Text(loc.isArabic ? 'عرض مجموع جميع الأرصدة' : 'Show total of all balances'),
                        selected: isSelected,
                        onTap: () {
                          provider.setPrimaryAccount(null);
                          Navigator.pop(ctx);
                        },
                      );
                    } else {
                      final account = provider.accounts[index];
                      final isSelected = provider.primaryAccountId == account.id;
                      return ListTile(
                        leading: Icon(
                          isSelected ? Icons.star_rounded : Icons.star_border_rounded,
                          color: isSelected ? AppColors.primary : AppColors.textSecondary,
                        ),
                        title: Text(account.name),
                        subtitle: Text('${account.type.toUpperCase()} • ${account.currency} ${account.balance.toStringAsFixed(2)}'),
                        selected: isSelected,
                        onTap: () {
                          provider.setPrimaryAccount(account.id);
                          Navigator.pop(ctx);
                        },
                      );
                    }
                  },
                ),
              ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(loc.cancel),
          ),
        ],
      ),
    );
  }

  void _showAddAccountDialog(BuildContext context, AppProvider provider, AppLocalizations loc) {
    final nameController = TextEditingController();
    final balanceController = TextEditingController(text: '0');
    String type = 'cash';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(loc.addAccount, style: GoogleFonts.outfit(fontWeight: FontWeight.w700)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(hintText: loc.accountName),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: balanceController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(hintText: loc.initialBalance),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: type,
                decoration: const InputDecoration(),
                items: ['cash', 'bank', 'credit', 'savings'].map((t) =>
                    DropdownMenuItem(value: t, child: Text(t.toUpperCase()))).toList(),
                onChanged: (v) => setS(() => type = v!),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: Text(loc.cancel, style: const TextStyle(color: AppColors.textSecondary))),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.trim().isEmpty) return;
                await provider.addAccount(AccountModel(
                  name: nameController.text.trim(),
                  type: type,
                  balance: double.tryParse(balanceController.text) ?? 0,
                  currency: provider.currency,
                ));
                if (ctx.mounted) Navigator.pop(ctx);
              },
              child: Text(loc.save),
            ),
          ],
        ),
      ),
    );
  }
}

// ---- Preferences Card ----
class _PreferencesCard extends StatelessWidget {
  final AppProvider provider;
  final AppLocalizations loc;
  const _PreferencesCard({required this.provider, required this.loc});

  static const languages = [
    {'code': 'en', 'name': 'English', 'flag': '🇺🇸'},
    {'code': 'ar', 'name': 'العربية', 'flag': '🇪🇬'},
    {'code': 'es', 'name': 'Español', 'flag': '🇪🇸'},
    {'code': 'fr', 'name': 'Français', 'flag': '🇫🇷'},
    {'code': 'de', 'name': 'Deutsch', 'flag': '🇩🇪'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            leading: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                  color: Theme.of(context).dividerTheme.color?.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12)),
              child: Icon(Icons.language_rounded,
                  color: Theme.of(context).colorScheme.primary, size: 20),
            ),
            title: Text(loc.language,
                style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).textTheme.titleLarge?.color)),
            trailing: DropdownButton<String>(
              value: provider.locale.languageCode,
              underline: const SizedBox.shrink(),
              onChanged: (code) {
                if (code != null) provider.setLocale(Locale(code));
              },
              items: languages
                  .map((l) => DropdownMenuItem(
                        value: l['code'],
                        child: Text('${l['flag']} ${l['name']}',
                            style: GoogleFonts.outfit(fontSize: 13)),
                      ))
                  .toList(),
            ),
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            leading: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                  color: Theme.of(context).dividerTheme.color?.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12)),
              child: Icon(Icons.dark_mode_rounded,
                  color: Theme.of(context).colorScheme.primary, size: 20),
            ),
            title: Text(loc.darkMode,
                style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).textTheme.titleLarge?.color)),
            trailing: Switch(
              value: provider.isDarkMode,
              onChanged: (_) => provider.toggleTheme(),
              activeColor: Theme.of(context).colorScheme.primary,
            ),
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            leading: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                  color: Theme.of(context).dividerTheme.color?.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12)),
              child: Icon(Icons.lock_rounded,
                  color: Theme.of(context).colorScheme.primary, size: 20),
            ),
            title: Text(
                loc.appLock,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            subtitle: Text(
                loc.appLockSubtitle,
                style: const TextStyle(fontSize: 11)),
            trailing: Switch(
              value: provider.isSecurityEnabled,
              onChanged: (v) => provider.setSecurity(v),
              activeColor: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}

// ---- Currency Card ----
class _CurrencyCard extends StatelessWidget {
  final AppProvider provider;
  final AppLocalizations loc;
  const _CurrencyCard({required this.provider, required this.loc});

  static const currencies = ['EGP', 'USD', 'EUR', 'SAR', 'AED', 'GBP', 'KWD'];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          width: 42, height: 42,
          decoration: BoxDecoration(color: Theme.of(context).colorScheme.secondary.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
          child: Icon(Icons.monetization_on_rounded, color: Theme.of(context).colorScheme.primary, size: 20),
        ),
        title: Text(loc.currency, style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w600, color: Theme.of(context).textTheme.titleLarge?.color)),
        trailing: DropdownButton<String>(
          value: provider.currency,
          underline: const SizedBox.shrink(),
          style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.primary),
          items: currencies.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
          onChanged: (v) => provider.setCurrency(v!),
        ),
      ),
    );
  }
}

// ---- About Card ----
class _AboutCard extends StatelessWidget {
  final AppLocalizations loc;
  const _AboutCard({required this.loc});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [],
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            leading: Container(
              width: 42, height: 42,
              decoration: BoxDecoration(color: Theme.of(context).colorScheme.secondary.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
              child: Icon(Icons.info_outline_rounded, color: Theme.of(context).colorScheme.primary, size: 20),
            ),
            title: Text(loc.about, style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w600, color: Theme.of(context).textTheme.titleLarge?.color)),
            subtitle: Text(loc.version, style: GoogleFonts.outfit(fontSize: 12, color: AppColors.textSecondary)),
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            leading: Container(
              width: 42, height: 42,
              decoration: BoxDecoration(color: AppColors.secondary, borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.palette_rounded, color: AppColors.primary, size: 20),
            ),
            title: Text('Deep Forest Theme', style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            subtitle: Text('#102C26 × #F7E7CE', style: GoogleFonts.outfit(fontSize: 12, color: AppColors.textSecondary)),
          ),
        ],
      ),
    );
  }
}

class _DataCard extends StatelessWidget {
  final AppProvider provider;
  final AppLocalizations loc;
  const _DataCard({required this.provider, required this.loc});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          width: 42, height: 42,
          decoration: BoxDecoration(color: AppColors.secondary, borderRadius: BorderRadius.circular(12)),
          child: const Icon(Icons.file_download_rounded, color: AppColors.primary, size: 20),
        ),
        title: Text(loc.exportCsv, style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        subtitle: Text(loc.exportCsvSubtitle, style: const TextStyle(fontSize: 11)),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: () async {
          await provider.exportToCSV();
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(loc.exportSuccess)),
            );
          }
        },
      ),
    );
  }
}
