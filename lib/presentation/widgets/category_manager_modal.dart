import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/l10n/app_localizations.dart';
import '../../data/models/category_model.dart';
import '../providers/app_provider.dart';
import '../screens/categories/category_details_screen.dart';

class CategoryManagerModal extends StatefulWidget {
  const CategoryManagerModal({super.key});

  @override
  State<CategoryManagerModal> createState() => _CategoryManagerModalState();
}

class _CategoryManagerModalState extends State<CategoryManagerModal> {
  String _selectedType = 'expense';

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final loc = AppLocalizations.of(context);
    final categories = _selectedType == 'expense' 
        ? provider.expenseCategories 
        : provider.incomeCategories;

    return Material(
      color: Colors.transparent,
      child: Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        border: Theme.of(context).brightness == Brightness.dark
            ? Border.all(color: AppColors.darkBorder, width: 1)
            : null,
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  loc.categories,
                  style: GoogleFonts.outfit(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.titleLarge?.color,
                  ),
                ),
                IconButton(
                  onPressed: () => _showAddCategoryDialog(context, provider, loc),
                  icon: const Icon(Icons.add_circle_rounded, color: AppColors.primary, size: 30),
                ),
              ],
            ),
          ),

          // Type Toggle
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            child: Row(
              children: [
                _buildTypeButton(loc.expense, 'expense'),
                const SizedBox(width: 12),
                _buildTypeButton(loc.income, 'income'),
              ],
            ),
          ),

          // Categories List
          Expanded(
            child: categories.isEmpty
                ? Center(
                    child: Text(
                      loc.noTransactions, // Use appropriate empty text
                      style: GoogleFonts.outfit(color: Theme.of(context).textTheme.bodyMedium?.color),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(24),
                    itemCount: categories.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final cat = categories[index];
                      return _buildCategoryItem(context, cat, provider, loc);
                    },
                  ),
          ),
        ],
      ),
    ),
  );
}

  Widget _buildTypeButton(String label, String type) {
    final isSelected = _selectedType == type;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedType = type),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.darkBorder,
              width: 1,
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              color: isSelected ? Colors.white : Theme.of(context).textTheme.bodyMedium?.color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryItem(BuildContext context, CategoryModel cat, AppProvider provider, AppLocalizations loc) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    Color color = Color(int.parse(cat.color.replaceFirst('#', '0xFF')));
    if (isDark) {
      // Lighten dark colors in dark mode for visibility
      color = Color.lerp(color, Colors.white, 0.4)!;
    }

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CategoryDetailsScreen(category: cat),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: isDark ? Border.all(color: AppColors.darkBorder) : null,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.category_rounded, color: color, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                provider.isArabic ? cat.nameAr : cat.name,
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).textTheme.titleLarge?.color,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit_rounded, size: 20, color: Colors.blue),
              onPressed: () => _showAddCategoryDialog(context, provider, loc, existing: cat),
            ),
            IconButton(
              icon: const Icon(Icons.delete_rounded, size: 20, color: Colors.red),
              onPressed: () => _confirmDelete(context, provider, cat, loc),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddCategoryDialog(BuildContext context, AppProvider provider, AppLocalizations loc, {CategoryModel? existing}) {
    final nameController = TextEditingController(text: existing != null ? (provider.isArabic ? existing.nameAr : existing.name) : '');
    String dialogType = existing?.type ?? _selectedType;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(existing == null ? loc.addTransaction : loc.editTransaction),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: provider.isArabic ? "اسم الفئة" : "Category Name",
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  _buildDialogTypeOption(setDialogState, loc.expense, 'expense', dialogType, (val) => dialogType = val),
                  const SizedBox(width: 8),
                  _buildDialogTypeOption(setDialogState, loc.income, 'income', dialogType, (val) => dialogType = val),
                  const SizedBox(width: 8),
                  _buildDialogTypeOption(setDialogState, provider.isArabic ? "كلاهما" : "Both", 'both', dialogType, (val) => dialogType = val),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: Text(loc.cancel)),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isEmpty) return;
                if (existing != null) {
                  provider.updateCategory(CategoryModel(
                    id: existing.id,
                    name: nameController.text,
                    nameAr: nameController.text,
                    icon: existing.icon,
                    type: dialogType,
                    color: existing.color,
                  ));
                } else {
                  provider.addCategory(CategoryModel(
                    name: nameController.text,
                    nameAr: nameController.text,
                    icon: 'category',
                    type: dialogType,
                    color: '#1F5A4A',
                  ));
                }
                Navigator.pop(ctx);
              },
              child: Text(loc.save),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDialogTypeOption(StateSetter setState, String label, String type, String selectedType, Function(String) onSelect) {
    final isSelected = selectedType == type;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => onSelect(type)),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: isSelected ? AppColors.primary : AppColors.divider),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              fontSize: 10,
              color: isSelected ? Colors.white : AppColors.textSecondary,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }



  void _confirmDelete(BuildContext context, AppProvider provider, CategoryModel cat, AppLocalizations loc) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(provider.isArabic ? "حذف الفئة؟" : "Delete Category?"),
        content: Text(provider.isArabic ? "هل أنت متأكد من حذف هذه الفئة؟" : "Are you sure you want to delete this category?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(loc.cancel)),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              provider.deleteCategory(cat);
              Navigator.pop(ctx);
            },
            child: Text(provider.isArabic ? "حذف" : "Delete"),
          ),
        ],
      ),
    );
  }
}
