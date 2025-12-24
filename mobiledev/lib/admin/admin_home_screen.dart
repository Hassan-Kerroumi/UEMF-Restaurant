import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_settings_provider.dart';
import '../login/login_screen.dart';
import 'message_dialog.dart';
import '../services/database_service.dart';
import '../data/order_model.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  String searchQuery = '';
  String selectedCategory = 'all';

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<AppSettingsProvider>(context);
    final isDark = settings.isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0e1116) : const Color(0xFFf5f5f5),
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF1a1f2e) : Colors.white,
        elevation: isDark ? 0 : 1,
        title: Text(
          settings.t('ordersOfTheDay'),
          style: TextStyle(
            color: isDark ? const Color(0xFF3cad2a) : const Color(0xFF062c6b),
            fontSize: 20,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: isDark ? Colors.white : Colors.black),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<List<RestaurantOrder>>(
        stream: DatabaseService().getOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final allOrders = snapshot.data ?? [];

          // Filter for active orders (pending/accepted) and by search
          final filteredOrders = allOrders.where((order) {
            final matchesSearch = order.studentName.toLowerCase().contains(searchQuery.toLowerCase()) ||
                order.id.toLowerCase().contains(searchQuery.toLowerCase());

            // Only show relevant statuses for "Orders of the Day"
            final isActive = ['pending', 'accepted', 'ready'].contains(order.status.toLowerCase());

            return matchesSearch && isActive;
          }).toList();

          return Column(
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  onChanged: (value) => setState(() => searchQuery = value),
                  style: TextStyle(color: isDark ? Colors.white : Colors.black),
                  decoration: InputDecoration(
                    hintText: settings.t('search'),
                    hintStyle: TextStyle(color: isDark ? Colors.grey : Colors.grey[600]),
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    filled: true,
                    fillColor: isDark ? const Color(0xFF1a1f2e) : Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),

              // Orders List
              Expanded(
                child: filteredOrders.isEmpty
                    ? Center(
                  child: Text(
                    'No active orders found',
                    style: TextStyle(color: isDark ? Colors.grey : Colors.grey[600]),
                  ),
                )
                    : ListView.builder(
                  padding: const EdgeInsets.only(bottom: 100),
                  itemCount: filteredOrders.length,
                  itemBuilder: (context, index) {
                    return _buildOrderCard(filteredOrders[index], isDark, settings);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildOrderCard(RestaurantOrder order, bool isDark, AppSettingsProvider settings) {
    // FIX: Safely convert price and quantity using (x as num).toDouble()
    final totalItems = order.items.values.fold(0, (sum, item) {
      final quantity = (item['quantity'] as num?)?.toInt() ?? 1;
      return sum + quantity;
    });

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1a1f2e) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ExpansionTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Colors.transparent,
        collapsedBackgroundColor: Colors.transparent,
        tilePadding: const EdgeInsets.all(16),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: order.status == 'pending'
                ? const Color(0xFFf59e0b).withOpacity(0.1)
                : const Color(0xFF3cad2a).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            order.status == 'pending' ? Icons.timer_outlined : Icons.check_circle_outline,
            color: order.status == 'pending' ? const Color(0xFFf59e0b) : const Color(0xFF3cad2a),
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                order.studentName,
                style: TextStyle(
                  color: isDark ? Colors.white : const Color(0xFF1a1a1a),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
            Text(
              '${order.pickupTime} ${order.pickupTime.toLowerCase().contains('m') ? '' : ''}',
              style: TextStyle(
                color: isDark ? const Color(0xFF3cad2a) : const Color(0xFF062c6b),
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              '$totalItems items • \$${order.total.toStringAsFixed(2)} • ${order.type}',
              style: TextStyle(
                color: isDark ? Colors.grey[400] : Colors.grey[600],
                fontSize: 13,
                fontFamily: 'Poppins',
              ),
            ),
            if (order.status == 'pending')
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFf59e0b).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Pending Action',
                    style: TextStyle(
                      color: const Color(0xFFf59e0b),
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
          ],
        ),
        children: [
          const Divider(),
          ...order.items.entries.map((entry) {
            final item = entry.value as Map<String, dynamic>;
            final itemName = (item['name'] is Map)
                ? (item['name'][settings.language] ?? item['name']['en'])
                : item['name'].toString();

            // FIX: Safely parse numbers here too
            final price = (item['price'] as num?)?.toDouble() ?? 0.0;
            final quantity = (item['quantity'] as num?)?.toInt() ?? 1;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Text(
                    '${quantity}x',
                    style: TextStyle(
                      color: isDark ? const Color(0xFF3cad2a) : const Color(0xFF062c6b),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      itemName,
                      style: TextStyle(
                        color: isDark ? Colors.white70 : Colors.black87,
                      ),
                    ),
                  ),
                  Text(
                    '\$${(price * quantity).toStringAsFixed(2)}',
                    style: TextStyle(
                      color: isDark ? Colors.white70 : Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 16),
          if (order.status == 'pending')
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _showRefuseDialog(order, settings, isDark),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFef4444),
                      side: const BorderSide(color: Color(0xFFef4444)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text(settings.t('refuse')),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _suggestTime(order.toJson()),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFf59e0b),
                      side: const BorderSide(color: Color(0xFFf59e0b)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text(settings.t('suggestTime')),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      DatabaseService().updateOrderStatus(order.id, 'accepted');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3cad2a),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text(settings.t('accept')),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  void _showRefuseDialog(RestaurantOrder order, AppSettingsProvider settings, bool isDark) {
    final feedbackController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: isDark ? const Color(0xFF1a1f2e) : Colors.white,
          title: Text(settings.t('refuseOrder'), style: TextStyle(color: isDark ? Colors.white : Colors.black)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(settings.t('refuseReason'), style: TextStyle(color: isDark ? Colors.grey : Colors.grey[700])),
              const SizedBox(height: 10),
              TextField(
                controller: feedbackController,
                decoration: InputDecoration(
                  hintText: "e.g., Out of stock",
                  filled: true,
                  fillColor: isDark ? const Color(0xFF0e1116) : Colors.grey[100],
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  contentPadding: const EdgeInsets.all(12),
                ),
                style: TextStyle(fontSize: 14, color: isDark ? Colors.white : Colors.black),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(settings.t('cancel')),
            ),
            ElevatedButton(
              onPressed: () {
                final feedback = feedbackController.text.trim();
                Navigator.pop(context);
                DatabaseService().updateOrderStatus(order.id, 'refused', feedback: feedback);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${settings.t('orderFrom')} ${order.studentName} refused'),
                    backgroundColor: const Color(0xFFef4444),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFef4444),
                foregroundColor: Colors.white,
              ),
              child: Text(settings.t('refuse')),
            ),
          ],
        );
      },
    );
  }

  void _suggestTime(Map<String, dynamic> orderData) {
    showDialog(
      context: context,
      builder: (context) => MessageDialog(order: orderData),
    );
  }
}