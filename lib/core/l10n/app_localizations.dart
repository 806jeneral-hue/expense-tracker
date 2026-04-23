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
      'save': 'Save',
      'cancel': 'Cancel',
      'delete': 'Delete',
      'category': 'Category',
      'account': 'Account',
      'date': 'Date',
      'addTransaction': 'Add Transaction',
      'note': 'Note',
      'search': 'Search...',
      'language': 'Language',
      'currency': 'Currency',
      'amountRequired': 'Amount is required',
      'accountRequired': 'Account is required',
      'categoryRequired': 'Category is required',
      'transactionSaved': 'Transaction saved!',
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
      'save': 'حفظ',
      'cancel': 'إلغاء',
      'delete': 'حذف',
      'category': 'التصنيف',
      'account': 'الحساب',
      'date': 'التاريخ',
      'addTransaction': 'إضافة معاملة',
      'note': 'ملاحظة',
      'search': 'بحث...',
      'language': 'اللغة',
      'currency': 'العملة',
      'amountRequired': 'المبلغ مطلوب',
      'accountRequired': 'الحساب مطلوب',
      'categoryRequired': 'التصنيف مطلوب',
      'transactionSaved': 'تم حفظ المعاملة!',
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
      'save': 'Guardar',
      'cancel': 'Cancelar',
      'delete': 'Eliminar',
      'category': 'Categoría',
      'account': 'Cuenta',
      'date': 'Fecha',
      'addTransaction': 'Añadir Transacción',
      'note': 'Nota',
      'search': 'Buscar...',
      'language': 'Idioma',
      'currency': 'Moneda',
      'amountRequired': 'El monto es obligatorio',
      'accountRequired': 'La cuenta es obligatoria',
      'categoryRequired': 'La categoría es obligatoria',
      'transactionSaved': '¡Transacción guardada!',
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
      'save': 'Enregistrer',
      'cancel': 'Annuler',
      'delete': 'Supprimer',
      'category': 'Catégorie',
      'account': 'Compte',
      'date': 'Date',
      'addTransaction': 'Ajouter Transaction',
      'note': 'Note',
      'search': 'Chercher...',
      'language': 'Langue',
      'currency': 'Devise',
      'amountRequired': 'Le montant est requis',
      'accountRequired': 'Le compte est requis',
      'categoryRequired': 'La catégorie est requise',
      'transactionSaved': 'Transaction enregistrée !',
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
      'save': 'Speichern',
      'cancel': 'Abbrechen',
      'delete': 'Löschen',
      'category': 'Kategorie',
      'account': 'Konto',
      'date': 'Datum',
      'addTransaction': 'Transaktion hinzufügen',
      'note': 'Notiz',
      'search': 'Suche...',
      'language': 'Sprache',
      'currency': 'Währung',
      'amountRequired': 'Betrag ist erforderlich',
      'accountRequired': 'Konto ist erforderlich',
      'categoryRequired': 'Kategorie ist erforderlich',
      'transactionSaved': 'Transaktion gespeichert!',
    },
  };

  String _t(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? 
           _localizedValues['en']?[key] ?? key;
  }

  // Getters
  String get appTitle => _t('appTitle');
  String get navDashboard => _t('dashboard');
  String get navTransactions => _t('transactions');
  String get navReports => _t('reports');
  String get navSettings => _t('settings');
  String get totalBalance => _t('totalBalance');
  String get totalIncome => _t('income');
  String get totalExpense => _t('expense');
  String get income => _t('income');
  String get expense => _t('expense');
  String get save => _t('save');
  String get cancel => _t('cancel');
  String get delete => _t('delete');
  String get category => _t('category');
  String get account => _t('account');
  String get date => _t('date');
  String get addTransaction => _t('addTransaction');
  String get editTransaction => _t('addTransaction'); // Can reuse for now
  String get note => _t('note');
  String get search => _t('search');
  String get language => _t('language');
  String get currency => _t('currency');
  String get amountRequired => _t('amountRequired');
  String get accountRequired => _t('accountRequired');
  String get categoryRequired => _t('categoryRequired');
  String get transactionSaved => _t('transactionSaved');
  String get noTransactions => _t('search'); // Placeholder
  String get expenseByCategory => _t('expense'); // Placeholder or specific
  String get monthlyOverview => _t('dashboard'); // Placeholder or specific

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
