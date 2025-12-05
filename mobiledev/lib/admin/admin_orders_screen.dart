import 'package:flutter/material.dart';

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
    return Scaffold(
      backgroundColor: const Color(0xFF0e1116),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1a1f2e),
        elevation: 0,
        title: const Text(
          'All Orders',
          style: TextStyle(
            color: Color(0xFFc74242),
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFFc74242),
          unselectedLabelColor: const Color(0xFF9ca3af),
          indicatorColor: const Color(0xFFc74242),
          labelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          tabs: const [
            Tab(text: 'PENDING'),
            Tab(text: 'ACCEPTED'),
            Tab(text: 'REFUSED'),
            Tab(text: 'CANCELLED'),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search
            Padding(
              padding: const EdgeInsets.all(16),
              child: _buildSearchBar(),
            ),
            
            // Tab Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildOrdersList('pending'),
                  _buildOrdersList('accepted'),
                  _buildOrdersList('refused'),
                  _buildOrdersList('cancelled'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1a1f2e),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: TextField(
        style: const TextStyle(color: Color(0xFFf9fafb)),
        decoration: InputDecoration(
          hintText: 'Search orders...',
          hintStyle: const TextStyle(color: Color(0xFF9ca3af)),
          prefixIcon: const Icon(Icons.search, color: Color(0xFF9ca3af), size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        onChanged: (value) {
          setState(() {
            searchQuery = value;
          });
        },
      ),
    );
  }

  Widget _buildOrdersList(String status) {
    // Mock data
    final orders = _getMockOrders(status);

    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 80,
              color: const Color(0xFF9ca3af).withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'No ${status} orders',
              style: const TextStyle(
                color: Color(0xFF9ca3af),
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        return _buildOrderCard(orders[index]);
      },
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order) {
    final status = order['status'] as String;
    final items = order['items'] as List<Map<String, dynamic>>;
    final totalPrice = items.fold<double>(
      0.0,
      (sum, item) => sum + ((item['price'] as double) * (item['quantity'] as int)),
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1a1f2e),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _getStatusColor(status).withOpacity(0.2)),
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
                  const Icon(Icons.person, color: Color(0xFF9ca3af), size: 18),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order['studentName'] as String,
                        style: const TextStyle(
                          color: Color(0xFFf9fafb),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        order['date'] as String,
                        style: const TextStyle(
                          color: Color(0xFF9ca3af),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              _buildStatusBadge(status),
            ],
          ),
          const SizedBox(height: 16),

          // Items
          ...items.map((item) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF9ca3af).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFF9ca3af).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.restaurant,
                        color: Color(0xFF9ca3af),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['name'] as String,
                            style: const TextStyle(
                              color: Color(0xFFf9fafb),
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            'Qty: ${item['quantity']} × \$${item['price']}',
                            style: const TextStyle(
                              color: Color(0xFF9ca3af),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '\$${((item['price'] as double) * (item['quantity'] as int)).toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Color(0xFFf9fafb),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              )),

          const Divider(color: Color(0xFF9ca3af), height: 24),

          // Footer
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.access_time, color: Color(0xFF9ca3af), size: 14),
                  const SizedBox(width: 4),
                  Text(
                    order['pickupTime'] as String,
                    style: const TextStyle(
                      color: Color(0xFF9ca3af),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    order['type'] as String,
                    style: const TextStyle(
                      color: Color(0xFF9ca3af),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              Text(
                '\$${totalPrice.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: Color(0xFFf9fafb),
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getStatusColor(status).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _getStatusColor(status).withOpacity(0.2)),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: _getStatusColor(status),
          fontSize: 12,
          fontWeight: FontWeight.w500,
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
