import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../providers/app_settings_provider.dart';

class AdminStatsScreen extends StatefulWidget {
  const AdminStatsScreen({super.key});

  @override
  State<AdminStatsScreen> createState() => _AdminStatsScreenState();
}

class _AdminStatsScreenState extends State<AdminStatsScreen> {
  String timePeriod = 'month';
  bool _showAllItems = false;
  
  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<AppSettingsProvider>(context);
    final isDark = settings.isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0e1116) : const Color(0xFFf5f5f5),
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF1a1f2e) : Colors.white,
        elevation: 0,
        title: Text(
          settings.t('statistics'),
          style: TextStyle(
            color: isDark ? const Color(0xFF3cad2a) : const Color(0xFF062c6b),
            fontSize: 24,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF0e1116) : const Color(0xFFf3f4f6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  _buildPeriodButton('month', settings.t('month'), isDark),
                  _buildPeriodButton('year', settings.t('year'), isDark),
                ],
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Key Metrics
              _buildKeyMetrics(isDark, settings),
              const SizedBox(height: 24),
              
              // Revenue Chart
              _buildRevenueChart(isDark, settings),
              const SizedBox(height: 24),
              
              if (timePeriod != 'year') ...[
                // Most Ordered Items
                _buildMostOrderedItems(isDark, settings),
                const SizedBox(height: 24),
                
                // Orders by Time
                _buildOrdersByTime(isDark, settings),
                const SizedBox(height: 24),

                // Order Status Distribution (Pie Chart)
                _buildOrderStatusDistribution(isDark, settings),
              ],
              
              // Bottom padding for floating nav bar
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildPeriodButton(String period, String label, bool isDark) {
    final isSelected = timePeriod == period;
    return GestureDetector(
      onTap: () {
        setState(() {
          timePeriod = period;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected 
              ? (isDark ? const Color(0xFF3cad2a) : const Color(0xFF062c6b)) 
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected 
                ? Colors.white 
                : (isDark ? const Color(0xFF9ca3af) : const Color(0xFF6b7280)),
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
  
  Widget _buildKeyMetrics(bool isDark, AppSettingsProvider settings) {
    final isYear = timePeriod == 'year';
    final metrics = [
      {
        'title': settings.t('totalOrders'),
        'value': isYear ? '15,420' : '45',
        'subtitle': isYear ? '+15% ${settings.t('comparisonWithLast')} ${settings.t('year')}' : '+12% ${settings.t('fromYesterday')}',
        'color': const Color(0xFF3cad2a),
        'icon': Icons.shopping_bag_rounded,
      },
      {
        'title': settings.t('revenue'),
        'value': isYear ? '\$452,000' : '\$1,245',
        'subtitle': isYear ? '+22% ${settings.t('comparisonWithLast')} ${settings.t('year')}' : '+8% ${settings.t('fromYesterday')}',
        'color': const Color(0xFF062c6b),
        'icon': Icons.trending_up_rounded,
      },
      {
        'title': settings.t('avgWaitTime'),
        'value': isYear ? '18m' : '15m',
        'subtitle': isYear ? '-1m ${settings.t('comparisonWithLast')} ${settings.t('year')}' : '-2m ${settings.t('fromYesterday')}',
        'color': const Color(0xFFf59e0b),
        'icon': Icons.schedule_rounded,
      },
      {
        'title': settings.t('activeUsers'),
        'value': isYear ? '1,250' : '42',
        'subtitle': isYear ? '+120 ${settings.t('newUsers')}' : '+5 ${settings.t('newUsers')}',
        'color': const Color(0xFF8b5cf6),
        'icon': Icons.people_rounded,
      },
    ];
    
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.4,
      ),
      itemCount: metrics.length,
      itemBuilder: (context, index) {
        final metric = metrics[index];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1a1f2e) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark ? Colors.white.withOpacity(0.05) : Colors.transparent,
            ),
            boxShadow: [
              BoxShadow(
                color: isDark ? Colors.black.withOpacity(0.2) : const Color(0xFF062c6b).withOpacity(0.05),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: (metric['color'] as Color).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      metric['icon'] as IconData,
                      color: metric['color'] as Color,
                      size: 20,
                    ),
                  ),
                  if (index == 0 || index == 1) // Just for demo
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF3cad2a).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.arrow_upward_rounded, size: 10, color: Color(0xFF3cad2a)),
                          const SizedBox(width: 2),
                          Text(
                            isYear ? '15%' : '12%',
                            style: const TextStyle(
                              color: Color(0xFF3cad2a),
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    metric['value'] as String,
                    style: TextStyle(
                      color: isDark ? const Color(0xFFf9fafb) : const Color(0xFF111827),
                      fontFamily: 'Poppins',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    metric['title'] as String,
                    style: TextStyle(
                      color: isDark ? const Color(0xFF9ca3af) : const Color(0xFF6b7280),
                      fontFamily: 'Poppins',
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildRevenueChart(bool isDark, AppSettingsProvider settings) {
    final isYear = timePeriod == 'year';
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1a1f2e) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.05) : Colors.transparent,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withOpacity(0.2) : const Color(0xFF062c6b).withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            settings.t('revenueTrends'),
            style: TextStyle(
              color: isDark ? const Color(0xFFf9fafb) : const Color(0xFF111827),
              fontFamily: 'Poppins',
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${settings.t('comparison')} ${settings.t(timePeriod)}',
            style: TextStyle(
              color: isDark ? const Color(0xFF9ca3af) : const Color(0xFF6b7280),
              fontFamily: 'Poppins',
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      color: Color(0xFF3cad2a),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    settings.t('revenue'),
                    style: TextStyle(
                      color: isDark ? const Color(0xFF9ca3af) : const Color(0xFF6b7280),
                      fontFamily: 'Poppins',
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Row(
                children: [
                  Container(
                    width: 12,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF9ca3af) : const Color(0xFF062c6b),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    settings.t('customers'),
                    style: TextStyle(
                      color: isDark ? const Color(0xFF9ca3af) : const Color(0xFF6b7280),
                      fontFamily: 'Poppins',
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 220,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: isYear ? 100 : 1,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        if (isYear) {
                          const years = ['2021', '2022', '2023', '2024', '2025'];
                          if (value.toInt() >= 0 && value.toInt() < years.length) {
                             return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                years[value.toInt()],
                                style: TextStyle(
                                  color: isDark ? const Color(0xFF9ca3af) : const Color(0xFF6b7280),
                                  fontFamily: 'Poppins',
                                  fontSize: 11,
                                ),
                              ),
                            );
                          }
                        } else {
                          const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];
                          if (value.toInt() >= 0 && value.toInt() < months.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                months[value.toInt()],
                                style: TextStyle(
                                  color: isDark ? const Color(0xFF9ca3af) : const Color(0xFF6b7280),
                                  fontFamily: 'Poppins',
                                  fontSize: 11,
                                ),
                              ),
                            );
                          }
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '\$${value.toInt()}k',
                          style: TextStyle(
                            color: isDark ? const Color(0xFF9ca3af) : const Color(0xFF6b7280),
                            fontFamily: 'Poppins',
                            fontSize: 11,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: isYear ? 4 : 5,
                minY: 0,
                maxY: isYear ? 500 : 6,
                lineBarsData: [
                  LineChartBarData(
                    spots: isYear 
                      ? const [
                          FlSpot(0, 250),
                          FlSpot(1, 320),
                          FlSpot(2, 380),
                          FlSpot(3, 420),
                          FlSpot(4, 452),
                        ]
                      : const [
                          FlSpot(0, 3),
                          FlSpot(1, 2.5),
                          FlSpot(2, 4),
                          FlSpot(3, 3.8),
                          FlSpot(4, 5),
                          FlSpot(5, 4.5),
                        ],
                    isCurved: true,
                    color: const Color(0xFF3cad2a),
                    barWidth: 4,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          const Color(0xFF3cad2a).withOpacity(0.2),
                          const Color(0xFF3cad2a).withOpacity(0.0),
                        ],
                      ),
                    ),
                  ),
                  LineChartBarData(
                    spots: isYear
                      ? const [
                          FlSpot(0, 180),
                          FlSpot(1, 240),
                          FlSpot(2, 290),
                          FlSpot(3, 340),
                          FlSpot(4, 390),
                        ]
                      : const [
                          FlSpot(0, 2),
                          FlSpot(1, 1.8),
                          FlSpot(2, 2.5),
                          FlSpot(3, 2.3),
                          FlSpot(4, 3.5),
                          FlSpot(5, 3),
                        ],
                    isCurved: true,
                    color: isDark ? const Color(0xFF9ca3af) : const Color(0xFF062c6b),
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    dashArray: [5, 5],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildMostOrderedItems(bool isDark, AppSettingsProvider settings) {
    final allItems = [
      {'name': 'Espresso', 'count': 45},
      {'name': 'Cappuccino', 'count': 38},
      {'name': 'Croissant', 'count': 32},
      {'name': 'Sandwich', 'count': 28},
      {'name': 'Latte', 'count': 25},
      {'name': 'Muffin', 'count': 20},
      {'name': 'Tea', 'count': 18},
      {'name': 'Bagel', 'count': 15},
      {'name': 'Juice', 'count': 12},
      {'name': 'Cookie', 'count': 10},
    ];

    final items = _showAllItems ? allItems : allItems.take(5).toList();
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1a1f2e) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.05) : Colors.transparent,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withOpacity(0.2) : const Color(0xFF062c6b).withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            settings.t('mostOrderedItems'),
            style: TextStyle(
              color: isDark ? const Color(0xFFf9fafb) : const Color(0xFF111827),
              fontFamily: 'Poppins',
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          ...items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final maxCount = allItems[0]['count'] as int;
            final percentage = (item['count'] as int) / maxCount;
            
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: (isDark ? const Color(0xFF3cad2a) : const Color(0xFF062c6b)).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          color: isDark ? const Color(0xFF3cad2a) : const Color(0xFF062c6b),
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              item['name'] as String,
                              style: TextStyle(
                                color: isDark ? const Color(0xFFf9fafb) : const Color(0xFF111827),
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              '${item['count']} ${settings.t('orders')}',
                              style: TextStyle(
                                color: isDark ? const Color(0xFF9ca3af) : const Color(0xFF6b7280),
                                fontFamily: 'Poppins',
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 8,
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF0e1116) : const Color(0xFFf3f4f6),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: FractionallySizedBox(
                            widthFactor: percentage,
                            alignment: Alignment.centerLeft,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    isDark ? const Color(0xFF3cad2a) : const Color(0xFF062c6b),
                                    isDark ? const Color(0xFF2d8a20) : const Color(0xFF041e4a),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
          Center(
            child: TextButton(
              onPressed: () {
                setState(() {
                  _showAllItems = !_showAllItems;
                });
              },
              child: Text(
                _showAllItems ? settings.t('showLess') : settings.t('showMore'),
                style: TextStyle(
                  color: isDark ? const Color(0xFF3cad2a) : const Color(0xFF062c6b),
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildOrdersByTime(bool isDark, AppSettingsProvider settings) {
    final hourlyData = [
      {'hour': 8, 'orders': 5},
      {'hour': 9, 'orders': 12},
      {'hour': 10, 'orders': 25},
      {'hour': 11, 'orders': 18},
      {'hour': 12, 'orders': 45},
      {'hour': 13, 'orders': 40},
      {'hour': 14, 'orders': 22},
      {'hour': 15, 'orders': 15},
      {'hour': 16, 'orders': 10},
      {'hour': 17, 'orders': 8},
      {'hour': 18, 'orders': 12},
      {'hour': 19, 'orders': 20},
      {'hour': 20, 'orders': 18},
      {'hour': 21, 'orders': 10},
    ];

    final morningData = hourlyData.where((d) => (d['hour'] as int) <= 14).toList();
    final eveningData = hourlyData.where((d) => (d['hour'] as int) > 14).toList();

    return Column(
      children: [
        _buildTimeChart(morningData, settings.t('ordersByHourMorning'), isDark),
        const SizedBox(height: 24),
        _buildTimeChart(eveningData, settings.t('ordersByHourEvening'), isDark),
      ],
    );
  }

  Widget _buildTimeChart(List<Map<String, dynamic>> data, String title, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1a1f2e) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.05) : Colors.transparent,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withOpacity(0.2) : const Color(0xFF062c6b).withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: isDark ? const Color(0xFFf9fafb) : const Color(0xFF111827),
              fontFamily: 'Poppins',
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        final hour = value.toInt();
                        // Check if hour exists in data
                        if (data.any((d) => d['hour'] == hour)) {
                          final timeStr = hour > 12 ? '${hour - 12}pm' : (hour == 12 ? '12pm' : '${hour}am');
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              timeStr,
                              style: TextStyle(
                                color: isDark ? const Color(0xFF9ca3af) : const Color(0xFF6b7280),
                                fontFamily: 'Poppins',
                                fontSize: 10,
                              ),
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: TextStyle(
                            color: isDark ? const Color(0xFF9ca3af) : const Color(0xFF6b7280),
                            fontFamily: 'Poppins',
                            fontSize: 10,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: data.map((d) {
                  return _makeBarGroup(
                    d['hour'] as int,
                    (d['orders'] as int).toDouble(),
                    isDark,
                  );
                }).toList(),
                minY: 0,
                maxY: 50,
              ),
            ),
          ),
        ],
      ),
    );
  }

  BarChartGroupData _makeBarGroup(int x, double y, bool isDark) {
    return BarChartGroupData(x: x, barRods: [
      BarChartRodData(
        toY: y,
        color: isDark ? const Color(0xFF3cad2a) : const Color(0xFF062c6b),
        width: 24,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
        backDrawRodData: BackgroundBarChartRodData(
          show: true,
          toY: 15,
          color: isDark ? const Color(0xFF0e1116) : const Color(0xFFf3f4f6),
        ),
      )
    ]);
  }

  Widget _buildOrderStatusDistribution(bool isDark, AppSettingsProvider settings) {
    final statusData = [
      {'name': settings.t('pending'), 'value': 25.0, 'color': const Color(0xFFf59e0b)},
      {'name': settings.t('confirmed'), 'value': 35.0, 'color': const Color(0xFF3b82f6)},
      {'name': settings.t('paid'), 'value': 30.0, 'color': const Color(0xFF3cad2a)},
      {'name': settings.t('cancelled'), 'value': 10.0, 'color': const Color(0xFFef4444)},
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1a1f2e) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.05) : Colors.transparent,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withOpacity(0.2) : const Color(0xFF062c6b).withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            settings.t('orderStatus'),
            style: TextStyle(
              color: isDark ? const Color(0xFFf9fafb) : const Color(0xFF111827),
              fontFamily: 'Poppins',
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 200,
            child: Row(
              children: [
                Expanded(
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 4,
                      centerSpaceRadius: 40,
                      sections: statusData.map((data) {
                        return PieChartSectionData(
                          color: data['color'] as Color,
                          value: data['value'] as double,
                          title: '${(data['value'] as double).toInt()}%',
                          radius: 50,
                          titleStyle: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: 'Poppins',
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: statusData.map((data) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: data['color'] as Color,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            data['name'] as String,
                            style: TextStyle(
                              color: isDark ? const Color(0xFFf9fafb) : const Color(0xFF111827),
                              fontSize: 13,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
