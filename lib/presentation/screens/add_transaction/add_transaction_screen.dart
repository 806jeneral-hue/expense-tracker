import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/app_provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../data/models/transaction_model.dart';
import '../../../data/models/category_model.dart';
import '../../../data/models/account_model.dart';

class AddTransactionScreen extends StatefulWidget {
  final TransactionModel? existingTransaction;
  final AccountModel? initialAccount;
  final String? initialType;

  const AddTransactionScreen({
    super.key,
    this.existingTransaction,
    this.initialAccount,
    this.initialType,
  });

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String _type = 'expense';
  CategoryModel? _selectedCategory;
  CategoryModel? _selectedSubCategory;
  AccountModel? _selectedAccount;
  DateTime _selectedDate = DateTime.now();

  bool get isEditing => widget.existingTransaction != null;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    if (isEditing) {
      final tx = widget.existingTransaction!;
      _type = tx.type;
      _amountController.text = tx.amount.toString();
      _noteController.text = tx.note ?? '';
      _selectedDate = tx.date;
      _tabController.index = tx.type == 'expense' ? 0 : 1;
    } else {
      // Set initial values if provided
      if (widget.initialType != null) {
        _type = widget.initialType!;
        _tabController.index = _type == 'expense' ? 0 : 1;
      }
      if (widget.initialAccount != null) {
        _selectedAccount = widget.initialAccount;
      }
    }

    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          _type = _tabController.index == 0 ? 'expense' : 'income';
          _selectedCategory = null;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (isEditing) {
      final provider = context.read<AppProvider>();
      final tx = widget.existingTransaction!;

      try {
        _selectedCategory = provider.categories.firstWhere(
          (c) => c.id == tx.categoryId,
        );
      } catch (_) {}

      try {
        _selectedAccount = provider.accounts.firstWhere(
          (a) => a.id == tx.accountId,
        );
      } catch (_) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final loc = AppLocalizations.of(context);

    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          // ---- Handle Bar ----
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.divider,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // ---- Header ----
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isEditing ? loc.editTransaction : loc.addTransaction,
                  style: GoogleFonts.outfit(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).textTheme.titleLarge?.color,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).dividerTheme.color?.withOpacity(0.1) ?? AppColors.divider.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.close_rounded, size: 18),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ---- Type Tabs ----
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(15),
                boxShadow: const [],
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: _type == 'expense'
                      ? AppColors.expense
                      : AppColors.income,
                  borderRadius: BorderRadius.circular(12),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                labelStyle: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                labelColor: Colors.white,
                unselectedLabelColor: AppColors.textSecondary,
                tabs: [
                  Tab(text: loc.expense),
                  Tab(text: loc.income),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // ---- Form ----
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Amount field
                    TextFormField(
                      controller: _amountController,
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^\d+\.?\d{0,2}')),
                      ],
                      style: GoogleFonts.outfit(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).textTheme.titleLarge?.color,
                      ),
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        hintText: '0.00',
                        hintStyle: GoogleFonts.outfit(
                          color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.5),
                        ),
                        prefixText: '${provider.currency}  ',
                        prefixStyle: GoogleFonts.outfit(
                          color: Theme.of(context).textTheme.bodyMedium?.color,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty)
                          return loc.amountRequired;
                        if (double.tryParse(v) == null || double.parse(v) <= 0)
                          return loc.amountRequired;
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // Category
                    _buildSectionLabel(
                      loc.category,
                      trailing: GestureDetector(
                        onTap: () => _showAddCategoryDialog(provider, loc),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.add_circle_outline_rounded,
                                size: 16, color: AppColors.primary),
                            const SizedBox(width: 4),
                            Text(
                              provider.isArabic ? "جديد" : "New",
                              style: GoogleFonts.outfit(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildCategoryGrid(provider, loc),

                    // Sub-Category
                    if (_selectedCategory != null) ...[
                      const SizedBox(height: 12),
                      _buildSectionLabel(
                        provider.isArabic ? "التصنيف الفرعي" : "Sub-Category",
                        trailing: GestureDetector(
                          onTap: () => _showAddCategoryDialog(provider, loc,
                              isSub: true),
                          child: const Icon(Icons.add_circle_outline_rounded,
                              size: 16, color: AppColors.primary),
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildSubCategoryGrid(provider, loc),
                    ],

                    const SizedBox(height: 16),

                    // Account
                    _buildSectionLabel(loc.account),
                    const SizedBox(height: 8),
                    _buildAccountsRow(provider, loc),

                    const SizedBox(height: 16),

                    // Date
                    _buildSectionLabel(loc.date),
                    const SizedBox(height: 8),
                    _buildDatePicker(context, loc),

                    const SizedBox(height: 16),

                    // Note
                    TextFormField(
                      controller: _noteController,
                      decoration: InputDecoration(
                        hintText: loc.note,
                        prefixIcon: Icon(
                          Icons.edit_note_rounded,
                          color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6),
                        ),
                      ),
                      maxLines: 2,
                    ),

                    const SizedBox(height: 24),

                    // Save button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _save(context, provider, loc),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _type == 'expense'
                              ? AppColors.expense
                              : AppColors.income,
                          padding:
                              const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Text(loc.save),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String label, {Widget? trailing}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).textTheme.bodyMedium?.color,
            letterSpacing: 0.5,
          ),
        ),
        if (trailing != null) trailing,
      ],
    );
  }

  Widget _buildCategoryGrid(AppProvider provider, AppLocalizations loc) {
    final cats = _type == 'expense'
        ? provider.expenseCategories
        : provider.incomeCategories;

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: cats.map((cat) {
        final isSelected = _selectedCategory?.id == cat.id;
        final name = provider.isArabic ? cat.nameAr : cat.name;
        return GestureDetector(
          onTap: () => setState(() => _selectedCategory = cat),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.divider,
              ),
              boxShadow: const [],
            ),
            child: Text(
              name,
              style: GoogleFonts.outfit(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : AppColors.textSecondary,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSubCategoryGrid(AppProvider provider, AppLocalizations loc) {
    final subs = provider.getSubCategories(_selectedCategory!.id!);
    if (subs.isEmpty) {
      return Text(
        provider.isArabic ? "لا يوجد تصنيفات فرعية" : "No sub-categories",
        style: GoogleFonts.outfit(fontSize: 12, color: AppColors.textLight),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: subs.map((sub) {
        final isSelected = _selectedSubCategory?.id == sub.id;
        final name = provider.isArabic ? sub.nameAr : sub.name;
        return GestureDetector(
          onTap: () => setState(() => _selectedSubCategory = sub),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary.withOpacity(0.8) : Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.divider,
              ),
            ),
            child: Text(
              name,
              style: GoogleFonts.outfit(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : AppColors.textSecondary,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAccountsRow(AppProvider provider, AppLocalizations loc) {
    if (provider.accounts.isEmpty) {
      return Text(
        loc.accountRequired,
        style: const TextStyle(color: AppColors.textLight),
      );
    }

    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: provider.accounts.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final acc = provider.accounts[index];
          final isSelected = _selectedAccount?.id == acc.id;
          return GestureDetector(
            onTap: () => setState(() => _selectedAccount = acc),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color:
                      isSelected ? AppColors.primary : AppColors.divider,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.account_balance_wallet_rounded,
                    size: 16,
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    acc.name,
                    style: GoogleFonts.outfit(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: isSelected
                          ? Colors.white
                          : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDatePicker(BuildContext context, AppLocalizations loc) {
    return GestureDetector(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: _selectedDate,
          firstDate: DateTime(2020),
          lastDate: DateTime.now(),
          builder: (ctx, child) => Theme(
            data: Theme.of(ctx).copyWith(
              colorScheme: const ColorScheme.light(
                primary: AppColors.primary,
              ),
            ),
            child: child!,
          ),
        );
        if (picked != null) setState(() => _selectedDate = picked);
      },
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Theme.of(context).brightness == Brightness.dark ? AppColors.darkBorder : AppColors.divider),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today_rounded,
                color: AppColors.primary, size: 18),
            const SizedBox(width: 10),
            Text(
              '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
              style: GoogleFonts.outfit(
                fontSize: 14,
                color: Theme.of(context).textTheme.titleLarge?.color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _save(
      BuildContext context, AppProvider provider, AppLocalizations loc) async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(loc.categoryRequired),
          backgroundColor: AppColors.expense,
        ),
      );
      return;
    }
    if (_selectedAccount == null && provider.accounts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(loc.accountRequired),
          backgroundColor: AppColors.expense,
        ),
      );
      return;
    }

    final account = _selectedAccount ?? provider.accounts.first;
    final amount = double.parse(_amountController.text);
    final categoryId = (_selectedSubCategory ?? _selectedCategory)!.id!;

    final newTx = TransactionModel(
      id: isEditing ? widget.existingTransaction!.id : null,
      accountId: account.id!,
      categoryId: categoryId,
      amount: amount,
      type: _type,
      note: _noteController.text.trim().isEmpty
          ? null
          : _noteController.text.trim(),
      date: _selectedDate,
    );

    if (isEditing) {
      await provider.updateTransaction(widget.existingTransaction!, newTx);
    } else {
      await provider.addTransaction(newTx);
    }

    if (context.mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(loc.transactionSaved),
          backgroundColor: AppColors.income,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _showAddCategoryDialog(AppProvider provider, AppLocalizations loc,
      {bool isSub = false}) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          isSub
              ? (provider.isArabic ? "إضافة تصنيف فرعي" : "Add Sub-Category")
              : (provider.isArabic ? "إضافة تصنيف جديد" : "Add New Category"),
          style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(
            hintText: provider.isArabic ? "اسم التصنيف" : "Category Name",
            hintStyle: GoogleFonts.outfit(fontSize: 14),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(provider.isArabic ? "إلغاء" : "Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              if (controller.text.trim().isEmpty) return;
              final newCat = CategoryModel(
                name: controller.text.trim(),
                nameAr: controller.text.trim(),
                icon: isSub ? 'subdirectory_arrow_right' : 'category',
                type: _type,
                parentId: isSub ? _selectedCategory?.id : null,
              );
              await provider.addCategory(newCat);
              if (mounted) {
                if (isSub) {
                  setState(() => _selectedSubCategory = provider.categories.last);
                } else {
                  setState(() {
                    _selectedCategory = provider.categories.last;
                    _selectedSubCategory = null;
                  });
                }
                Navigator.pop(ctx);
              }
            },
            child: Text(provider.isArabic ? "إضافة" : "Add"),
          ),
        ],
      ),
    );
  }
}
