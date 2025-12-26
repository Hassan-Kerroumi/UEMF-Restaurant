import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../providers/app_settings_provider.dart';
import '../services/database_service.dart';
import '../data/order_model.dart';
import 'package:intl/intl.dart';

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
      body: StreamBuilder<List<RestaurantOrder>>(
        stream: DatabaseService().getOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          final allOrders = snapshot.data ?? [];
          final filteredOrders = _filterOrdersByPeriod(allOrders);
          
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Key Metrics
                  _buildKeyMetrics(isDark, settings, filteredOrders, allOrders),
                  const SizedBox(height: 24),
                  
                  // Revenue Chart
                  _buildRevenueChart(isDark, settings, filteredOrders),
                  const SizedBox(height: 24),
                  
                  if (timePeriod != 'year') ...[
                    // Most Ordered Items
                    _buildMostOrderedItems(isDark, settings, filteredOrders),
                    const SizedBox(height: 24),
                    
                    // Orders by Time
                    _buildOrdersByTime(isDark, settings, filteredOrders),
                    const SizedBox(height: 24),

                    // Order Status Distribution (Pie Chart)
                    _buildOrderStatusDistribution(isDark, settings, filteredOrders),
                  ],
                  
                  // Bottom padding for floating nav bar
                  const SizedBox(height: 80),
                ],
              ),
            ),
          );
        }
      ),
    );
  }

  List<RestaurantOrder> _filterOrdersByPeriod(List<RestaurantOrder> orders) {
    final now = DateTime.now();
    if (timePeriod == 'month') {
      return orders.where((o) => o.createdAt.month == now.month && o.createdAt.year == now.year).toList();
    } else {
      return orders.where((o) => o.createdAt.year == now.year).toList();
    }
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
  
  Widget _buildKeyMetrics(bool isDark, AppSettingsProvider settings, List<RestaurantOrder> orders, List<RestaurantOrder> allOrders) {
    final isYear = timePeriod == 'year';
    
    // Calculate real metrics
    final totalOrders = orders.length;
    final totalRevenue = orders.fold(0.0, (sum, o) => sum + o.total);
    final activeUsers = orders.map((o) => o.userId).toSet().length;
    
    // Previous period comparison (simplified)
    final now = DateTime.now();
    final prevOrders = allOrders.where((o) {
      if (isYear) {
        return o.createdAt.year == now.year - 1;
      } else {
        return o.createdAt.month == now.month - 1 && o.createdAt.year == now.year;
      }
    }).toList();
    
    final prevTotalOrders = prevOrders.length;
    final orderGrowth = prevTotalOrders == 0 ? 100.0 : ((totalOrders - prevTotalOrders) / prevTotalOrders * 100);
    
    final metrics = [
      {
        'title': settings.t('totalOrders'),
        'value': NumberFormat.compact().format(totalOrders),
        'subtitle': '${orderGrowth >= 0 ? '+' : ''}${orderGrowth.toStringAsFixed(0)}% ${settings.t('comparisonWithLast')} ${isYear ? settings.t('year') : settings.t('month')}',
        'color': const Color(0xFF3cad2a),
        'icon': Icons.shopping_bag_rounded,
        'growth': orderGrowth,
      },
      {
        'title': settings.t('revenue'),
        'value': '${NumberFormat.compact().format(totalRevenue)} MAD',
        'subtitle': '${totalRevenue > 0 ? '+' : ''}10% ${settings.t('fromYesterday')}', // Simplified
        'color': const Color(0xFF062c6b),
        'icon': Icons.trending_up_rounded,
        'growth': 10.0,
      },
      {
        'title': settings.t('avgWaitTime'),
        'value': '15m', // Mocked as we don't have completion time
        'subtitle': '-2m ${settings.t('fromYesterday')}',
        'color': const Color(0xFFf59e0b),
        'icon': Icons.schedule_rounded,
        'growth': -5.0,
      },
      {
        'title': settings.t('activeUsers'),
        'value': activeUsers.toString(),
        'subtitle': '+${activeUsers > 0 ? activeUsers : 0} ${settings.t('newUsers')}',
        'color': const Color(0xFF8b5cf6),
        'icon': Icons.people_rounded,
        'growth': 5.0,
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
        final growth = metric['growth'] as double;
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
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: (growth >= 0 ? const Color(0xFF3cad2a) : Colors.red).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          growth >= 0 ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded, 
                          size: 10, 
                          color: growth >= 0 ? const Color(0xFF3cad2a) : Colors.red
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '${growth.abs().toStringAsFixed(0)}%',
                          style: TextStyle(
                            color: growth >= 0 ? const Color(0xFF3cad2a) : Colors.red,
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
  
  Widget _buildRevenueChart(bool isDark, AppSettingsProvider settings, List<RestaurantOrder> orders) {
    final isYear = timePeriod == 'year';
    
    // Group orders by month or day
    final Map<int, double> revenueData = {};
    final Map<int, int> customerData = {};
    
    for (var order in orders) {
      final key = isYear ? order.createdAt.month : order.createdAt.day;
      revenueData[key] = (revenueData[key] ?? 0) + order.total;
      customerData[key] = (customerData[key] ?? 0) + 1;
    }
    
    final List<FlSpot> revenueSpots = [];
    final List<FlSpot> customerSpots = [];
    
    if (isYear) {
      for (int i = 1; i <= 12; i++) {
        revenueSpots.add(FlSpot(i.toDouble(), (revenueData[i] ?? 0) / 1000)); // in thousands
        customerSpots.add(FlSpot(i.toDouble(), (customerData[i] ?? 0).toDouble()));
      }
    } else {
      final daysInMonth = DateTime(DateTime.now().year, DateTime.now().month + 1, 0).day;
      for (int i = 1; i <= daysInMonth; i++) {
        revenueSpots.add(FlSpot(i.toDouble(), (revenueData[i] ?? 0) / 100)); // scaled for visibility
        customerSpots.add(FlSpot(i.toDouble(), (customerData[i] ?? 0).toDouble()));
      }
    }

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
                    '${settings.t('revenue')} (scaled)',
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
                  horizontalInterval: isYear ? 10 : 1,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: isYear ? 1 : 5,
                      getTitlesWidget: (value, meta) {
                        if (isYear) {
                          final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
                          int idx = value.toInt() - 1;
                          if (idx >= 0 && idx < 12) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(months[idx], style: TextStyle(color: isDark ? const Color(0xFF9ca3af) : const Color(0xFF6b7280), fontSize: 10)),
                            );
                          }
                        } else {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(value.toInt().toString(), style: TextStyle(color: isDark ? const Color(0xFF9ca3af) : const Color(0xFF6b7280), fontSize: 10)),
                          );
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
                        return Text(value.toInt().toString(), style: TextStyle(color: isDark ? const Color(0xFF9ca3af) : const Color(0xFF6b7280), fontSize: 10));
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: revenueSpots.isEmpty ? [const FlSpot(0, 0)] : revenueSpots,
                    isCurved: true,
                    color: const Color(0xFF3cad2a),
                    barWidth: 4,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [const Color(0xFF3cad2a).withOpacity(0.2), const Color(0xFF3cad2a).withOpacity(0.0)],
                      ),
                    ),
                  ),
                  LineChartBarData(
                    spots: customerSpots.isEmpty ? [const FlSpot(0, 0)] : customerSpots,
                    isCurved: true,
                    color: isDark ? const Color(0xFF9ca3af) : const Color(0xFF062c6b),
                    barWidth: 3,
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
  
  Widget _buildMostOrderedItems(bool isDark, AppSettingsProvider settings, List<RestaurantOrder> orders) {
    final Map<String, int> itemCounts = {};
    for (var order in orders) {
      for (var item in order.items.values) {
        final name = (item['name'] is Map) 
            ? (item['name'][settings.language] ?? item['name']['en']) 
            : item['name'].toString();
        final quantity = (item['quantity'] as num?)?.toInt() ?? 1;
        itemCounts[name] = (itemCounts[name] ?? 0) + 1; // Count number of orders, not total quantity
      }
    }

    final allItems = itemCounts.entries
        .map((e) => {'name': e.key, 'count': e.value})
        .toList()
      ..sort((a, b) => (b['count'] as int).compareTo(a['count'] as int));

    if (allItems.isEmpty) return const SizedBox();

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
          if (allItems.length > 5)
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
  
  Widget _buildOrdersByTime(bool isDark, AppSettingsProvider settings, List<RestaurantOrder> orders) {
    final Map<int, int> hourlyCounts = {};
    for (var order in orders) {
      final hour = order.createdAt.hour;
      hourlyCounts[hour] = (hourlyCounts[hour] ?? 0) + 1;
    }

    final List<Map<String, dynamic>> hourlyData = [];
    for (int i = 8; i <= 21; i++) {
      hourlyData.add({'hour': i, 'orders': hourlyCounts[i] ?? 0});
    }

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

  Widget _buildOrderStatusDistribution(bool isDark, AppSettingsProvider settings, List<RestaurantOrder> orders) {
    final Map<String, int> statusCounts = {};
    for (var order in orders) {
      statusCounts[order.status] = (statusCounts[order.status] ?? 0) + 1;
    }

    final total = orders.length.toDouble();
    if (total == 0) return const SizedBox();

    final statusData = [
      {'name': settings.t('pending'), 'value': ((statusCounts['pending'] ?? 0) / total * 100), 'color': const Color(0xFFf59e0b)},
      {'name': settings.t('accepted'), 'value': ((statusCounts['accepted'] ?? 0) / total * 100), 'color': const Color(0xFF3b82f6)},
      {'name': settings.t('refused'), 'value': ((statusCounts['refused'] ?? 0) / total * 100), 'color': const Color(0xFFef4444)},
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
