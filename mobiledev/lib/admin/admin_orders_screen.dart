import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_settings_provider.dart';

class AdminOrdersScreen extends StatefulWidget {
  const AdminOrdersScreen({super.key});

  @override
  State<AdminOrdersScreen> createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends State<AdminOrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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
          'All Orders',
          style: TextStyle(
            color: isDark ? const Color(0xFF3cad2a) : const Color(0xFF062c6b),
            fontSize: 24,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0e1116) : const Color(0xFFf3f4f6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: isDark ? const Color(0xFF3cad2a) : const Color(0xFF062c6b),
                boxShadow: [
                  BoxShadow(
                    color: (isDark ? const Color(0xFF3cad2a) : const Color(0xFF062c6b)).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              labelColor: Colors.white,
              unselectedLabelColor: isDark ? const Color(0xFF9ca3af) : const Color(0xFF6b7280),
              labelStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
              ),
              dividerColor: Colors.transparent,
              padding: const EdgeInsets.all(4),
              tabs: const [
                Tab(text: 'PENDING'),
                Tab(text: 'ACCEPTED'),
                Tab(text: 'REFUSED'),
                Tab(text: 'CANCELLED'),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: _buildSearchBar(isDark),
            ),
            
            // Tab Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildOrdersList('pending', isDark),
                  _buildOrdersList('accepted', isDark),
                  _buildOrdersList('refused', isDark),
                  _buildOrdersList('cancelled', isDark),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1a1f2e) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.05) : Colors.transparent,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        style: TextStyle(
          color: isDark ? const Color(0xFFf9fafb) : const Color(0xFF1a1a1a),
          fontFamily: 'Poppins',
        ),
        decoration: InputDecoration(
          hintText: 'Search orders...',
          hintStyle: const TextStyle(
            color: Color(0xFF9ca3af),
            fontFamily: 'Poppins',
          ),
          prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF9ca3af), size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        onChanged: (value) {
          setState(() {
            searchQuery = value;
          });
        },
      ),
    );
  }

  Widget _buildOrdersList(String status, bool isDark) {
    // Mock data
    final orders = _getMockOrders(status);

    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1a1f2e) : Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Icon(
                Icons.inbox_rounded,
                size: 64,
                color: const Color(0xFF9ca3af).withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No ${status.toLowerCase()} orders',
              style: const TextStyle(
                color: Color(0xFF9ca3af),
                fontSize: 16,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        return _buildOrderCard(orders[index], isDark);
      },
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order, bool isDark) {
    final status = order['status'] as String;
    final items = order['items'] as List<Map<String, dynamic>>;
    final totalPrice = items.fold<double>(
      0.0,
      (sum, item) => sum + ((item['price'] as double) * (item['quantity'] as int)),
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1a1f2e) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.05) : Colors.transparent,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withOpacity(0.2) : const Color(0xFF062c6b).withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF0e1116) : const Color(0xFFf3f4f6),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.person_rounded,
                      color: isDark ? const Color(0xFF9ca3af) : const Color(0xFF4b5563),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order['studentName'] as String,
                        style: TextStyle(
                          color: isDark ? const Color(0xFFf9fafb) : const Color(0xFF111827),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        order['date'] as String,
                        style: TextStyle(
                          color: isDark ? const Color(0xFF9ca3af) : const Color(0xFF6b7280),
                          fontSize: 12,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              _buildStatusBadge(status),
            ],
          ),
          const SizedBox(height: 20),

          // Items
          ...items.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF0e1116) : const Color(0xFFf3f4f6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      '${item['quantity']}x',
                      style: TextStyle(
                        color: isDark ? const Color(0xFF3cad2a) : const Color(0xFF062c6b),
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['name'] as String,
                        style: TextStyle(
                          color: isDark ? const Color(0xFFf9fafb) : const Color(0xFF111827),
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      Text(
                        '\$${item['price']}',
                        style: TextStyle(
                          color: isDark ? const Color(0xFF9ca3af) : const Color(0xFF6b7280),
                          fontSize: 13,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '\$${((item['price'] as double) * (item['quantity'] as int)).toStringAsFixed(2)}',
                  style: TextStyle(
                    color: isDark ? const Color(0xFFf9fafb) : const Color(0xFF111827),
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          )),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Divider(
              color: isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05),
              height: 1,
            ),
          ),

          // Footer
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.schedule_rounded,
                    color: isDark ? const Color(0xFF9ca3af) : const Color(0xFF6b7280),
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    order['pickupTime'] as String,
                    style: TextStyle(
                      color: isDark ? const Color(0xFF9ca3af) : const Color(0xFF6b7280),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF4b5563) : const Color(0xFFd1d5db),
                      shape: BoxShape.circle,
                    ),
                  ),
                  Text(
                    order['type'] as String,
                    style: TextStyle(
                      color: isDark ? const Color(0xFF9ca3af) : const Color(0xFF6b7280),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
              Text(
                '\$${totalPrice.toStringAsFixed(2)}',
                style: TextStyle(
                  color: isDark ? const Color(0xFF3cad2a) : const Color(0xFF062c6b),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: _getStatusColor(status).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _getStatusColor(status).withOpacity(0.2)),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: _getStatusColor(status),
          fontSize: 11,
          fontWeight: FontWeight.w600,
          fontFamily: 'Poppins',
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return const Color(0xFFf59e0b);
      case 'accepted':
      case 'confirmed':
        return const Color(0xFF3cad2a);
      case 'refused':
      case 'cancelled':
        return const Color(0xFFef4444);
      default:
        return const Color(0xFF9ca3af);
    }
  }

  List<Map<String, dynamic>> _getMockOrders(String status) {
    final allOrders = [
      {
        'id': '1',
        'studentName': 'Ahmed Ali',
        'status': 'pending',
        'date': '2025-12-05',
        'pickupTime': '12:30',
        'type': 'dine-in',
        'items': [
          {'name': 'Espresso', 'price': 5.0, 'quantity': 2},
          {'name': 'Croissant', 'price': 3.5, 'quantity': 1},
        ],
      },
      {
        'id': '2',
        'studentName': 'Sara Ben',
        'status': 'accepted',
        'date': '2025-12-05',
        'pickupTime': '13:00',
        'type': 'pickup',
        'items': [
          {'name': 'Cappuccino', 'price': 6.0, 'quantity': 1},
          {'name': 'Sandwich', 'price': 8.0, 'quantity': 1},
        ],
      },
      {
        'id': '3',
        'studentName': 'Mohamed Kadi',
        'status': 'refused',
        'date': '2025-12-04',
        'pickupTime': '14:00',
        'type': 'dine-in',
        'items': [
          {'name': 'Latte', 'price': 5.5, 'quantity': 1},
        ],
      },
    ];

    return allOrders.where((order) => order['status'] == status).toList();
  }
}
