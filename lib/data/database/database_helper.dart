import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/account_model.dart';
import '../models/category_model.dart';
import '../models/transaction_model.dart';
import '../models/budget_model.dart';
import '../models/debt_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('expense_tracker.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 3,
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE categories ADD COLUMN parent_id INTEGER REFERENCES categories(id) ON DELETE CASCADE');
    }
    if (oldVersion < 3) {
      // Budgets table
      await db.execute('''
        CREATE TABLE budgets (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          category_id INTEGER NOT NULL,
          amount REAL NOT NULL,
          month TEXT NOT NULL,
          FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE CASCADE
        )
      ''');

      // Recurring transactions table
      await db.execute('''
        CREATE TABLE recurring_transactions (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          account_id INTEGER NOT NULL,
          category_id INTEGER NOT NULL,
          amount REAL NOT NULL,
          type TEXT NOT NULL,
          note TEXT,
          frequency TEXT NOT NULL,
          next_execution TEXT NOT NULL,
          is_active INTEGER NOT NULL DEFAULT 1,
          FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE,
          FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE RESTRICT
        )
      ''');

      // Debts table
      await db.execute('''
        CREATE TABLE debts (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          person_name TEXT NOT NULL,
          amount REAL NOT NULL,
          type TEXT NOT NULL,
          is_paid INTEGER NOT NULL DEFAULT 0,
          date TEXT NOT NULL,
          due_date TEXT,
          note TEXT
        )
      ''');
    }
  }

  Future<void> _createDB(Database db, int version) async {
    // Accounts table
    await db.execute('''
      CREATE TABLE accounts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        type TEXT NOT NULL,
        balance REAL NOT NULL DEFAULT 0,
        currency TEXT NOT NULL DEFAULT 'EGP',
        color TEXT NOT NULL DEFAULT '#102C26',
        icon TEXT NOT NULL DEFAULT 'wallet',
        created_at TEXT NOT NULL
      )
    ''');

    // Categories table
    await db.execute('''
      CREATE TABLE categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        name_ar TEXT NOT NULL,
        type TEXT NOT NULL,
        color TEXT NOT NULL DEFAULT '#102C26',
        icon TEXT NOT NULL DEFAULT 'category',
        is_custom INTEGER NOT NULL DEFAULT 0,
        parent_id INTEGER REFERENCES categories(id) ON DELETE CASCADE
      )
    ''');

    // Transactions table
    await db.execute('''
      CREATE TABLE transactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        account_id INTEGER NOT NULL,
        category_id INTEGER NOT NULL,
        amount REAL NOT NULL,
        type TEXT NOT NULL,
        note TEXT,
        date TEXT NOT NULL,
        is_recurring INTEGER NOT NULL DEFAULT 0,
        recur_interval TEXT,
        created_at TEXT NOT NULL,
        FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE,
        FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE RESTRICT
      )
    ''');

    // Budgets table
    await db.execute('''
      CREATE TABLE budgets (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        category_id INTEGER NOT NULL,
        amount REAL NOT NULL,
        month TEXT NOT NULL,
        FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE CASCADE
      )
    ''');

    // Recurring transactions table
    await db.execute('''
      CREATE TABLE recurring_transactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        account_id INTEGER NOT NULL,
        category_id INTEGER NOT NULL,
        amount REAL NOT NULL,
        type TEXT NOT NULL,
        note TEXT,
        frequency TEXT NOT NULL,
        next_execution TEXT NOT NULL,
        is_active INTEGER NOT NULL DEFAULT 1,
        FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE,
        FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE RESTRICT
      )
    ''');

    // Debts table
    await db.execute('''
      CREATE TABLE debts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        person_name TEXT NOT NULL,
        amount REAL NOT NULL,
        type TEXT NOT NULL,
        is_paid INTEGER NOT NULL DEFAULT 0,
        date TEXT NOT NULL,
        due_date TEXT,
        note TEXT
      )
    ''');

    // Seed default data
    await _seedData(db);
  }

    // Seed default data
    await _seedData(db);
  }

  Future<void> _seedData(Database db) async {
    final now = DateTime.now().toIso8601String();

    // Default account
    await db.insert('accounts', {
      'name': 'Main Wallet',
      'type': 'cash',
      'balance': 0.0,
      'currency': 'EGP',
      'color': '#102C26',
      'icon': 'wallet',
      'created_at': now,
    });

    // Default expense categories
    final expenseCategories = [
      {'name': 'Food & Dining', 'name_ar': 'الطعام', 'icon': 'restaurant', 'color': '#E74C3C'},
      {'name': 'Transport', 'name_ar': 'المواصلات', 'icon': 'directions_car', 'color': '#3498DB'},
      {'name': 'Shopping', 'name_ar': 'التسوق', 'icon': 'shopping_bag', 'color': '#9B59B6'},
      {'name': 'Health', 'name_ar': 'الصحة', 'icon': 'local_hospital', 'color': '#E91E63'},
      {'name': 'Entertainment', 'name_ar': 'الترفيه', 'icon': 'movie', 'color': '#FF9800'},
      {'name': 'Education', 'name_ar': 'التعليم', 'icon': 'school', 'color': '#2196F3'},
      {'name': 'Bills', 'name_ar': 'الفواتير', 'icon': 'receipt', 'color': '#607D8B'},
      {'name': 'Other', 'name_ar': 'أخرى', 'icon': 'more_horiz', 'color': '#102C26'},
    ];

    for (final cat in expenseCategories) {
      await db.insert('categories', {
        'name': cat['name'],
        'name_ar': cat['name_ar'],
        'type': 'expense',
        'color': cat['color'],
        'icon': cat['icon'],
        'is_custom': 0,
      });
    }

    // Default income categories
    final incomeCategories = [
      {'name': 'Salary', 'name_ar': 'المرتب', 'icon': 'work', 'color': '#27AE60'},
      {'name': 'Freelance', 'name_ar': 'عمل حر', 'icon': 'laptop', 'color': '#1ABC9C'},
      {'name': 'Investment', 'name_ar': 'استثمار', 'icon': 'trending_up', 'color': '#F39C12'},
      {'name': 'Gift', 'name_ar': 'هدية', 'icon': 'card_giftcard', 'color': '#8E44AD'},
      {'name': 'Other', 'name_ar': 'أخرى', 'icon': 'more_horiz', 'color': '#102C26'},
    ];

    for (final cat in incomeCategories) {
      await db.insert('categories', {
        'name': cat['name'],
        'name_ar': cat['name_ar'],
        'type': 'income',
        'color': cat['color'],
        'icon': cat['icon'],
        'is_custom': 0,
      });
    }
  }

  // ==================== ACCOUNTS ====================

  Future<int> insertAccount(AccountModel account) async {
    final db = await database;
    return await db.insert('accounts', account.toMap());
  }

  Future<List<AccountModel>> getAccounts() async {
    final db = await database;
    final maps = await db.query('accounts', orderBy: 'created_at ASC');
    return maps.map((m) => AccountModel.fromMap(m)).toList();
  }

  Future<AccountModel?> getAccount(int id) async {
    final db = await database;
    final maps = await db.query('accounts', where: 'id = ?', whereArgs: [id]);
    if (maps.isEmpty) return null;
    return AccountModel.fromMap(maps.first);
  }

  Future<int> updateAccount(AccountModel account) async {
    final db = await database;
    return await db.update(
      'accounts',
      account.toMap(),
      where: 'id = ?',
      whereArgs: [account.id],
    );
  }

  Future<int> updateAccountBalance(int accountId, double newBalance) async {
    final db = await database;
    return await db.update(
      'accounts',
      {'balance': newBalance},
      where: 'id = ?',
      whereArgs: [accountId],
    );
  }

  Future<int> deleteAccount(int id) async {
    final db = await database;
    return await db.delete('accounts', where: 'id = ?', whereArgs: [id]);
  }

  // ==================== CATEGORIES ====================

  Future<int> insertCategory(CategoryModel category) async {
    final db = await database;
    return await db.insert('categories', category.toMap());
  }

  Future<List<CategoryModel>> getCategories({String? type}) async {
    final db = await database;
    final maps = await db.query(
      'categories',
      where: type != null ? 'type = ?' : null,
      whereArgs: type != null ? [type] : null,
      orderBy: 'is_custom ASC, id ASC',
    );
    return maps.map((m) => CategoryModel.fromMap(m)).toList();
  }

  Future<int> deleteCategory(int id) async {
    final db = await database;
    return await db.delete('categories', where: 'id = ?', whereArgs: [id]);
  }

  // ==================== TRANSACTIONS ====================

  Future<int> insertTransaction(TransactionModel transaction) async {
    final db = await database;
    final id = await db.insert('transactions', transaction.toMap());

    // Update account balance
    final account = await getAccount(transaction.accountId);
    if (account != null) {
      final newBalance = transaction.isIncome
          ? account.balance + transaction.amount
          : account.balance - transaction.amount;
      await updateAccountBalance(transaction.accountId, newBalance);
    }

    return id;
  }

  Future<List<TransactionModel>> getTransactions({
    int? accountId,
    String? type,
    DateTime? startDate,
    DateTime? endDate,
    String? searchQuery,
    int? limit,
  }) async {
    final db = await database;

    String query = '''
      SELECT 
        t.*,
        a.name as account_name,
        c.name as category_name,
        c.name_ar as category_name_ar,
        c.icon as category_icon,
        c.color as category_color
      FROM transactions t
      LEFT JOIN accounts a ON t.account_id = a.id
      LEFT JOIN categories c ON t.category_id = c.id
      WHERE 1=1
    ''';

    final args = <dynamic>[];

    if (accountId != null) {
      query += ' AND t.account_id = ?';
      args.add(accountId);
    }
    if (type != null) {
      query += ' AND t.type = ?';
      args.add(type);
    }
    if (startDate != null) {
      query += ' AND t.date >= ?';
      args.add(startDate.toIso8601String());
    }
    if (endDate != null) {
      query += ' AND t.date <= ?';
      args.add(endDate.toIso8601String());
    }
    if (searchQuery != null && searchQuery.isNotEmpty) {
      query += ' AND (t.note LIKE ? OR c.name LIKE ? OR c.name_ar LIKE ?)';
      final q = '%$searchQuery%';
      args.addAll([q, q, q]);
    }

    query += ' ORDER BY t.date DESC';

    if (limit != null) {
      query += ' LIMIT $limit';
    }

    final maps = await db.rawQuery(query, args);
    return maps.map((m) => TransactionModel.fromMap(m)).toList();
  }

  Future<int> updateTransaction(
      TransactionModel oldTx, TransactionModel newTx) async {
    final db = await database;

    // Reverse old transaction effect on balance
    final account = await getAccount(oldTx.accountId);
    if (account != null) {
      final revertedBalance = oldTx.isIncome
          ? account.balance - oldTx.amount
          : account.balance + oldTx.amount;

      final finalBalance = newTx.isIncome
          ? revertedBalance + newTx.amount
          : revertedBalance - newTx.amount;

      await updateAccountBalance(oldTx.accountId, finalBalance);
    }

    return await db.update(
      'transactions',
      newTx.toMap(),
      where: 'id = ?',
      whereArgs: [oldTx.id],
    );
  }

  Future<int> deleteTransaction(TransactionModel transaction) async {
    final db = await database;

    // Reverse balance effect
    final account = await getAccount(transaction.accountId);
    if (account != null) {
      final newBalance = transaction.isIncome
          ? account.balance - transaction.amount
          : account.balance + transaction.amount;
      await updateAccountBalance(transaction.accountId, newBalance);
    }

    return await db.delete(
      'transactions',
      where: 'id = ?',
      whereArgs: [transaction.id],
    );
  }

  // ==================== SUMMARY ====================

  Future<Map<String, double>> getMonthlySummary(DateTime month) async {
    final db = await database;
    final start = DateTime(month.year, month.month, 1);
    final end = DateTime(month.year, month.month + 1, 0, 23, 59, 59);

    final result = await db.rawQuery('''
      SELECT 
        SUM(CASE WHEN type = 'income' THEN amount ELSE 0 END) as total_income,
        SUM(CASE WHEN type = 'expense' THEN amount ELSE 0 END) as total_expense
      FROM transactions
      WHERE date >= ? AND date <= ?
    ''', [start.toIso8601String(), end.toIso8601String()]);

    if (result.isEmpty) return {'income': 0, 'expense': 0};
    return {
      'income': (result.first['total_income'] as num?)?.toDouble() ?? 0,
      'expense': (result.first['total_expense'] as num?)?.toDouble() ?? 0,
    };
  }

  Future<List<Map<String, dynamic>>> getCategoryBreakdown(
      DateTime month, String type) async {
    final db = await database;
    final start = DateTime(month.year, month.month, 1);
    final end = DateTime(month.year, month.month + 1, 0, 23, 59, 59);

    return await db.rawQuery('''
      SELECT 
        c.id,
        c.name,
        c.name_ar,
        c.color,
        c.icon,
        SUM(t.amount) as total
      FROM transactions t
      LEFT JOIN categories c ON t.category_id = c.id
      WHERE t.type = ? AND t.date >= ? AND t.date <= ?
      GROUP BY t.category_id
      ORDER BY total DESC
    ''', [type, start.toIso8601String(), end.toIso8601String()]);
  }

  Future<List<Map<String, dynamic>>> getLast6MonthsData() async {
    final db = await database;
    final results = <Map<String, dynamic>>[];

    for (int i = 5; i >= 0; i--) {
      final month = DateTime(DateTime.now().year, DateTime.now().month - i, 1);
      final start = month;
      final end = DateTime(month.year, month.month + 1, 0, 23, 59, 59);

      final data = await db.rawQuery('''
        SELECT 
          SUM(CASE WHEN type = 'income' THEN amount ELSE 0 END) as income,
          SUM(CASE WHEN type = 'expense' THEN amount ELSE 0 END) as expense
        FROM transactions
        WHERE date >= ? AND date <= ?
      ''', [start.toIso8601String(), end.toIso8601String()]);

      results.add({
        'month': month,
        'income': (data.first['income'] as num?)?.toDouble() ?? 0,
        'expense': (data.first['expense'] as num?)?.toDouble() ?? 0,
      });
    }

    return results;
  }

  // ==================== BUDGETS ====================

  Future<int> insertBudget(BudgetModel budget) async {
    final db = await database;
    return await db.insert('budgets', budget.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<BudgetModel>> getBudgets(DateTime month) async {
    final db = await database;
    final monthStr = '${month.year}-${month.month.toString().padLeft(2, '0')}-01';
    final maps = await db.query('budgets', where: 'month = ?', whereArgs: [monthStr]);
    return maps.map((m) => BudgetModel.fromMap(m)).toList();
  }

  Future<int> deleteBudget(int id) async {
    final db = await database;
    return await db.delete('budgets', where: 'id = ?', whereArgs: [id]);
  }

  // ==================== DEBTS ====================

  Future<int> insertDebt(DebtModel debt) async {
    final db = await database;
    return await db.insert('debts', debt.toMap());
  }

  Future<List<DebtModel>> getDebts({bool? isPaid}) async {
    final db = await database;
    final maps = await db.query(
      'debts',
      where: isPaid != null ? 'is_paid = ?' : null,
      whereArgs: isPaid != null ? [isPaid ? 1 : 0] : null,
      orderBy: 'date DESC',
    );
    return maps.map((m) => DebtModel.fromMap(m)).toList();
  }

  Future<int> updateDebt(DebtModel debt) async {
    final db = await database;
    return await db.update(
      'debts',
      debt.toMap(),
      where: 'id = ?',
      whereArgs: [debt.id],
    );
  }

  Future<int> deleteDebt(int id) async {
    final db = await database;
    return await db.delete('debts', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> close() async {
    final db = await database;
    db.close();
  }
}
