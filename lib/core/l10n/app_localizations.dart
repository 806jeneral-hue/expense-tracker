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

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'appTitle': 'Expense Tracker',
      'dashboard': 'Dashboard',
      'transactions': 'Transactions',
      'reports': 'Reports',
      'settings': 'Settings',
      'totalBalance': 'Total Balance',
      'income': 'Income',
      'expense': 'Expense',
      'totalIncome': 'Total Income',
      'totalExpense': 'Total Expense',
      'all': 'All',
      'save': 'Save',
      'cancel': 'Cancel',
      'delete': 'Delete',
      'deleteTransaction': 'Delete Transaction',
      'deleteConfirm': 'Are you sure you want to delete this transaction?',
      'category': 'Category',
      'account': 'Account',
      'date': 'Date',
      'addTransaction': 'Add Transaction',
      'editTransaction': 'Edit Transaction',
      'note': 'Note',
      'search': 'Search...',
      'language': 'Language',
      'currency': 'Currency',
      'amountRequired': 'Amount is required',
      'accountRequired': 'Account is required',
      'categoryRequired': 'Category is required',
      'transactionSaved': 'Transaction saved!',
      'about': 'About',
      'version': 'Version 1.0.0',
      'exportCsv': 'Export CSV',
      'accounts': 'Accounts',
      'addAccount': 'Add Account',
      'accountName': 'Account Name',
      'initialBalance': 'Initial Balance',
      'noTransactions': 'No transactions yet',
      'expenseByCategory': 'Expense by Category',
      'monthlyOverview': 'Monthly Overview',
      'noData': 'No data available',
      'recentTransactions': 'Recent Transactions',
      'addFirstTransaction': 'Add your first transaction',
      'seeAll': 'See All',
      'thisMonth': 'This Month',
      'amount': 'Amount',
      'amountHint': '0.00',
      'selectCategory': 'Select Category',
      'selectAccount': 'Select Account',
      'categories': 'Categories',
      'accountType': 'Account Type',
      'cash': 'Cash',
      'bank': 'Bank',
      'credit': 'Credit',
      'savings': 'Savings',
      'food': 'Food & Dining',
      'transport': 'Transport',
      'shopping': 'Shopping',
      'health': 'Health',
      'entertainment': 'Entertainment',
      'education': 'Education',
      'bills': 'Bills',
      'salary': 'Salary',
      'freelance': 'Freelance',
      'investment': 'Investment',
      'other': 'Other',
    },
    'ar': {
      'appTitle': 'متتبع المصروفات',
      'dashboard': 'الرئيسية',
      'transactions': 'المعاملات',
      'reports': 'التقارير',
      'settings': 'الإعدادات',
      'totalBalance': 'الرصيد الإجمالي',
      'income': 'دخل',
      'expense': 'مصروف',
      'totalIncome': 'إجمالي الدخل',
      'totalExpense': 'إجمالي المصروفات',
      'all': 'الكل',
      'save': 'حفظ',
      'cancel': 'إلغاء',
      'delete': 'حذف',
      'deleteTransaction': 'حذف المعاملة',
      'deleteConfirm': 'هل أنت متأكد من حذف هذه المعاملة؟',
      'category': 'التصنيف',
      'account': 'الحساب',
      'date': 'التاريخ',
      'addTransaction': 'إضافة معاملة',
      'editTransaction': 'تعديل المعاملة',
      'note': 'ملاحظة',
      'search': 'بحث...',
      'language': 'اللغة',
      'currency': 'العملة',
      'amountRequired': 'المبلغ مطلوب',
      'accountRequired': 'الحساب مطلوب',
      'categoryRequired': 'التصنيف مطلوب',
      'transactionSaved': 'تم حفظ المعاملة!',
      'about': 'عن التطبيق',
      'version': 'الإصدار 1.0.0',
      'exportCsv': 'تصدير CSV',
      'accounts': 'الحسابات',
      'addAccount': 'إضافة حساب',
      'accountName': 'اسم الحساب',
      'initialBalance': 'الرصيد الابتدائي',
      'noTransactions': 'لا توجد معاملات بعد',
      'expenseByCategory': 'المصروفات حسب الفئة',
      'monthlyOverview': 'نظرة شهرية',
      'noData': 'لا توجد بيانات',
      'recentTransactions': 'آخر المعاملات',
      'addFirstTransaction': 'أضف أول معاملة لك',
      'seeAll': 'عرض الكل',
      'thisMonth': 'هذا الشهر',
      'amount': 'المبلغ',
      'amountHint': '0.00',
      'selectCategory': 'اختر الفئة',
      'selectAccount': 'اختر الحساب',
      'categories': 'الفئات',
      'accountType': 'نوع الحساب',
      'cash': 'نقدي',
      'bank': 'بنك',
      'credit': 'بطاقة ائتمان',
      'savings': 'مدخرات',
      'food': 'الطعام',
      'transport': 'المواصلات',
      'shopping': 'التسوق',
      'health': 'الصحة',
      'entertainment': 'الترفيه',
      'education': 'التعليم',
      'bills': 'الفواتير',
      'salary': 'المرتب',
      'freelance': 'عمل حر',
      'investment': 'استثمار',
      'other': 'أخرى',
    },
    'es': {
      'appTitle': 'Gestor de Gastos',
      'dashboard': 'Panel',
      'transactions': 'Transacciones',
      'reports': 'Informes',
      'settings': 'Ajustes',
      'totalBalance': 'Saldo Total',
      'income': 'Ingresos',
      'expense': 'Gastos',
      'totalIncome': 'Ingresos Totales',
      'totalExpense': 'Gastos Totales',
      'all': 'Todo',
      'save': 'Guardar',
      'cancel': 'Cancelar',
      'delete': 'Eliminar',
      'deleteTransaction': 'Eliminar Transacción',
      'deleteConfirm': '¿Estás seguro?',
      'category': 'Categoría',
      'account': 'Cuenta',
      'date': 'Fecha',
      'addTransaction': 'Añadir Transacción',
      'editTransaction': 'Editar Transacción',
      'note': 'Nota',
      'search': 'Buscar...',
      'language': 'Idioma',
      'currency': 'Moneda',
      'amountRequired': 'El monto es obligatorio',
      'accountRequired': 'La cuenta es obligatoria',
      'categoryRequired': 'La categoría es obligatoria',
      'transactionSaved': '¡Transacción guardada!',
      'about': 'Acerca de',
      'version': 'Versión 1.0.0',
      'exportCsv': 'Exportar CSV',
      'accounts': 'Cuentas',
      'addAccount': 'Añadir Cuenta',
      'accountName': 'Nombre de la cuenta',
      'initialBalance': 'Saldo Inicial',
      'noTransactions': 'Aún no hay transacciones',
      'expenseByCategory': 'Gastos por categoría',
      'monthlyOverview': 'Resumen mensual',
      'noData': 'No hay datos disponibles',
      'recentTransactions': 'Transacciones recientes',
      'addFirstTransaction': 'Añade tu primera transacción',
      'seeAll': 'Ver todo',
      'thisMonth': 'Este mes',
      'amount': 'Monto',
      'amountHint': '0.00',
      'selectCategory': 'Seleccionar categoría',
      'selectAccount': 'Seleccionar cuenta',
      'categories': 'Categorías',
      'accountType': 'Tipo de cuenta',
      'cash': 'Efectivo',
      'bank': 'Banco',
      'credit': 'Crédito',
      'savings': 'Ahorros',
      'food': 'Comida',
      'transport': 'Transporte',
      'shopping': 'Compras',
      'health': 'Salud',
      'entertainment': 'Entretenimiento',
      'education': 'Educación',
      'bills': 'Facturas',
      'salary': 'Salario',
      'freelance': 'Freelance',
      'investment': 'Inversión',
      'other': 'Otro',
    },
    'fr': {
      'appTitle': 'Gestion des Dépenses',
      'dashboard': 'Tableau de bord',
      'transactions': 'Transactions',
      'reports': 'Rapports',
      'settings': 'Paramètres',
      'totalBalance': 'Solde Total',
      'income': 'Revenu',
      'expense': 'Dépense',
      'totalIncome': 'Revenu Total',
      'totalExpense': 'Dépense Totale',
      'all': 'Tout',
      'save': 'Enregistrer',
      'cancel': 'Annuler',
      'delete': 'Supprimer',
      'deleteTransaction': 'Supprimer la transaction',
      'deleteConfirm': 'Êtes-vous sûr ?',
      'category': 'Catégorie',
      'account': 'Compte',
      'date': 'Date',
      'addTransaction': 'Ajouter Transaction',
      'editTransaction': 'Modifier Transaction',
      'note': 'Note',
      'search': 'Chercher...',
      'language': 'Langue',
      'currency': 'Devise',
      'amountRequired': 'Le montant est requis',
      'accountRequired': 'Le compte est requis',
      'categoryRequired': 'La catégorie est requise',
      'transactionSaved': 'Transaction enregistrée !',
      'about': 'À propos',
      'version': 'Version 1.0.0',
      'exportCsv': 'Exporter CSV',
      'accounts': 'Comptes',
      'addAccount': 'Ajouter un compte',
      'accountName': 'Nom du compte',
      'initialBalance': 'Solde initial',
      'noTransactions': 'Pas encore de transactions',
      'expenseByCategory': 'Dépenses par catégorie',
      'monthlyOverview': 'Aperçu mensuel',
      'noData': 'Aucune donnée disponible',
      'recentTransactions': 'Transactions récentes',
      'addFirstTransaction': 'Ajoutez votre première transaction',
      'seeAll': 'Voir tout',
      'thisMonth': 'Ce mois-ci',
      'amount': 'Montant',
      'amountHint': '0.00',
      'selectCategory': 'Choisir une catégorie',
      'selectAccount': 'Choisir un compte',
      'categories': 'Catégories',
      'accountType': 'Type de compte',
      'cash': 'Espèces',
      'bank': 'Banque',
      'credit': 'Crédit',
      'savings': 'Épargne',
      'food': 'Nourriture',
      'transport': 'Transport',
      'shopping': 'Shopping',
      'health': 'Santé',
      'entertainment': 'Divertissement',
      'education': 'Éducation',
      'bills': 'Factures',
      'salary': 'Salaire',
      'freelance': 'Freelance',
      'investment': 'Investissement',
      'other': 'Autre',
    },
    'de': {
      'appTitle': 'Kostenverfolgung',
      'dashboard': 'Dashboard',
      'transactions': 'Transaktionen',
      'reports': 'Berichte',
      'settings': 'Einstellungen',
      'totalBalance': 'Gesamtguthaben',
      'income': 'Einnahmen',
      'expense': 'Ausgaben',
      'totalIncome': 'Gesamteinnahmen',
      'totalExpense': 'Gesamtausgaben',
      'all': 'Alle',
      'save': 'Speichern',
      'cancel': 'Abbrechen',
      'delete': 'Löschen',
      'deleteTransaction': 'Transaktion löschen',
      'deleteConfirm': 'Sind Sie sicher?',
      'category': 'Kategorie',
      'account': 'Konto',
      'date': 'Datum',
      'addTransaction': 'Transaktion hinzufügen',
      'editTransaction': 'Transaktion bearbeiten',
      'note': 'Notiz',
      'search': 'Suche...',
      'language': 'Sprache',
      'currency': 'Währung',
      'amountRequired': 'Betrag ist erforderlich',
      'accountRequired': 'Konto ist erforderlich',
      'categoryRequired': 'Kategorie ist erforderlich',
      'transactionSaved': 'Transaktion gespeichert!',
      'about': 'Über uns',
      'version': 'Version 1.0.0',
      'exportCsv': 'CSV Exportieren',
      'accounts': 'Konten',
      'addAccount': 'Konto hinzufügen',
      'accountName': 'Kontoname',
      'initialBalance': 'Anfangsguthaben',
      'noTransactions': 'Noch keine Transaktionen',
      'expenseByCategory': 'Ausgaben nach Kategorie',
      'monthlyOverview': 'Monatsübersicht',
      'noData': 'Keine Daten verfügbar',
      'recentTransactions': 'Letzte Transaktionen',
      'addFirstTransaction': 'Erste Transaktion hinzufügen',
      'seeAll': 'Alle ansehen',
      'thisMonth': 'Diesen Monat',
      'amount': 'Betrag',
      'amountHint': '0.00',
      'selectCategory': 'Kategorie wählen',
      'selectAccount': 'Konto wählen',
      'categories': 'Kategorien',
      'accountType': 'Kontotyp',
      'cash': 'Bargeld',
      'bank': 'Bank',
      'credit': 'Kredit',
      'savings': 'Sparen',
      'food': 'Essen',
      'transport': 'Transport',
      'shopping': 'Shopping',
      'health': 'Gesundheit',
      'entertainment': 'Unterhaltung',
      'education': 'Bildung',
      'bills': 'Rechnungen',
      'salary': 'Gehalt',
      'freelance': 'Freelance',
      'investment': 'Investition',
      'other': 'Andere',
    },
  };

  String _t(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? 
           _localizedValues['en']?[key] ?? key;
  }

  // Getters
  String get appTitle => _t('appTitle');
  String get dashboard => _t('dashboard');
  String get transactions => _t('transactions');
  String get reports => _t('reports');
  String get settings => _t('settings');
  String get totalBalance => _t('totalBalance');
  String get income => _t('income');
  String get expense => _t('expense');
  String get totalIncome => _t('totalIncome');
  String get totalExpense => _t('totalExpense');
  String get all => _t('all');
  String get save => _t('save');
  String get cancel => _t('cancel');
  String get delete => _t('delete');
  String get deleteTransaction => _t('deleteTransaction');
  String get deleteConfirm => _t('deleteConfirm');
  String get category => _t('category');
  String get account => _t('account');
  String get date => _t('date');
  String get addTransaction => _t('addTransaction');
  String get editTransaction => _t('editTransaction');
  String get note => _t('note');
  String get search => _t('search');
  String get language => _t('language');
  String get currency => _t('currency');
  String get amountRequired => _t('amountRequired');
  String get accountRequired => _t('accountRequired');
  String get categoryRequired => _t('categoryRequired');
  String get transactionSaved => _t('transactionSaved');
  String get about => _t('about');
  String get version => _t('version');
  String get exportCsv => _t('exportCsv');
  String get accounts => _t('accounts');
  String get addAccount => _t('addAccount');
  String get accountName => _t('accountName');
  String get initialBalance => _t('initialBalance');
  String get noTransactions => _t('noTransactions');
  String get expenseByCategory => _t('expenseByCategory');
  String get monthlyOverview => _t('monthlyOverview');
  String get noData => _t('noData');
  String get recentTransactions => _t('recentTransactions');
  String get addFirstTransaction => _t('addFirstTransaction');
  String get seeAll => _t('seeAll');
  String get thisMonth => _t('thisMonth');
  String get amount => _t('amount');
  String get amountHint => _t('amountHint');
  String get selectCategory => _t('selectCategory');
  String get selectAccount => _t('selectAccount');
  String get categories => _t('categories');
  String get accountType => _t('accountType');
  String get cash => _t('cash');
  String get bank => _t('bank');
  String get credit => _t('credit');
  String get savings => _t('savings');
  String get food => _t('food');
  String get transport => _t('transport');
  String get shopping => _t('shopping');
  String get health => _t('health');
  String get entertainment => _t('entertainment');
  String get education => _t('education');
  String get bills => _t('bills');
  String get salary => _t('salary');
  String get freelance => _t('freelance');
  String get investment => _t('investment');
  String get other => _t('other');

  // Legacy support for navigation
  String get navDashboard => dashboard;
  String get navTransactions => transactions;
  String get navReports => reports;
  String get navSettings => settings;

  bool get isArabic => locale.languageCode == 'ar';
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => 
      ['en', 'ar', 'es', 'fr', 'de'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async => AppLocalizations(locale);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
