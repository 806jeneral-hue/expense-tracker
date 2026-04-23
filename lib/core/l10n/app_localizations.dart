import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ??
        AppLocalizations(const Locale('en'));
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  bool get isArabic => locale.languageCode == 'ar';

  String _t(String en, String ar) => isArabic ? ar : en;

  // ---- App ----
  String get appTitle => _t('Expense Tracker', 'متتبع المصروفات');

  // ---- Navigation ----
  String get navDashboard => _t('Dashboard', 'الرئيسية');
  String get navTransactions => _t('Transactions', 'المعاملات');
  String get navReports => _t('Reports', 'التقارير');
  String get navSettings => _t('Settings', 'الإعدادات');

  // ---- Dashboard ----
  String get totalBalance => _t('Total Balance', 'الرصيد الإجمالي');
  String get totalIncome => _t('Total Income', 'إجمالي الدخل');
  String get totalExpense => _t('Total Expense', 'إجمالي المصروفات');
  String get recentTransactions => _t('Recent Transactions', 'آخر المعاملات');
  String get seeAll => _t('See All', 'عرض الكل');
  String get thisMonth => _t('This Month', 'هذا الشهر');
  String get noTransactions => _t('No transactions yet', 'لا توجد معاملات بعد');
  String get addFirstTransaction =>
      _t('Add your first transaction', 'أضف أول معاملة لك');

  // ---- Transactions ----
  String get transactions => _t('Transactions', 'المعاملات');
  String get income => _t('Income', 'دخل');
  String get expense => _t('مصروف', 'مصروف');
  String get all => _t('All', 'الكل');
  String get search => _t('Search...', 'بحث...');
  String get deleteTransaction =>
      _t('Delete Transaction', 'حذف المعاملة');
  String get deleteConfirm =>
      _t('Are you sure you want to delete this transaction?',
          'هل أنت متأكد من حذف هذه المعاملة؟');
  String get cancel => _t('Cancel', 'إلغاء');
  String get delete => _t('Delete', 'حذف');

  // ---- Add Transaction ----
  String get addTransaction => _t('Add Transaction', 'إضافة معاملة');
  String get editTransaction => _t('Edit Transaction', 'تعديل المعاملة');
  String get amount => _t('Amount', 'المبلغ');
  String get amountHint => _t('0.00', '0.00');
  String get note => _t('Note (optional)', 'ملاحظة (اختياري)');
  String get category => _t('Category', 'الفئة');
  String get account => _t('Account', 'الحساب');
  String get date => _t('Date', 'التاريخ');
  String get save => _t('Save', 'حفظ');
  String get selectCategory => _t('Select Category', 'اختر الفئة');
  String get selectAccount => _t('Select Account', 'اختر الحساب');
  String get amountRequired => _t('Amount is required', 'المبلغ مطلوب');
  String get categoryRequired => _t('Category is required', 'الفئة مطلوبة');
  String get accountRequired => _t('Account is required', 'الحساب مطلوب');
  String get transactionSaved =>
      _t('Transaction saved!', 'تم حفظ المعاملة!');

  // ---- Reports ----
  String get reports => _t('Reports', 'التقارير');
  String get expenseByCategory =>
      _t('Expense by Category', 'المصروفات حسب الفئة');
  String get monthlyOverview => _t('Monthly Overview', 'نظرة شهرية');
  String get noData => _t('No data available', 'لا توجد بيانات');

  // ---- Settings ----
  String get settings => _t('Settings', 'الإعدادات');
  String get language => _t('Language', 'اللغة');
  String get english => _t('English', 'الإنجليزية');
  String get arabic => _t('Arabic', 'العربية');
  String get accounts => _t('Accounts', 'الحسابات');
  String get categories => _t('Categories', 'الفئات');
  String get exportCsv => _t('Export CSV', 'تصدير CSV');
  String get about => _t('About', 'عن التطبيق');
  String get version => _t('Version 1.0.0', 'الإصدار 1.0.0');
  String get currency => _t('Currency', 'العملة');

  // ---- Accounts ----
  String get addAccount => _t('Add Account', 'إضافة حساب');
  String get accountName => _t('Account Name', 'اسم الحساب');
  String get accountType => _t('Account Type', 'نوع الحساب');
  String get initialBalance => _t('Initial Balance', 'الرصيد الابتدائي');
  String get cash => _t('Cash', 'نقدي');
  String get bank => _t('Bank', 'بنك');
  String get credit => _t('Credit', 'بطاقة ائتمان');
  String get savings => _t('Savings', 'مدخرات');

  // ---- Categories ----
  String get food => _t('Food & Dining', 'الطعام');
  String get transport => _t('Transport', 'المواصلات');
  String get shopping => _t('Shopping', 'التسوق');
  String get health => _t('Health', 'الصحة');
  String get entertainment => _t('Entertainment', 'الترفيه');
  String get education => _t('Education', 'التعليم');
  String get bills => _t('Bills', 'الفواتير');
  String get salary => _t('Salary', 'المرتب');
  String get freelance => _t('Freelance', 'عمل حر');
  String get investment => _t('Investment', 'استثمار');
  String get other => _t('Other', 'أخرى');
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'ar'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
