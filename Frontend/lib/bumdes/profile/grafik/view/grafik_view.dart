import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/theme/app_colors.dart';
import '../../viewmodel/bumdes_profile_viewmodel.dart';

class GrafikView extends StatefulWidget {
  final BumdesProfileViewModel viewModel;
  
  const GrafikView({
    super.key,
    required this.viewModel,
  });

  @override
  State<GrafikView> createState() => _GrafikViewState();
}

class _GrafikViewState extends State<GrafikView> {
  String selectedCommodity = 'Semua';
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Grafik Harga Komoditas',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filter chips
            _buildFilterChips(),
            const SizedBox(height: 20),
            
            // Line Chart
            _buildLineChart(),
            const SizedBox(height: 24),
            
            // Bar Chart
            _buildBarChart(),
            const SizedBox(height: 24),
            
            // Statistics Cards
            _buildStatisticsCards(),
            const SizedBox(height: 24),
            
            // Price Trends
            _buildPriceTrends(),
          ],
        ),
      ),
    );
  }
  
  Widget _buildFilterChips() {
    final commodities = ['Semua', 'Padi', 'Jagung', 'Cabai'];
    
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: commodities.length,
        itemBuilder: (context, index) {
          final commodity = commodities[index];
          final isSelected = selectedCommodity == commodity;
          
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(commodity),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  selectedCommodity = commodity;
                });
              },
              backgroundColor: Colors.white,
              selectedColor: AppColors.primary,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : AppColors.textPrimary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              checkmarkColor: Colors.white,
              side: BorderSide(
                color: isSelected ? AppColors.primary : Colors.grey[300]!,
              ),
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildLineChart() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tren Harga Bulanan',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Perubahan harga dalam 4 bulan terakhir',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: LineChart(
              _getLineChartData(),
              duration: const Duration(milliseconds: 250),
            ),
          ),
        ],
      ),
    );
  }
  
  LineChartData _getLineChartData() {
    final chartData = widget.viewModel.getChartData();
    
    // Group data by commodity
    final commodityData = <String, List<FlSpot>>{};
    final months = <String>{};
    
    for (var data in chartData) {
      final commodity = data['commodity'] as String;
      final month = data['month'] as String;
      final value = data['value'] as double;
      
      months.add(month);
      
      if (selectedCommodity == 'Semua' || selectedCommodity == commodity) {
        commodityData[commodity] ??= [];
        final monthIndex = _getMonthIndex(month);
        commodityData[commodity]!.add(FlSpot(monthIndex.toDouble(), value));
      }
    }
    
    // Sort spots by x value
    commodityData.forEach((key, spots) {
      spots.sort((a, b) => a.x.compareTo(b.x));
    });
    
    final lines = commodityData.entries.map((entry) {
      final color = _getCommodityChartColor(entry.key);
      return LineChartBarData(
        spots: entry.value,
        isCurved: true,
        color: color,
        barWidth: 3,
        dotData: FlDotData(
          show: true,
          getDotPainter: (spot, percent, barData, index) {
            return FlDotCirclePainter(
              radius: 4,
              color: Colors.white,
              strokeWidth: 2,
              strokeColor: color,
            );
          },
        ),
        belowBarData: BarAreaData(
          show: true,
          color: color.withOpacity(0.1),
        ),
      );
    }).toList();
    
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.grey[200]!,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            getTitlesWidget: (value, meta) {
              return Text(
                '${value.toInt()}k',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 10,
                ),
              );
            },
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: (value, meta) {
              final months = ['Sep', 'Okt', 'Nov', 'Des'];
              if (value.toInt() < months.length) {
                return Text(
                  months[value.toInt()],
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 10,
                  ),
                );
              }
              return const Text('');
            },
          ),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(show: false),
      lineBarsData: lines,
    );
  }
  
  Widget _buildBarChart() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Perbandingan Harga',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Harga komoditas bulan ini',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: BarChart(
              _getBarChartData(),
              swapAnimationDuration: const Duration(milliseconds: 250),
            ),
          ),
        ],
      ),
    );
  }
  
  BarChartData _getBarChartData() {
    final chartData = widget.viewModel.getChartData();
    final currentMonthData = chartData.where((data) => 
      data['month'] == 'Desember').toList();
    
    final barGroups = <BarChartGroupData>[];
    final commodities = <String>[];
    
    for (int i = 0; i < currentMonthData.length; i++) {
      final data = currentMonthData[i];
      final commodity = data['commodity'] as String;
      
      if (selectedCommodity == 'Semua' || selectedCommodity == commodity) {
        commodities.add(commodity);
        barGroups.add(
          BarChartGroupData(
            x: barGroups.length,
            barRods: [
              BarChartRodData(
                toY: data['value'] as double,
                color: _getCommodityChartColor(commodity),
                width: 30,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
              ),
            ],
          ),
        );
      }
    }
    
    return BarChartData(
      alignment: BarChartAlignment.spaceEvenly,
      maxY: 40,
      barGroups: barGroups,
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.grey[200]!,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            getTitlesWidget: (value, meta) {
              return Text(
                '${value.toInt()}k',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 10,
                ),
              );
            },
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: (value, meta) {
              if (value.toInt() < commodities.length) {
                return Text(
                  commodities[value.toInt()],
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 10,
                  ),
                );
              }
              return const Text('');
            },
          ),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(show: false),
    );
  }
  
  Widget _buildStatisticsCards() {
    final stats = _calculateStatistics();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Statistik Harga',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                title: 'Rata-rata',
                value: 'Rp ${stats['average']}k',
                icon: Icons.show_chart,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                title: 'Tertinggi',
                value: 'Rp ${stats['highest']}k',
                icon: Icons.trending_up,
                color: Colors.green,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                title: 'Terendah',
                value: 'Rp ${stats['lowest']}k',
                icon: Icons.trending_down,
                color: Colors.orange,
              ),
            ),
          ],
        ),
      ],
    );
  }
  
  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 20,
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildPriceTrends() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Prediksi Tren',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          _buildTrendItem(
            commodity: 'Padi',
            trend: 'Stabil',
            prediction: 'Harga diprediksi stabil di kisaran Rp 6.500/kg',
            icon: Icons.grass,
            color: Colors.green,
          ),
          const SizedBox(height: 8),
          _buildTrendItem(
            commodity: 'Jagung',
            trend: 'Naik',
            prediction: 'Kemungkinan naik 5-10% bulan depan',
            icon: Icons.grain,
            color: Colors.orange,
          ),
          const SizedBox(height: 8),
          _buildTrendItem(
            commodity: 'Cabai',
            trend: 'Fluktuatif',
            prediction: 'Harga berfluktuasi tergantung musim',
            icon: Icons.local_fire_department,
            color: Colors.red,
          ),
        ],
      ),
    );
  }
  
  Widget _buildTrendItem({
    required String commodity,
    required String trend,
    required String prediction,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      commodity,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        trend,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: color,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  prediction,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  // Helper methods
  Color _getCommodityChartColor(String commodity) {
    switch (commodity.toLowerCase()) {
      case 'padi':
        return Colors.green;
      case 'jagung':
        return Colors.orange;
      case 'cabai':
        return Colors.red;
      default:
        return AppColors.primary;
    }
  }
  
  int _getMonthIndex(String month) {
    final months = ['September', 'Oktober', 'November', 'Desember'];
    for (int i = 0; i < months.length; i++) {
      if (months[i] == month) return i;
    }
    return 0;
  }
  
  Map<String, int> _calculateStatistics() {
    final chartData = widget.viewModel.getChartData();
    final values = chartData
        .where((data) => selectedCommodity == 'Semua' || 
                         selectedCommodity == data['commodity'])
        .map((data) => (data['value'] as double).toInt())
        .toList();
    
    if (values.isEmpty) {
      return {'average': 0, 'highest': 0, 'lowest': 0};
    }
    
    values.sort();
    final average = values.reduce((a, b) => a + b) ~/ values.length;
    
    return {
      'average': average,
      'highest': values.last,
      'lowest': values.first,
    };
  }
}
