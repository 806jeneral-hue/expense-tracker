import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import 'dashboard/dashboard_screen.dart';
import 'accounts/accounts_screen.dart';
import 'reports/reports_screen.dart';
import 'settings/settings_screen.dart';
import 'add_transaction/add_transaction_screen.dart';
import '../../core/constants/app_colors.dart';
import '../../core/l10n/app_localizations.dart';


class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool _isAuthenticated = true;

  @override
  void initState() {
    super.initState();
  }

  final List<Widget> _screens = const [
    DashboardScreen(),
    AccountsScreen(),
    ReportsScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final loc = AppLocalizations.of(context);

    if (!_isAuthenticated) {
      return const Scaffold(
        backgroundColor: AppColors.primary,
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    return Scaffold(
      body: IndexedStack(
        index: provider.navigationIndex,
        children: _screens,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openAddTransaction(context),
        backgroundColor: Theme.of(context).floatingActionButtonTheme.backgroundColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        child: Icon(Icons.add, color: Theme.of(context).floatingActionButtonTheme.foregroundColor, size: 28),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
          boxShadow: const [],
        ),
        child: SafeArea(
          child: SizedBox(
            height: 64,
            child: BottomAppBar(
              color: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
              elevation: 0,
              notchMargin: 8,
              shape: const CircularNotchedRectangle(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _NavItem(
                    icon: Icons.home_rounded,
                    label: loc.navDashboard,
                    isSelected: provider.navigationIndex == 0,
                    onTap: () => provider.setNavigationIndex(0),
                  ),
                  _NavItem(
                    icon: Icons.account_balance_wallet_rounded,
                    label: loc.accounts,
                    isSelected: provider.navigationIndex == 1,
                    onTap: () => provider.setNavigationIndex(1),
                  ),
                  const SizedBox(width: 56),
                  _NavItem(
                    icon: Icons.bar_chart_rounded,
                    label: loc.navReports,
                    isSelected: provider.navigationIndex == 2,
                    onTap: () => provider.setNavigationIndex(2),
                  ),
                  _NavItem(
                    icon: Icons.settings_rounded,
                    label: loc.navSettings,
                    isSelected: provider.navigationIndex == 3,
                    onTap: () => provider.setNavigationIndex(3),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _openAddTransaction(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AddTransactionScreen(),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).bottomNavigationBarTheme.selectedItemColor?.withOpacity(0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color:
                  isSelected ? Theme.of(context).bottomNavigationBarTheme.selectedItemColor : Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
              size: 22,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight:
                    isSelected ? FontWeight.w600 : FontWeight.w400,
                color:
                    isSelected ? Theme.of(context).bottomNavigationBarTheme.selectedItemColor : Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
