import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class SimplePriceChart extends StatelessWidget {
  final List<Map<String, dynamic>> monthlyData;
  
  const SimplePriceChart({
    Key? key,
    required this.monthlyData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Row(
            children: [
              Icon(
                Icons.show_chart,
                color: AppColors.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Grafik Harga Bulanan',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Harga per kg (Rp ribu)',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          
          // Chart Container
          Expanded(
            child: _buildChart(),
          ),
          
          // Legend
          const SizedBox(height: 12),
          _buildLegend(),
        ],
      ),
    );
  }

  Widget _buildChart() {
    // Find max value for scaling
    double maxValue = 0;
    for (var month in monthlyData) {
      final values = [month['jagung'], month['padi'], month['cabai']];
      for (var value in values) {
        if (value > maxValue) maxValue = value;
      }
    }
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Y-axis labels
        Container(
          width: 40,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${maxValue.toInt()}',
                style: TextStyle(
                  fontSize: 10,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                '${(maxValue * 0.75).toInt()}',
                style: TextStyle(
                  fontSize: 10,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                '${(maxValue * 0.5).toInt()}',
                style: TextStyle(
                  fontSize: 10,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                '${(maxValue * 0.25).toInt()}',
                style: TextStyle(
                  fontSize: 10,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                '0',
                style: TextStyle(
                  fontSize: 10,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(width: 8),
        
        // Main chart
        Expanded(
          child: Column(
            children: [
              // Grid lines
              Expanded(
                child: Container(
                  child: CustomPaint(
                    painter: _GridPainter(
                      maxValue: maxValue,
                      dataLength: monthlyData.length,
                    ),
                  ),
                ),
              ),
              
              // Bar chart with lines
              Expanded(
                child: Container(
                  child: CustomPaint(
                    painter: _PriceChartPainter(
                      monthlyData: monthlyData,
                      maxValue: maxValue,
                    ),
                  ),
                ),
              ),
              
              // Month labels
              Container(
                height: 20,
                margin: const EdgeInsets.only(top: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: monthlyData.map((month) {
                    return Text(
                      month['month'].toString(),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _legendItem('Jagung', AppColors.primary),
        const SizedBox(width: 16),
        _legendItem('Padi', AppColors.secondary),
        const SizedBox(width: 16),
        _legendItem('Cabai', AppColors.error),
      ],
    );
  }

  Widget _legendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _GridPainter extends CustomPainter {
  final double maxValue;
  final int dataLength;

  _GridPainter({
    required this.maxValue,
    required this.dataLength,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.15)
      ..strokeWidth = 0.8;

    // Horizontal grid lines
    for (int i = 0; i <= 4; i++) {
      final y = size.height * i / 4;
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _PriceChartPainter extends CustomPainter {
  final List<Map<String, dynamic>> monthlyData;
  final double maxValue;
  final double barWidth = 6.0;
  final double spacing = 16.0;

  _PriceChartPainter({
    required this.monthlyData,
    required this.maxValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (monthlyData.isEmpty) return;

    final totalWidth = monthlyData.length * (barWidth * 3 + spacing * 2);
    final startX = (size.width - totalWidth) / 2;

    for (int i = 0; i < monthlyData.length; i++) {
      final monthData = monthlyData[i];
      final baseX = startX + i * (barWidth * 3 + spacing * 2);

      // Draw bars
      _drawBar(
        canvas,
        baseX,
        monthData['jagung'].toDouble(),
        AppColors.primary,
        size.height,
      );
      _drawBar(
        canvas,
        baseX + barWidth + spacing,
        monthData['padi'].toDouble(),
        AppColors.secondary,
        size.height,
      );
      _drawBar(
        canvas,
        baseX + (barWidth + spacing) * 2,
        monthData['cabai'].toDouble(),
        AppColors.error,
        size.height,
      );

      // Draw connecting lines for each commodity
      if (i < monthlyData.length - 1) {
        _drawLine(
          canvas,
          baseX + barWidth / 2,
          monthData['jagung'].toDouble(),
          startX + (i + 1) * (barWidth * 3 + spacing * 2) + barWidth / 2,
          monthlyData[i + 1]['jagung'].toDouble(),
          AppColors.primary,
          size.height,
        );
        _drawLine(
          canvas,
          baseX + barWidth + spacing + barWidth / 2,
          monthData['padi'].toDouble(),
          startX + (i + 1) * (barWidth * 3 + spacing * 2) + barWidth + spacing + barWidth / 2,
          monthlyData[i + 1]['padi'].toDouble(),
          AppColors.secondary,
          size.height,
        );
        _drawLine(
          canvas,
          baseX + (barWidth + spacing) * 2 + barWidth / 2,
          monthData['cabai'].toDouble(),
          startX + (i + 1) * (barWidth * 3 + spacing * 2) + (barWidth + spacing) * 2 + barWidth / 2,
          monthlyData[i + 1]['cabai'].toDouble(),
          AppColors.error,
          size.height,
        );
      }

      // Draw value labels
      _drawValueLabel(
        canvas,
        baseX + barWidth / 2,
        monthData['jagung'].toDouble(),
        '${monthData['jagung']}',
        AppColors.primary,
        size.height,
      );
      _drawValueLabel(
        canvas,
        baseX + barWidth + spacing + barWidth / 2,
        monthData['padi'].toDouble(),
        '${monthData['padi']}',
        AppColors.secondary,
        size.height,
      );
      _drawValueLabel(
        canvas,
        baseX + (barWidth + spacing) * 2 + barWidth / 2,
        monthData['cabai'].toDouble(),
        '${monthData['cabai']}',
        AppColors.error,
        size.height,
      );
    }
  }

  void _drawBar(Canvas canvas, double x, double value, Color color, double height) {
    final barHeight = (value / maxValue) * height * 0.8;
    final y = height - barHeight;

    final paint = Paint()
      ..color = color.withOpacity(0.8)
      ..style = PaintingStyle.fill;

    final rect = Rect.fromLTWH(x, y, barWidth, barHeight);
    canvas.drawRect(rect, paint);
  }

  void _drawLine(Canvas canvas, double x1, double value1, double x2, double value2, Color color, double height) {
    final y1 = height - (value1 / maxValue) * height * 0.8 + 3;
    final y2 = height - (value2 / maxValue) * height * 0.8 + 3;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paint);
  }

  void _drawValueLabel(Canvas canvas, double x, double value, String text, Color color, double height) {
    final y = height - (value / maxValue) * height * 0.8 - 12;

    final textStyle = TextStyle(
      fontSize: 9,
      fontWeight: FontWeight.bold,
      color: color,
    );

    final textSpan = TextSpan(text: text, style: textStyle);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    )..layout();

    textPainter.paint(
      canvas,
      Offset(x - textPainter.width / 2, y),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}