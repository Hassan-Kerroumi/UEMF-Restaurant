import 'package:flutter/material.dart';

class AdminUpcomingScreen extends StatefulWidget {
  const AdminUpcomingScreen({super.key});

  @override
  State<AdminUpcomingScreen> createState() => _AdminUpcomingScreenState();
}

class _AdminUpcomingScreenState extends State<AdminUpcomingScreen> {
  String searchQuery = '';
  String filterType = 'all';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0e1116),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1a1f2e),
        elevation: 0,
        title: const Text(
          'Tomorrow Planned',
          style: TextStyle(
            color: Color(0xFFc74242),
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _addNewMeal,
            icon: const Icon(Icons.add, color: Color(0xFFf9fafb)),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Statistics Cards
              _buildStatistics(),
              const SizedBox(height: 24),

              // Search
              _buildSearchBar(),
              const SizedBox(height: 24),

              // Meal Type Filters
              _buildMealTypeFilters(),
              const SizedBox(height: 24),

              // Orders List
              _buildUpcomingOrders(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatistics() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFc74242), Color(0xFFa53535)],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFc74242).withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Pre-orders',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '24',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF3cad2a), Color(0xFF2d8a20)],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF3cad2a).withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Meals',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '42',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
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
          hintText: 'Search pre-orders...',
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

  Widget _buildMealTypeFilters() {
    final filters = [
      {'id': 'all', 'label': 'All Meals'},
      {'id': 'breakfast', 'label': 'Breakfast'},
      {'id': 'lunch', 'label': 'Lunch'},
      {'id': 'dinner', 'label': 'Dinner'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.filter_list, color: Color(0xFFf9fafb), size: 18),
            SizedBox(width: 8),
            Text(
              'Filter by Meal Type',
              style: TextStyle(
                color: Color(0xFFf9fafb),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: filters.length,
            separatorBuilder: (context, index) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final filter = filters[index];
              final isSelected = filterType == filter['id'];

              return GestureDetector(
                onTap: () {
                  setState(() {
                    filterType = filter['id'] as String;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFFc74242) : const Color(0xFF1a1f2e),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFFc74242).withOpacity(0.2)
                          : Colors.white.withOpacity(0.1),
                    ),
                  ),
                  child: Text(
                    filter['label'] as String,
                    style: TextStyle(
                      color: isSelected ? Colors.white : const Color(0xFFf9fafb),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildUpcomingOrders() {
    // Mock data
    final orders = [
      {
        'id': '1',
        'studentName': 'Ahmed Ali',
        'meal': 'Chicken Sandwich',
        'mealType': 'lunch',
        'timeSlot': '12:30',
        'price': 8.0,
      },
      {
        'id': '2',
        'studentName': 'Sara Ben',
        'meal': 'Croissant & Coffee',
        'mealType': 'breakfast',
        'timeSlot': '09:00',
        'price': 6.5,
      },
      {
        'id': '3',
        'studentName': 'Mohamed Kadi',
        'meal': 'Pasta Carbonara',
        'mealType': 'lunch',
        'timeSlot': '13:00',
        'price': 12.0,
      },
    ];

    return Column(
      children: orders.map((order) => _buildOrderCard(order)).toList(),
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1a1f2e),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          // Meal Icon
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: const Color(0xFF9ca3af).withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.restaurant,
              color: Color(0xFFc74242),
              size: 32,
            ),
          ),
          const SizedBox(width: 16),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.person, color: Color(0xFF9ca3af), size: 16),
                    const SizedBox(width: 4),
                    Text(
                      order['studentName'] as String,
                      style: const TextStyle(
                        color: Color(0xFFf9fafb),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  order['meal'] as String,
                  style: const TextStyle(
                    color: Color(0xFF9ca3af),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.access_time, color: Color(0xFF9ca3af), size: 14),
                        const SizedBox(width: 4),
                        Text(
                          order['timeSlot'] as String,
                          style: const TextStyle(
                            color: Color(0xFF9ca3af),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '\$${order['price']}',
                      style: const TextStyle(
                        color: Color(0xFFf9fafb),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Actions
          Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF3cad2a).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0xFF3cad2a).withOpacity(0.2),
                  ),
                ),
                child: Text(
                  (order['mealType'] as String).toUpperCase(),
                  style: const TextStyle(
                    color: Color(0xFF3cad2a),
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  IconButton(
                    onPressed: () => _editOrder(order),
                    icon: const Icon(Icons.edit, size: 20),
                    color: const Color(0xFF3b82f6),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () => _deleteOrder(order),
                    icon: const Icon(Icons.delete, size: 20),
                    color: const Color(0xFFef4444),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _addNewMeal() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1a1f2e),
        title: const Text(
          'Add Meal to Menu',
          style: TextStyle(color: Color(0xFFf9fafb)),
        ),
        content: const Text(
          'Feature coming soon',
          style: TextStyle(color: Color(0xFF9ca3af)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _editOrder(Map<String, dynamic> order) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Edit order feature coming soon'),
        backgroundColor: Color(0xFF3b82f6),
      ),
    );
  }

  void _deleteOrder(Map<String, dynamic> order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1a1f2e),
        title: const Text(
          'Delete Pre-order',
          style: TextStyle(color: Color(0xFFf9fafb)),
        ),
        content: Text(
          'Remove ${order['meal']} from tomorrow\'s menu?',
          style: const TextStyle(color: Color(0xFF9ca3af)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${order['meal']} removed from menu'),
                  backgroundColor: const Color(0xFFef4444),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFef4444),
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
