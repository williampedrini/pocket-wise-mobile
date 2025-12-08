import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class MonthlyOverviewChart extends StatelessWidget {
  const MonthlyOverviewChart({super.key});

  @override
  Widget build(BuildContext context) {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Monthly Overview',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Text(
                      'This Month',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(Icons.keyboard_arrow_down, size: 18, color: Colors.grey.shade600),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 180,
            child: CustomPaint(
              size: const Size(double.infinity, 180),
              painter: ChartPainter(),
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

class ChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final incomePoints = [
      Offset(0, size.height * 0.5),
      Offset(size.width * 0.15, size.height * 0.35),
      Offset(size.width * 0.3, size.height * 0.45),
      Offset(size.width * 0.45, size.height * 0.2),
      Offset(size.width * 0.6, size.height * 0.15),
      Offset(size.width * 0.75, size.height * 0.35),
      Offset(size.width * 0.9, size.height * 0.1),
      Offset(size.width, size.height * 0.05),
    ];

    final expensePoints = [
      Offset(0, size.height * 0.6),
      Offset(size.width * 0.15, size.height * 0.55),
      Offset(size.width * 0.3, size.height * 0.7),
      Offset(size.width * 0.45, size.height * 0.45),
      Offset(size.width * 0.6, size.height * 0.65),
      Offset(size.width * 0.75, size.height * 0.5),
      Offset(size.width * 0.9, size.height * 0.55),
      Offset(size.width, size.height * 0.4),
    ];

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
    final amounts = ['\$150', '\$100', '\$50', '\$0'];
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

  void _drawSmoothLine(Canvas canvas, List<Offset> points, Color color, Size size) {
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
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
