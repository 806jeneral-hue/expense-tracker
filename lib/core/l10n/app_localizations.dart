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
  String get income => _t('income');
  String get expense => _t('expense');
  String get save => _t('save');
  String get cancel => _t('cancel');
  String get delete => _t('delete');
  String get category => _t('category');
  String get account => _t('account');
  String get date => _t('date');
  String get addTransaction => _t('addTransaction');
  String get note => _t('note');
  String get search => _t('search');
  String get language => _t('language');
  String get currency => _t('currency');

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
