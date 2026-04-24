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
          _SectionHeader(title: "البيانات"),
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
          ...provider.accounts.asMap().entries.map((entry) {
            final i = entry.key;
            final acc = entry.value;
            return Column(
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  leading: Container(
                    width: 42, height: 42,
                    decoration: BoxDecoration(color: Theme.of(context).dividerTheme.color?.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.account_balance_wallet_rounded, color: AppColors.primary, size: 20),
                  ),
                  title: Text(acc.name, style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w600, color: Theme.of(context).textTheme.titleLarge?.color)),
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
              decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.add_rounded, color: AppColors.primary, size: 20),
            ),
            title: Text(loc.addAccount, style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.primary)),
            onTap: () => _showAddAccountDialog(context, provider, loc),
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
              child: const Icon(Icons.language_rounded,
                  color: AppColors.primary, size: 20),
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
              child: const Icon(Icons.dark_mode_rounded,
                  color: AppColors.primary, size: 20),
            ),
            title: Text(provider.isArabic ? "الوضع الليلي" : "Dark Mode",
                style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).textTheme.titleLarge?.color)),
            trailing: Switch(
              value: provider.isDarkMode,
              onChanged: (_) => provider.toggleTheme(),
              activeColor: AppColors.primary,
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
              child: const Icon(Icons.lock_rounded,
                  color: AppColors.primary, size: 20),
            ),
            title: Text(
                provider.isArabic ? "قفل التطبيق" : "App Lock",
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            subtitle: Text(
                provider.isArabic 
                  ? "استخدم الرقم السري لفتح التطبيق" 
                  : "Use PIN to unlock the app",
                style: const TextStyle(fontSize: 11)),
            trailing: Switch(
              value: provider.isSecurityEnabled,
              onChanged: (v) {
                if (v && !provider.hasPin) {
                  // Force set PIN if enabling security for first time
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const PinLockScreen(isSettingPin: true),
                    ),
                  );
                }
                provider.setSecurity(v);
              },
              activeColor: AppColors.primary,
            ),
          ),
          if (provider.isSecurityEnabled) ...[
            const Divider(height: 1, indent: 16, endIndent: 16),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              title: Text(
                provider.isArabic ? "نوع الحماية" : "Security Type",
                style: GoogleFonts.outfit(
                    fontSize: 13,
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500),
              ),
              trailing: DropdownButton<String>(
                value: provider.securityType,
                underline: const SizedBox.shrink(),
                style: GoogleFonts.outfit(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary),
                onChanged: (type) {
                  if (type != null) provider.setSecurityType(type);
                },
                items: [
                  DropdownMenuItem(
                    value: 'pin',
                    child: Text(provider.isArabic ? "رقم سري" : "PIN"),
                  ),
                  DropdownMenuItem(
                    value: 'password',
                    child: Text(provider.isArabic ? "كلمة مرور" : "Password"),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, indent: 16, endIndent: 16),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              title: Text(
                provider.securityType == 'pin'
                    ? (provider.isArabic ? "تغيير الرقم السري" : "Change PIN")
                    : (provider.isArabic ? "تغيير كلمة المرور" : "Change Password"),
                style: GoogleFonts.outfit(
                    fontSize: 13,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500),
              ),
              trailing: const Icon(Icons.chevron_right_rounded,
                  size: 18, color: AppColors.primary),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const PinLockScreen(isSettingPin: true),
                ),
              ),
            ),
          ],
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          width: 42, height: 42,
          decoration: BoxDecoration(color: AppColors.secondary, borderRadius: BorderRadius.circular(12)),
          child: const Icon(Icons.monetization_on_rounded, color: AppColors.primary, size: 20),
        ),
        title: Text(loc.currency, style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        trailing: DropdownButton<String>(
          value: provider.currency,
          underline: const SizedBox.shrink(),
          style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primary),
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            leading: Container(
              width: 42, height: 42,
              decoration: BoxDecoration(color: AppColors.secondary, borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.info_outline_rounded, color: AppColors.primary, size: 20),
            ),
            title: Text(loc.about, style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          width: 42, height: 42,
          decoration: BoxDecoration(color: AppColors.secondary, borderRadius: BorderRadius.circular(12)),
          child: const Icon(Icons.file_download_rounded, color: AppColors.primary, size: 20),
        ),
        title: Text(loc.exportCsv, style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        subtitle: const Text("حفظ نسخة من المعاملات بصيغة CSV", style: TextStyle(fontSize: 11)),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: () async {
          await provider.exportToCSV();
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("تم تصدير الملف بنجاح")),
            );
          }
        },
      ),
    );
  }
}
