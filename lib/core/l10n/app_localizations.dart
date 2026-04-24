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
      'data': 'Data',
      'darkMode': 'Dark Mode',
      'appLock': 'App Lock',
      'appLockSubtitle': 'Use PIN/Password to unlock',
      'securityType': 'Security Type',
      'pin': 'PIN',
      'password': 'Password',
      'changePin': 'Change PIN',
      'changePassword': 'Change Password',
      'exportCsvSubtitle': 'Save transactions as CSV file',
      'exportSuccess': 'File exported successfully',
      'history': 'History',
      'recurringTransactions': 'Recurring Transactions',
      'noRecurringTransactions': 'No recurring transactions',
      'next': 'Next',
      'every': 'Every',
      'deleteRecurring': 'Delete recurring?',
      'daily': 'Daily',
      'weekly': 'Weekly',
      'monthly': 'Monthly',
      'yearly': 'Yearly',
      'saveRecurring': 'Save Recurring',
      'debts': 'Debts',
      'noDebts': 'No debts recorded',
      'owesYou': 'Owes you',
      'youOwe': 'You owe',
      'dueDate': 'Due Date',
      'addDebt': 'Add New Debt',
      'personName': 'Person Name',
      'thisMonthSummary': 'This Month\'s Summary',
      'budget': 'Budget',
      'welcome': 'Welcome',
      'manageExpenses': 'Manage your expenses easily',
      'currentBalance': 'Current Balance',
      'viewDetails': 'View Details',
      'remaining': 'Remaining',
      'monthlyBudget': 'Monthly Budget',
      'spent': 'Spent',
      'noBudgetSet': 'No budget set',
      'overBudget': 'Over budget!',
      'setBudget': 'Set Budget',
      'today': 'Today',
      'yesterday': 'Yesterday',
      'daysAgo': 'days ago',
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
      'data': 'البيانات',
      'darkMode': 'الوضع الليلي',
      'appLock': 'قفل التطبيق',
      'appLockSubtitle': 'استخدم الرقم السري لفتح التطبيق',
      'securityType': 'نوع الحماية',
      'pin': 'رقم سري',
      'password': 'كلمة مرور',
      'changePin': 'تغيير الرقم السري',
      'changePassword': 'تغيير كلمة المرور',
      'exportCsvSubtitle': 'حفظ نسخة من المعاملات بصيغة CSV',
      'exportSuccess': 'تم تصدير الملف بنجاح',
      'history': 'السجل',
      'recurringTransactions': 'المعاملات المتكررة',
      'noRecurringTransactions': 'لا توجد معاملات متكررة',
      'next': 'التالي',
      'every': 'كل',
      'deleteRecurring': 'حذف المعاملة المتكررة؟',
      'daily': 'يومياً',
      'weekly': 'أسبوعياً',
      'monthly': 'شهرياً',
      'yearly': 'سنوياً',
      'saveRecurring': 'حفظ المعاملة المتكررة',
      'debts': 'الديون',
      'noDebts': 'لا توجد ديون مسجلة',
      'owesYou': 'فلوس ليك',
      'youOwe': 'فلوس عليك',
      'dueDate': 'تاريخ الاستحقاق',
      'addDebt': 'إضافة دين جديد',
      'personName': 'اسم الشخص',
      'thisMonthSummary': 'ملخص هذا الشهر',
      'budget': 'الميزانية',
      'welcome': 'مرحباً بك',
      'manageExpenses': 'إدارة مصاريفك بسهولة',
      'currentBalance': 'الرصيد الحالي',
      'viewDetails': 'عرض التفاصيل',
      'remaining': 'المتبقي',
      'monthlyBudget': 'الميزانية الشهرية',
      'spent': 'المصروف',
      'noBudgetSet': 'لم تحدد ميزانية',
      'overBudget': 'لقد تجاوزت الميزانية!',
      'setBudget': 'تحديد الميزانية',
      'today': 'اليوم',
      'yesterday': 'أمس',
      'daysAgo': 'أيام',
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
      'data': 'Datos',
      'darkMode': 'Modo Oscuro',
      'appLock': 'Bloqueo de App',
      'appLockSubtitle': 'Usar PIN para desbloquear',
      'securityType': 'Tipo de Seguridad',
      'pin': 'PIN',
      'password': 'Contraseña',
      'changePin': 'Cambiar PIN',
      'changePassword': 'Cambiar Contraseña',
      'exportCsvSubtitle': 'Guardar transacciones como CSV',
      'exportSuccess': 'Archivo exportado con éxito',
      'history': 'Historial',
      'recurringTransactions': 'Transacciones Recurrentes',
      'noRecurringTransactions': 'Sin transacciones recurrentes',
      'next': 'Siguiente',
      'every': 'Cada',
      'deleteRecurring': '¿Eliminar recurrente?',
      'daily': 'Diario',
      'weekly': 'Semanal',
      'monthly': 'Mensual',
      'yearly': 'Anual',
      'saveRecurring': 'Guardar Recurrente',
      'debts': 'Deudas',
      'noDebts': 'Sin deudas registradas',
      'owesYou': 'Te deben',
      'youOwe': 'Debes',
      'dueDate': 'Fecha de vencimiento',
      'addDebt': 'Añadir Nueva Deuda',
      'personName': 'Nombre de la persona',
      'thisMonthSummary': 'Resumen de este mes',
      'budget': 'Presupuesto',
      'welcome': 'Bienvenido',
      'manageExpenses': 'Gestiona tus gastos fácilmente',
      'currentBalance': 'Saldo Actual',
      'viewDetails': 'Ver Detalles',
      'remaining': 'Restante',
      'monthlyBudget': 'Presupuesto Mensual',
      'spent': 'Gastado',
      'noBudgetSet': 'Sin presupuesto fijado',
      'overBudget': '¡Has superado el presupuesto!',
      'setBudget': 'Fijar Presupuesto',
      'today': 'Hoy',
      'yesterday': 'Ayer',
      'daysAgo': 'días atrás',
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
      'data': 'Données',
      'darkMode': 'Mode Sombre',
      'appLock': 'Verrouillage',
      'appLockSubtitle': 'Utiliser un code pour déverrouiller',
      'securityType': 'Type de sécurité',
      'pin': 'Code PIN',
      'password': 'Mot de passe',
      'changePin': 'Changer le PIN',
      'changePassword': 'Changer le mot de passe',
      'exportCsvSubtitle': 'Enregistrer en CSV',
      'exportSuccess': 'Exportation réussie',
      'history': 'Historique',
      'recurringTransactions': 'Transactions récurrentes',
      'noRecurringTransactions': 'Aucune transaction récurrente',
      'next': 'Suivant',
      'every': 'Chaque',
      'deleteRecurring': 'Supprimer la récurrence ?',
      'daily': 'Quotidien',
      'weekly': 'Hebdomadaire',
      'monthly': 'Mensuel',
      'yearly': 'Annuel',
      'saveRecurring': 'Enregistrer la récurrence',
      'debts': 'Dettes',
      'noDebts': 'Aucune dette enregistrée',
      'owesYou': 'On vous doit',
      'youOwe': 'Vous devez',
      'dueDate': 'Date d\'échéance',
      'addDebt': 'Ajouter une dette',
      'personName': 'Nom de la personne',
      'thisMonthSummary': 'Résumé du mois',
      'budget': 'Budget',
      'welcome': 'Bienvenue',
      'manageExpenses': 'Gérez vos dépenses facilement',
      'currentBalance': 'Solde actuel',
      'viewDetails': 'Voir les détails',
      'remaining': 'Restant',
      'monthlyBudget': 'Budget mensuel',
      'spent': 'Dépensé',
      'noBudgetSet': 'Pas de budget fixé',
      'overBudget': 'Hors budget !',
      'setBudget': 'Fixer le budget',
      'today': 'Aujourd\'hui',
      'yesterday': 'Hier',
      'daysAgo': 'jours',
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
      'data': 'Daten',
      'darkMode': 'Dunkelmodus',
      'appLock': 'App-Sperre',
      'appLockSubtitle': 'PIN zum Entsperren verwenden',
      'securityType': 'Sicherheitstyp',
      'pin': 'PIN',
      'password': 'Passwort',
      'changePin': 'PIN ändern',
      'changePassword': 'Passwort ändern',
      'exportCsvSubtitle': 'Transaktionen als CSV speichern',
      'exportSuccess': 'Datei erfolgreich exportiert',
      'history': 'Verlauf',
      'recurringTransactions': 'Wiederkehrende Transaktionen',
      'noRecurringTransactions': 'Keine wiederkehrenden Transaktionen',
      'next': 'Nächste',
      'every': 'Jeden',
      'deleteRecurring': 'Wiederholung löschen?',
      'daily': 'Täglich',
      'weekly': 'Wöchentlich',
      'monthly': 'Monatlich',
      'yearly': 'Jährlich',
      'saveRecurring': 'Wiederholung speichern',
      'debts': 'Schulden',
      'noDebts': 'Keine Schulden verzeichnet',
      'owesYou': 'Schuldet dir',
      'youOwe': 'Du schuldest',
      'dueDate': 'Fälligkeitsdatum',
      'addDebt': 'Schulden hinzufügen',
      'personName': 'Name der Person',
      'thisMonthSummary': 'Übersicht diesen Monat',
      'budget': 'Budget',
      'welcome': 'Willkommen',
      'manageExpenses': 'Verwalten Sie Ihre Ausgaben einfach',
      'currentBalance': 'Aktuelles Guthaben',
      'viewDetails': 'Details anzeigen',
      'remaining': 'Verbleibend',
      'monthlyBudget': 'Monatliches Budget',
      'spent': 'Ausgegeben',
      'noBudgetSet': 'Kein Budget festgelegt',
      'overBudget': 'Budget überschritten!',
      'setBudget': 'Budget festlegen',
      'today': 'Heute',
      'yesterday': 'Gestern',
      'daysAgo': 'Tage her',
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
  String get data => _t('data');
  String get darkMode => _t('darkMode');
  String get appLock => _t('appLock');
  String get appLockSubtitle => _t('appLockSubtitle');
  String get securityType => _t('securityType');
  String get pin => _t('pin');
  String get password => _t('password');
  String get changePin => _t('changePin');
  String get changePassword => _t('changePassword');
  String get exportCsvSubtitle => _t('exportCsvSubtitle');
  String get exportSuccess => _t('exportSuccess');
  String get history => _t('history');
  String get recurringTransactions => _t('recurringTransactions');
  String get noRecurringTransactions => _t('noRecurringTransactions');
  String get next => _t('next');
  String get every => _t('every');
  String get deleteRecurring => _t('deleteRecurring');
  String get daily => _t('daily');
  String get weekly => _t('weekly');
  String get monthly => _t('monthly');
  String get yearly => _t('yearly');
  String get saveRecurring => _t('saveRecurring');
  String get debts => _t('debts');
  String get noDebts => _t('noDebts');
  String get owesYou => _t('owesYou');
  String get youOwe => _t('youOwe');
  String get dueDate => _t('dueDate');
  String get addDebt => _t('addDebt');
  String get personName => _t('personName');
  String get thisMonthSummary => _t('thisMonthSummary');
  String get budget => _t('budget');
  String get welcome => _t('welcome');
  String get manageExpenses => _t('manageExpenses');
  String get currentBalance => _t('currentBalance');
  String get viewDetails => _t('viewDetails');
  String get remaining => _t('remaining');
  String get monthlyBudget => _t('monthlyBudget');
  String get spent => _t('spent');
  String get noBudgetSet => _t('noBudgetSet');
  String get overBudget => _t('overBudget');
  String get setBudget => _t('setBudget');
  String get today => _t('today');
  String get yesterday => _t('yesterday');
  String get daysAgo => _t('daysAgo');

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
