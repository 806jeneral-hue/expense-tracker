import 'dart:io';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import '../../data/database/database_helper.dart';
import '../../data/models/account_model.dart';
import '../../data/models/category_model.dart';
import '../../data/models/transaction_model.dart';

class AppProvider extends ChangeNotifier {
  final DatabaseHelper _db = DatabaseHelper.instance;
  late SharedPreferences _prefs;

  // ---- Locale ----
  Locale _locale = const Locale('en');
  Locale get locale => _locale;

  // ---- Security ----
  bool _isSecurityEnabled = false;
  bool get isSecurityEnabled => _isSecurityEnabled;
  String? _appPin;
  String? get appPin => _appPin;

  bool get hasPin => _appPin != null && _appPin!.isNotEmpty;

  void setSecurity(bool value) {
    _isSecurityEnabled = value;
    _prefs.setBool('security', value);
    notifyListeners();
  }

  Future<void> setPin(String pin) async {
    _appPin = pin;
    await _prefs.setString('app_pin', pin);
    notifyListeners();
  }

  bool verifyPin(String input) {
    return _appPin == input;
  }

  // ---- Accounts ----
  List<AccountModel> _accounts = [];
  List<AccountModel> get accounts => _accounts;

  // ---- Categories ----
  List<CategoryModel> _categories = [];
  List<CategoryModel> get categories => _categories;
  List<CategoryModel> get expenseCategories =>
      _categories.where((c) => c.type == 'expense' && c.parentId == null).toList();
  List<CategoryModel> get incomeCategories =>
      _categories.where((c) => c.type == 'income' && c.parentId == null).toList();

  List<CategoryModel> getSubCategories(int parentId) {
    return _categories.where((c) => c.parentId == parentId).toList();
  }

  // ---- Transactions ----
  List<TransactionModel> _transactions = [];
  List<TransactionModel> get transactions => _transactions;

  // ---- Selected Month ----
  DateTime _selectedMonth = DateTime.now();
  DateTime get selectedMonth => _selectedMonth;

  // ---- Summary ----
  double _totalIncome = 0;
  double _totalExpense = 0;
  double get totalIncome => _totalIncome;
  double get totalExpense => _totalExpense;
  double get totalBalance => _totalIncome - _totalExpense;
  double get netBalance =>
      _accounts.fold(0, (sum, a) => sum + a.balance);

  // ---- Filter ----
  String _transactionFilter = 'all'; // all | income | expense
  String get transactionFilter => _transactionFilter;
  String _searchQuery = '';

  // ---- Category Breakdown ----
  List<Map<String, dynamic>> _categoryBreakdown = [];
  List<Map<String, dynamic>> get categoryBreakdown => _categoryBreakdown;

  // ---- Monthly Chart ----
  List<Map<String, dynamic>> _monthlyData = [];
  List<Map<String, dynamic>> get monthlyData => _monthlyData;

  // ---- Loading ----
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // ---- Currency ----
  String _currency = 'EGP';
  String get currency => _currency;

  // ==================== INIT ====================

  Future<void> init() async {
    _isLoading = true;
    notifyListeners();

    _prefs = await SharedPreferences.getInstance();
    
    // Load Saved Settings
    _currency = _prefs.getString('currency') ?? 'EGP';
    _isSecurityEnabled = _prefs.getBool('security') ?? false;
    _appPin = _prefs.getString('app_pin');
    final lang = _prefs.getString('language') ?? 'en';
    _locale = Locale(lang);

    await loadAccounts();
    await loadCategories();
    await loadTransactions();
    await loadSummary();
    await loadCategoryBreakdown();
    await loadMonthlyData();

    _isLoading = false;
    notifyListeners();
  }

  // ==================== LANGUAGE ====================

  void setLocale(Locale locale) {
    _locale = locale;
    _prefs.setString('language', locale.languageCode);
    notifyListeners();
  }

  void toggleLanguage() {
    _locale = _locale.languageCode == 'en'
        ? const Locale('ar')
        : const Locale('en');
    _prefs.setString('language', _locale.languageCode);
    notifyListeners();
  }

  bool get isArabic => _locale.languageCode == 'ar';

  // ==================== ACCOUNTS ====================

  Future<void> loadAccounts() async {
    _accounts = await _db.getAccounts();
    notifyListeners();
  }

  Future<void> addAccount(AccountModel account) async {
    await _db.insertAccount(account);
    await loadAccounts();
  }

  Future<void> updateAccount(AccountModel account) async {
    await _db.updateAccount(account);
    await loadAccounts();
  }

  Future<void> deleteAccount(int id) async {
    await _db.deleteAccount(id);
    await loadAccounts();
    await loadTransactions();
    await loadSummary();
  }

  // ==================== CATEGORIES ====================

  Future<void> loadCategories() async {
    _categories = await _db.getCategories();
    notifyListeners();
  }

  Future<void> addCategory(CategoryModel category) async {
    await _db.insertCategory(category);
    await loadCategories();
  }

  Future<void> deleteCategory(int id) async {
    await _db.deleteCategory(id);
    await loadCategories();
  }

  // ==================== TRANSACTIONS ====================

  Future<void> loadTransactions() async {
    final type =
        _transactionFilter == 'all' ? null : _transactionFilter;

    _transactions = await _db.getTransactions(
      type: type,
      searchQuery: _searchQuery.isEmpty ? null : _searchQuery,
    );
    notifyListeners();
  }

  Future<void> addTransaction(TransactionModel transaction) async {
    await _db.insertTransaction(transaction);
    await loadAccounts();
    await loadTransactions();
    await loadSummary();
    await loadCategoryBreakdown();
    await loadMonthlyData();
  }

  Future<void> updateTransaction(
      TransactionModel oldTx, TransactionModel newTx) async {
    await _db.updateTransaction(oldTx, newTx);
    await loadAccounts();
    await loadTransactions();
    await loadSummary();
    await loadCategoryBreakdown();
  }

  Future<void> deleteTransaction(TransactionModel transaction) async {
    await _db.deleteTransaction(transaction);
    await loadAccounts();
    await loadTransactions();
    await loadSummary();
    await loadCategoryBreakdown();
    await loadMonthlyData();
  }

  void setFilter(String filter) {
    _transactionFilter = filter;
    loadTransactions();
  }

  void setSearch(String query) {
    _searchQuery = query;
    loadTransactions();
  }

  List<TransactionModel> getRecentTransactions({int limit = 5}) {
    return _transactions.take(limit).toList();
  }

  // ==================== SUMMARY ====================

  Future<void> loadSummary() async {
    final summary = await _db.getMonthlySummary(_selectedMonth);
    _totalIncome = summary['income'] ?? 0;
    _totalExpense = summary['expense'] ?? 0;
    notifyListeners();
  }

  void setSelectedMonth(DateTime month) {
    _selectedMonth = month;
    loadSummary();
    loadCategoryBreakdown();
  }

  // ==================== ANALYTICS ====================

  Future<void> loadCategoryBreakdown() async {
    _categoryBreakdown =
        await _db.getCategoryBreakdown(_selectedMonth, 'expense');
    notifyListeners();
  }

  Future<void> loadMonthlyData() async {
    _monthlyData = await _db.getLast6MonthsData();
    notifyListeners();
  }

  // ==================== CURRENCY ====================

  void setCurrency(String currency) {
    _currency = currency;
    _prefs.setString('currency', currency);
    notifyListeners();
  }

  // ==================== EXPORT CSV ====================

  Future<void> exportToCSV() async {
    try {
      List<List<dynamic>> rows = [];
      
      // Header
      rows.add(["Date", "Type", "Category", "Amount", "Account", "Note"]);

      // Data
      for (var tx in _transactions) {
        rows.add([
          tx.date.toString(),
          tx.type,
          tx.categoryName ?? "",
          tx.amount,
          tx.accountName ?? "",
          tx.note ?? ""
        ]);
      }

      String csvData = const ListToCsvConverter().convert(rows);
      final directory = await getApplicationDocumentsDirectory();
      final path = "${directory.path}/expenses_${DateTime.now().millisecondsSinceEpoch}.csv";
      final file = File(path);
      await file.writeAsString(csvData);

      await Share.shareXFiles([XFile(path)], text: 'My Expense Report');
    } catch (e) {
      debugPrint("Export Error: $e");
    }
  }
}
