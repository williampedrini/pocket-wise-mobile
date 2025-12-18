import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/transaction.dart';

class MonthlyOverviewChart extends StatelessWidget {
  final List<Transaction> transactions;
  final String currency;

  const MonthlyOverviewChart({
    super.key,
    this.transactions = const [],
    this.currency = '€',
  });

  @override
  Widget build(BuildContext context) {
    final chartData = _calculateChartData();
    final averagePerDay = _calculateAveragePerDay();

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Monthly Overview',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildAverageItem(
                label: 'Avg. Income/Day',
                value: averagePerDay.avgIncome,
                color: AppColors.incomeChart,
              ),
              _buildAverageItem(
                label: 'Avg. Expense/Day',
                value: averagePerDay.avgExpense,
                color: AppColors.expenseChart,
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 220,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 25),
              child: CustomPaint(
                size: const Size(double.infinity, 220),
                painter: ChartPainter(
                  incomeData: chartData.incomeByDay,
                  expenseData: chartData.expenseByDay,
                  maxValue: chartData.maxValue,
                  currency: currency,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem('Income', AppColors.incomeChart),
              const SizedBox(width: 24),
              _buildLegendItem('Expense', AppColors.expenseChart),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAverageItem({
    required String label,
    required double value,
    required Color color,
  }) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '$currency${value.toStringAsFixed(2)}',
          style: TextStyle(
            color: color,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  _AverageData _calculateAveragePerDay() {
    debugPrint('=== _calculateAveragePerDay ===');
    debugPrint('Total transactions: ${transactions.length}');

    if (transactions.isEmpty) {
      debugPrint('No transactions found, returning zeros');
      return _AverageData(avgIncome: 0, avgExpense: 0);
    }

    double totalIncome = 0;
    double totalExpense = 0;
    final Set<DateTime> uniqueDays = {};

    for (final tx in transactions) {
      final date = tx.effectiveDate;
      debugPrint('Transaction: amount=${tx.transactionAmount.amount}, '
          'currency=${tx.transactionAmount.currency}, '
          'isCredit=${tx.isCredit}, '
          'date=$date, '
          'description=${tx.remittanceInformation}');
      if (date != null) {
        uniqueDays.add(DateTime(date.year, date.month, date.day));
        if (tx.isCredit) {
          totalIncome += tx.transactionAmount.amount;
        } else {
          totalExpense += tx.transactionAmount.amount;
        }
      }
    }

    final daysCount = uniqueDays.isNotEmpty ? uniqueDays.length : 1;
    debugPrint('Unique days: $daysCount');
    debugPrint('Total income: $totalIncome, Total expense: $totalExpense');
    debugPrint('Avg income/day: ${totalIncome / daysCount}, Avg expense/day: ${totalExpense / daysCount}');
    debugPrint('=== End _calculateAveragePerDay ===');

    return _AverageData(
      avgIncome: totalIncome / daysCount,
      avgExpense: totalExpense / daysCount,
    );
  }

  _ChartData _calculateChartData() {
    final Map<int, double> incomeByDay = {};
    final Map<int, double> expenseByDay = {};

    for (int i = 0; i < 7; i++) {
      incomeByDay[i] = 0;
      expenseByDay[i] = 0;
    }

    if (transactions.isEmpty) {
      return _ChartData(
        incomeByDay: List.generate(7, (i) => 0.0),
        expenseByDay: List.generate(7, (i) => 0.0),
        maxValue: 150,
      );
    }

    for (final tx in transactions) {
      final date = tx.effectiveDate;
      if (date != null) {
        final dayIndex = (date.weekday - 1) % 7;
        if (tx.isCredit) {
          incomeByDay[dayIndex] = (incomeByDay[dayIndex] ?? 0) + tx.transactionAmount.amount;
        } else {
          expenseByDay[dayIndex] = (expenseByDay[dayIndex] ?? 0) + tx.transactionAmount.amount;
        }
      }
    }

    final incomeList = List.generate(7, (i) => incomeByDay[i] ?? 0.0);
    final expenseList = List.generate(7, (i) => expenseByDay[i] ?? 0.0);

    double maxValue = 0;
    for (final value in [...incomeList, ...expenseList]) {
      if (value > maxValue) maxValue = value;
    }

    if (maxValue == 0) maxValue = 150;

    return _ChartData(
      incomeByDay: incomeList,
      expenseByDay: expenseList,
      maxValue: maxValue,
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}

class _ChartData {
  final List<double> incomeByDay;
  final List<double> expenseByDay;
  final double maxValue;

  _ChartData({
    required this.incomeByDay,
    required this.expenseByDay,
    required this.maxValue,
  });
}

class _AverageData {
  final double avgIncome;
  final double avgExpense;

  _AverageData({
    required this.avgIncome,
    required this.avgExpense,
  });
}

class ChartPainter extends CustomPainter {
  final List<double> incomeData;
  final List<double> expenseData;
  final double maxValue;
  final String currency;

  ChartPainter({
    required this.incomeData,
    required this.expenseData,
    required this.maxValue,
    this.currency = '€',
  });

  @override
  void paint(Canvas canvas, Size size) {
    final incomePoints = _dataToPoints(incomeData, size);
    final expensePoints = _dataToPoints(expenseData, size);

    // Draw grid lines
    final gridPaint = Paint()
      ..color = Colors.grey.shade200
      ..strokeWidth = 1;

    for (int i = 0; i <= 3; i++) {
      final y = size.height * i / 3;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Draw income line
    _drawSmoothLine(canvas, incomePoints, AppColors.incomeChart, size);

    // Draw expense line
    _drawSmoothLine(canvas, expensePoints, AppColors.expenseChart, size);

    // Draw x-axis labels
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final textStyle = TextStyle(color: Colors.grey.shade500, fontSize: 11);

    for (int i = 0; i < days.length; i++) {
      final textSpan = TextSpan(text: days[i], style: textStyle);
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(size.width * i / 6 - textPainter.width / 2 + 10, size.height + 8),
      );
    }

    // Draw y-axis labels
    final amounts = [
      '$currency${maxValue.toStringAsFixed(0)}',
      '$currency${(maxValue * 2 / 3).toStringAsFixed(0)}',
      '$currency${(maxValue / 3).toStringAsFixed(0)}',
      '${currency}0',
    ];
    for (int i = 0; i < amounts.length; i++) {
      final textSpan = TextSpan(text: amounts[i], style: textStyle);
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(-35, size.height * i / 3 - textPainter.height / 2),
      );
    }
  }

  List<Offset> _dataToPoints(List<double> data, Size size) {
    if (data.isEmpty) return [];

    final points = <Offset>[];
    for (int i = 0; i < data.length; i++) {
      final x = size.width * i / (data.length - 1);
      final normalizedValue = maxValue > 0 ? data[i] / maxValue : 0;
      final y = size.height * (1 - normalizedValue);
      points.add(Offset(x, y.clamp(0, size.height)));
    }
    return points;
  }

  void _drawSmoothLine(Canvas canvas, List<Offset> points, Color color, Size size) {
    if (points.isEmpty) return;

    final linePaint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(points.first.dx, points.first.dy);

    for (int i = 0; i < points.length - 1; i++) {
      final p0 = points[i];
      final p1 = points[i + 1];
      final controlX = (p0.dx + p1.dx) / 2;
      path.cubicTo(controlX, p0.dy, controlX, p1.dy, p1.dx, p1.dy);
    }

    canvas.drawPath(path, linePaint);

    // Draw gradient fill
    final fillPath = Path.from(path);
    fillPath.lineTo(size.width, size.height);
    fillPath.lineTo(0, size.height);
    fillPath.close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [color.withOpacity(0.3), color.withOpacity(0.0)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(fillPath, fillPaint);
  }

  @override
  bool shouldRepaint(covariant ChartPainter oldDelegate) {
    return oldDelegate.incomeData != incomeData ||
        oldDelegate.expenseData != expenseData ||
        oldDelegate.maxValue != maxValue;
  }
}
