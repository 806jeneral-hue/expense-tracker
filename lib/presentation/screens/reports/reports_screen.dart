import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../providers/app_provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/utils/formatters.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final loc = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(loc.reports),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_month_rounded, color: Theme.of(context).colorScheme.primary),
            onPressed: () => _showMonthPicker(context, provider),
          ),
        ],
      ),
      body: provider.isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Theme.of(context).colorScheme.primary))
          : ListView(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 80),
              children: [
                _MonthSummaryCard(provider: provider, loc: loc),
                const SizedBox(height: 24),
                
                // ---- Charts Section ----
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      provider.transactionFilter == 'income' ? loc.income : loc.expense,
                      style: GoogleFonts.outfit(fontSize: 17, fontWeight: FontWeight.w700, color: Theme.of(context).textTheme.titleLarge?.color),
                    ),
                    _buildFilterToggle(context, provider, loc),
                  ],
                ),
                const SizedBox(height: 12),
                _ExpensePieChart(provider: provider, loc: loc),
                
                const SizedBox(height: 24),
                Text(loc.monthlyOverview,
                    style: GoogleFonts.outfit(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                const SizedBox(height: 12),
                _MonthlyBarChart(provider: provider),
                
                const SizedBox(height: 24),
                _CategoryBreakdownList(provider: provider, loc: loc),
                
                const SizedBox(height: 24),
                Text(
                  provider.isArabic ? "سجل المعاملات" : "Transaction History",
                  style: GoogleFonts.outfit(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 12),
                _DetailedTransactionList(provider: provider, loc: loc),
              ],
            ),
    );
  }

  Widget _buildFilterToggle(BuildContext context, AppProvider provider, AppLocalizations loc) {
    return Container(
      height: 32,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: Theme.of(context).dividerTheme.color?.withOpacity(0.1) ?? AppColors.divider.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          _buildToggleItem(context, provider, 'expense', loc.expense),
          _buildToggleItem(context, provider, 'income', loc.income),
        ],
      ),
    );
  }

  Widget _buildToggleItem(BuildContext context, AppProvider provider, String type, String label) {
    final isSelected = provider.transactionFilter == type;
    return GestureDetector(
      onTap: () => provider.setFilter(type),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).cardColor : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          boxShadow: const [],
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? Theme.of(context).colorScheme.primary : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  void _showMonthPicker(BuildContext context, AppProvider provider) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: provider.selectedMonth,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDatePickerMode: DatePickerMode.year,
    );
    if (picked != null) {
      provider.setSelectedMonth(picked);
    }
  }
}

class _MonthSummaryCard extends StatelessWidget {
  final AppProvider provider;
  final AppLocalizations loc;
  const _MonthSummaryCard({required this.provider, required this.loc});

  @override
  Widget build(BuildContext context) {
    final savings = provider.totalIncome - provider.totalExpense;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final incomeColor = isDark ? AppColors.darkIncome : AppColors.income;
    final expenseColor = isDark ? AppColors.darkExpense : AppColors.expense;
    final savingsColor = savings >= 0 ? incomeColor : expenseColor;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: isDark ? Border.all(color: AppColors.darkBorder) : null,
      ),
      child: Column(
        children: [
          Text(Formatters.formatMonth(provider.selectedMonth),
              style: GoogleFonts.outfit(fontSize: 13, color: AppColors.textSecondary)),
          const SizedBox(height: 8),
          Text(Formatters.formatCurrency(savings, currency: provider.currency),
              style: GoogleFonts.outfit(
                  fontSize: 28, fontWeight: FontWeight.w700,
                  color: savingsColor)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: Column(children: [
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(Icons.arrow_downward_rounded, color: incomeColor, size: 14),
                  const SizedBox(width: 4),
                  Text(loc.totalIncome, style: GoogleFonts.outfit(fontSize: 11, color: AppColors.textSecondary)),
                ]),
                const SizedBox(height: 4),
                Text(Formatters.formatCurrency(provider.totalIncome, currency: provider.currency),
                    style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.w700, color: incomeColor),
                    maxLines: 1, overflow: TextOverflow.ellipsis),
              ])),
              Container(width: 1, height: 36, color: isDark ? AppColors.darkBorder : AppColors.divider),
              Expanded(child: Column(children: [
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(Icons.arrow_upward_rounded, color: expenseColor, size: 14),
                  const SizedBox(width: 4),
                  Text(loc.totalExpense, style: GoogleFonts.outfit(fontSize: 11, color: AppColors.textSecondary)),
                ]),
                const SizedBox(height: 4),
                Text(Formatters.formatCurrency(provider.totalExpense, currency: provider.currency),
                    style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.w700, color: expenseColor),
                    maxLines: 1, overflow: TextOverflow.ellipsis),
              ])),
            ],
          ),
        ],
      ),
    );
  }
}

class _ExpensePieChart extends StatefulWidget {
  final AppProvider provider;
  final AppLocalizations loc;
  const _ExpensePieChart({required this.provider, required this.loc});

  @override
  State<_ExpensePieChart> createState() => _ExpensePieChartState();
}

class _ExpensePieChartState extends State<_ExpensePieChart> {
  int _touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final breakdown = widget.provider.categoryBreakdown;
    if (breakdown.isEmpty) {
      return Container(
        height: 140,
        decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(24),
            boxShadow: const []),
        child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Icon(Icons.pie_chart_outline_rounded, size: 36, color: AppColors.textLight),
          const SizedBox(height: 8),
          Text(widget.loc.noData, style: GoogleFonts.outfit(color: AppColors.textLight, fontSize: 13)),
        ])),
      );
    }

    final total = breakdown.fold<double>(0, (s, i) => s + (i['total'] as num).toDouble());

    return Container(
      height: 260,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(24),
          boxShadow: const []),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: PieChart(PieChartData(
              pieTouchData: PieTouchData(touchCallback: (event, response) {
                setState(() {
                  if (!event.isInterestedForInteractions || response?.touchedSection == null) {
                    _touchedIndex = -1;
                  } else {
                    _touchedIndex = response!.touchedSection!.touchedSectionIndex;
                  }
                });
              }),
              borderData: FlBorderData(show: false),
              sectionsSpace: 2,
              centerSpaceRadius: 44,
              sections: breakdown.asMap().entries.map((e) {
                final val = (e.value['total'] as num).toDouble();
                final pct = (val / total * 100);
                final touched = e.key == _touchedIndex;
                return PieChartSectionData(
                  color: AppColors.chartColors[e.key % AppColors.chartColors.length],
                  value: val,
                  title: '${pct.toStringAsFixed(0)}%',
                  radius: touched ? 68 : 56,
                  titleStyle: GoogleFonts.outfit(fontSize: touched ? 13 : 11, fontWeight: FontWeight.w600, color: Colors.white),
                );
              }).toList(),
            )),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: breakdown.take(6).toList().asMap().entries.map((e) {
                final name = widget.provider.isArabic ? (e.value['name_ar'] ?? e.value['name']) : e.value['name'];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(children: [
                    Container(width: 10, height: 10, decoration: BoxDecoration(
                        color: AppColors.chartColors[e.key % AppColors.chartColors.length], shape: BoxShape.circle)),
                    const SizedBox(width: 6),
                    Expanded(child: Text(name ?? '', style: GoogleFonts.outfit(fontSize: 11, color: AppColors.textSecondary),
                        maxLines: 1, overflow: TextOverflow.ellipsis)),
                  ]),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _MonthlyBarChart extends StatelessWidget {
  final AppProvider provider;
  const _MonthlyBarChart({required this.provider});

  @override
  Widget build(BuildContext context) {
    final data = provider.monthlyData;
    if (data.isEmpty) return const SizedBox.shrink();

    final maxY = data.fold<double>(0, (max, m) {
      final inc = (m['income'] as num).toDouble();
      final exp = (m['expense'] as num).toDouble();
      return [max, inc, exp].reduce((a, b) => a > b ? a : b);
    });

    return Container(
      height: 200,
      padding: const EdgeInsets.fromLTRB(12, 20, 12, 8),
      decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(24),
          boxShadow: const []),
      child: BarChart(BarChartData(
        maxY: maxY * 1.25 + 1,
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: AppColors.primary,
            getTooltipItem: (g, gi, rod, ri) => BarTooltipItem(
              Formatters.formatNumber(rod.toY),
              GoogleFonts.outfit(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) {
              final i = value.toInt();
              if (i < 0 || i >= data.length) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(DateFormat('MMM').format(data[i]['month'] as DateTime),
                    style: GoogleFonts.outfit(fontSize: 11, color: AppColors.textSecondary)),
              );
            },
          )),
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: FlGridData(show: true, drawVerticalLine: false,
            getDrawingHorizontalLine: (_) => FlLine(color: AppColors.divider, strokeWidth: 1)),
        borderData: FlBorderData(show: false),
        barGroups: data.asMap().entries.map((e) => BarChartGroupData(
          x: e.key,
          barRods: [
            BarChartRodData(toY: (e.value['income'] as num).toDouble(),
                color: AppColors.income, width: 9, borderRadius: BorderRadius.circular(4)),
            BarChartRodData(toY: (e.value['expense'] as num).toDouble(),
                color: AppColors.expense, width: 9, borderRadius: BorderRadius.circular(4)),
          ],
        )).toList(),
      )),
    );
  }
}

class _CategoryBreakdownList extends StatelessWidget {
  final AppProvider provider;
  final AppLocalizations loc;
  const _CategoryBreakdownList({required this.provider, required this.loc});

  @override
  Widget build(BuildContext context) {
    final breakdown = provider.categoryBreakdown;
    final total = breakdown.fold<double>(0, (s, i) => s + (i['total'] as num).toDouble());

    return Container(
      decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(24),
          boxShadow: const []),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        itemCount: breakdown.length,
        separatorBuilder: (_, __) => const Divider(height: 16),
        itemBuilder: (context, i) {
          final item = breakdown[i];
          final name = provider.isArabic ? (item['name_ar'] ?? item['name']) : item['name'];
          final amount = (item['total'] as num).toDouble();
          final pct = total > 0 ? amount / total : 0.0;
          final color = AppColors.chartColors[i % AppColors.chartColors.length];
          return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Row(children: [
                Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
                const SizedBox(width: 8),
                Text(name ?? '', style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
              ]),
              Text(Formatters.formatCurrency(amount, currency: provider.currency),
                  style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.expense)),
            ]),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(value: pct, backgroundColor: AppColors.divider,
                  valueColor: AlwaysStoppedAnimation(color), minHeight: 6),
            ),
          ]);
        },
      ),
    );
  }
}

class _DetailedTransactionList extends StatelessWidget {
  final AppProvider provider;
  final AppLocalizations loc;
  const _DetailedTransactionList({required this.provider, required this.loc});

  @override
  Widget build(BuildContext context) {
    if (provider.transactions.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text(loc.noTransactions, style: GoogleFonts.outfit(color: AppColors.textLight)),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: const [],
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: provider.transactions.length,
        separatorBuilder: (_, __) => const Divider(height: 1, indent: 16, endIndent: 16),
        itemBuilder: (context, i) {
          final tx = provider.transactions[i];
          final isIncome = tx.type == 'income';
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            leading: Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                color: (isIncome ? AppColors.income : AppColors.expense).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                isIncome ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
                color: isIncome ? AppColors.income : AppColors.expense,
                size: 20,
              ),
            ),
            title: Text(
              provider.isArabic ? (tx.categoryNameAr ?? tx.categoryName ?? "") : (tx.categoryName ?? ""),
              style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              "${DateFormat('dd MMM').format(tx.date)}${tx.note != null ? ' • ${tx.note}' : ''}",
              style: GoogleFonts.outfit(fontSize: 11, color: AppColors.textSecondary),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Text(
              "${isIncome ? '+' : '-'}${Formatters.formatCurrency(tx.amount, currency: provider.currency)}",
              style: GoogleFonts.outfit(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: isIncome ? AppColors.income : AppColors.expense,
              ),
            ),
          );
        },
      ),
    );
  }
}
