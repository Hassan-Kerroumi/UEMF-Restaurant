import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/app_settings_provider.dart';
import '../services/database_service.dart';
import '../data/order_model.dart';

class AdminOrdersScreen extends StatefulWidget {
  const AdminOrdersScreen({super.key});

  @override
  State<AdminOrdersScreen> createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends State<AdminOrdersScreen> {
  String _searchQuery = '';
  String _selectedFilter = 'All'; // All, Pending, Accepted, Refused

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<AppSettingsProvider>(context);
    // Force dark mode colors as per image/design requirement, or adapt if needed.
    // The image shows a dark theme.
    final bool isDark = true;

    return Scaffold(
      backgroundColor: const Color(0xFF0e1116), // Dark background from image
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF0e1116),
        title: Text(
          settings.t('allOrders'),
          style: const TextStyle(
            color: Color(0xFF3cad2a),
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Colors.white),
            onPressed: () => setState(() {}),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              onChanged: (val) => setState(() => _searchQuery = val),
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'Poppins',
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFF1a1f2e),
                hintText: settings.t('searchOrders'),
                hintStyle: TextStyle(
                  color: Colors.grey[600],
                  fontFamily: 'Poppins',
                ),
                prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),

          // Filter Tabs
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _buildFilterChip(
                  'All',
                  Icons.inbox_rounded,
                  const Color(0xFF3cad2a),
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  'pending',
                  Icons.timer_outlined,
                  const Color(0xFFf59e0b),
                ), // Orange/Yellow
                const SizedBox(width: 8),
                _buildFilterChip(
                  'accepted',
                  Icons.check_circle_outline,
                  const Color(0xFF3cad2a),
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  'refused',
                  Icons.cancel_outlined,
                  const Color(0xFFef4444),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Order List
          Expanded(
            child: StreamBuilder<List<RestaurantOrder>>(
              stream: DatabaseService().getOrders(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFF3cad2a)),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                }

                final orders = snapshot.data ?? [];

                // Init filtering
                final filteredOrders = orders.where((order) {
                  // Filter by status
                  if (_selectedFilter != 'All' &&
                      order.status.toLowerCase() !=
                          _selectedFilter.toLowerCase()) {
                    return false;
                  }

                  // Filter by search
                  if (_searchQuery.isNotEmpty) {
                    final search = _searchQuery.toLowerCase();
                    return order.studentName.toLowerCase().contains(search) ||
                        order.id.contains(search);
                  }

                  return true;
                }).toList();

                if (filteredOrders.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inbox_outlined,
                          size: 60,
                          color: Colors.grey[800],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          settings.t('noItemsFound'),
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredOrders.length,
                  itemBuilder: (context, index) {
                    return _buildOrderCard(filteredOrders[index], settings);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, IconData icon, Color color) {
    final isSelected = _selectedFilter.toLowerCase() == label.toLowerCase();

    // Customize label for display
    String displayLabel = label;
    if (label == 'All')
      displayLabel = 'All';
    else
      displayLabel = label[0].toUpperCase() + label.substring(1);

    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? color : const Color(0xFF1a1f2e),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : Colors.white.withOpacity(0.05),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? Colors.white : Colors.white70,
            ),
            const SizedBox(width: 8),
            Text(
              displayLabel,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white70,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderCard(RestaurantOrder order, AppSettingsProvider settings) {
    // Helper to calculate item count
    int itemCount = 0;
    order.items.forEach((key, item) {
      itemCount += (item['quantity'] as num).toInt();
    });

    // Helper for status color
    Color statusColor;
    switch (order.status.toLowerCase()) {
      case 'pending':
        statusColor = const Color(0xFFf59e0b);
        break;
      case 'accepted':
        statusColor = const Color(0xFF3cad2a);
        break;
      case 'refused':
        statusColor = const Color(0xFFef4444);
        break;
      default:
        statusColor = Colors.grey;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1a1f2e),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Avatar + Name + Status Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Color(0xFF0e1116),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.person, color: Colors.white70),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    order.studentName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: statusColor.withOpacity(0.3)),
                ),
                child: Text(
                  order.status.toUpperCase(),
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
          const Divider(color: Colors.white10),
          const SizedBox(height: 16),

          // Items
          ...order.items.entries.map((entry) {
            final item = entry.value;
            final name = item['name'] is Map
                ? (item['name']['en'] ?? item['name'].toString())
                : item['name'].toString();
            final price = (item['price'] as num).toDouble();
            final quantity = (item['quantity'] as num).toInt();

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0e1116),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '${quantity}x',
                      style: const TextStyle(
                        color: Color(0xFF3cad2a),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '\$${price.toStringAsFixed(2)} • ${order.pickupTime} • ${order.type}',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 12,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),

          const SizedBox(height: 8),
          const Divider(color: Colors.white10),
          const SizedBox(height: 12),

          // Footer: Time and Total Price
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.access_time_rounded,
                    size: 16,
                    color: Colors.grey[500],
                  ),
                  const SizedBox(width: 6),
                  Text(
                    order.pickupTime,
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 13,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text('•', style: TextStyle(color: Colors.grey[500])),
                  const SizedBox(width: 8),
                  Text(
                    order.type,
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 13,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
              Text(
                '\$${order.total.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: Color(0xFF3cad2a),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),

          // Action Buttons (Only for Pending)
          if (order.status.toLowerCase() == 'pending')
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => _updateStatus(order.id, 'refused'),
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFFef4444),
                    ),
                    child: const Text('Refuse'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () => _updateStatus(order.id, 'accepted'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3cad2a),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Accept'),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  void _updateStatus(String orderId, String newStatus) {
    DatabaseService().updateOrderStatus(orderId, newStatus);
  }
}
