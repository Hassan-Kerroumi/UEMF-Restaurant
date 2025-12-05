import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_settings_provider.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  String searchQuery = '';
  String? selectedCategory;
  
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
            color: const Color(0xFFc74242),
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          // Language Selector
          PopupMenuButton<String>(
            icon: Icon(
              Icons.language,
              color: isDark ? const Color(0xFFf9fafb) : const Color(0xFF1a1a1a),
            ),
            tooltip: 'Change Language',
            onSelected: (String value) {
              settings.setLanguage(value);
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'en',
                child: Row(
                  children: [
                    Text('🇬🇧  English'),
                    if (settings.language == 'en') ...[
                      const Spacer(),
                      const Icon(Icons.check, color: Color(0xFF3cad2a), size: 20),
                    ],
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'fr',
                child: Row(
                  children: [
                    Text('🇫🇷  Français'),
                    if (settings.language == 'fr') ...[
                      const Spacer(),
                      const Icon(Icons.check, color: Color(0xFF3cad2a), size: 20),
                    ],
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'ar',
                child: Row(
                  children: [
                    Text('🇲🇦  العربية'),
                    if (settings.language == 'ar') ...[
                      const Spacer(),
                      const Icon(Icons.check, color: Color(0xFF3cad2a), size: 20),
                    ],
                  ],
                ),
              ),
            ],
          ),
          
          // Theme Toggle
          IconButton(
            icon: Icon(
              isDark ? Icons.light_mode : Icons.dark_mode,
              color: isDark ? const Color(0xFFf9fafb) : const Color(0xFF1a1a1a),
            ),
            tooltip: isDark ? 'Light Mode' : 'Dark Mode',
            onPressed: () {
              settings.toggleTheme();
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search
              _buildSearchBar(),
              const SizedBox(height: 24),
              
              // Categories
              _buildCategories(),
              const SizedBox(height: 24),
              
              // Orders List
              _buildOrdersList(),
            ],
          ),
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
        style: const TextStyle(
          color: Color(0xFFf9fafb),
          fontFamily: 'Poppins',
        ),
        decoration: InputDecoration(
          hintText: 'Search',
          hintStyle: TextStyle(
            color: const Color(0xFF9ca3af),
            fontFamily: 'Poppins',
          ),
          prefixIcon: const Icon(
            Icons.search,
            color: Color(0xFF9ca3af),
            size: 20,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
        onChanged: (value) {
          setState(() {
            searchQuery = value;
          });
        },
      ),
    );
  }
  
  Widget _buildCategories() {
    final settings = Provider.of<AppSettingsProvider>(context);
    final isDark = settings.isDarkMode;
    final categories = settings.categories;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          settings.t('categories'),
          style: TextStyle(
            color: isDark ? const Color(0xFFf9fafb) : const Color(0xFF1a1a1a),
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 50,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            separatorBuilder: (context, index) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final category = categories[index];
              final isSelected = selectedCategory == category['id'];
              final categoryName = (category['name'] as Map<String, String>)[settings.language] ?? '';
              
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedCategory = isSelected ? null : category['id'] as String;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected 
                        ? const Color(0xFFc74242) 
                        : (isDark ? const Color(0xFF1a1f2e) : Colors.white),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected 
                        ? const Color(0xFFc74242).withOpacity(0.2)
                        : (isDark 
                            ? Colors.white.withOpacity(0.1) 
                            : Colors.black.withOpacity(0.1)),
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        category['icon'] as String,
                        style: const TextStyle(fontSize: 20),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        categoryName,
                        style: TextStyle(
                          color: isSelected 
                              ? Colors.white 
                              : (isDark ? const Color(0xFFf9fafb) : const Color(0xFF1a1a1a)),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
  
  Widget _buildOrdersList() {
    // Mock data
    final orders = [
      {
        'id': '1',
        'studentName': 'Ahmed Ali',
        'status': 'pending',
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
        'pickupTime': '13:00',
        'type': 'pickup',
        'items': [
          {'name': 'Cappuccino', 'price': 6.0, 'quantity': 1},
        ],
      },
    ];
    
    return Column(
      children: orders.map((order) => _buildOrderCard(order)).toList(),
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
                  Text(
                    order['studentName'] as String,
                    style: const TextStyle(
                      color: Color(0xFFf9fafb),
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              _buildStatusBadge(status),
            ],
          ),
          const SizedBox(height: 16),
          
          // Items
          ...items.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFF9ca3af).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
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
                          fontFamily: 'Poppins',
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        'Qty: ${item['quantity']} × \$${item['price']}',
                        style: const TextStyle(
                          color: Color(0xFF9ca3af),
                          fontFamily: 'Poppins',
                          fontSize: 12,
                        ),
                      ),
                    ],
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
                      fontFamily: 'Poppins',
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    order['type'] as String,
                    style: const TextStyle(
                      color: Color(0xFF9ca3af),
                      fontFamily: 'Poppins',
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              Text(
                '\$${totalPrice.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: Color(0xFFf9fafb),
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          
          // Action buttons for pending orders
          if (status == 'pending') ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _acceptOrder(order),
                    icon: const Icon(Icons.check, size: 16),
                    label: const Text('Accept'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3cad2a),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _refuseOrder(order),
                    icon: const Icon(Icons.close, size: 16),
                    label: const Text('Refuse'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFef4444),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () => _suggestTime(order),
                  icon: const Icon(Icons.message),
                  color: const Color(0xFFf9fafb),
                  style: IconButton.styleFrom(
                    backgroundColor: const Color(0xFF1a1f2e),
                    side: BorderSide(color: Colors.white.withOpacity(0.1)),
                  ),
                ),
              ],
            ),
          ],
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
        border: Border.all(
          color: _getStatusColor(status).withOpacity(0.2),
        ),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: _getStatusColor(status),
          fontFamily: 'Poppins',
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
        return const Color(0xFF3cad2a);
      case 'refused':
        return const Color(0xFFef4444);
      default:
        return const Color(0xFF9ca3af);
    }
  }
  
  void _acceptOrder(Map<String, dynamic> order) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Order from ${order['studentName']} accepted'),
        backgroundColor: const Color(0xFF3cad2a),
      ),
    );
  }
  
  void _refuseOrder(Map<String, dynamic> order) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Order from ${order['studentName']} refused'),
        backgroundColor: const Color(0xFFef4444),
      ),
    );
  }
  
  void _suggestTime(Map<String, dynamic> order) {
    final messageController = TextEditingController();
    String? selectedTime;
    
    final timeSlots = [
      '08:00', '08:30', '09:00', '09:30', '10:00', '10:30',
      '11:00', '11:30', '12:00', '12:30', '13:00', '13:30',
      '14:00', '14:30', '15:00', '15:30', '16:00', '16:30',
      '17:00', '17:30', '18:00',
    ];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            backgroundColor: const Color(0xFF1a1f2e),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Send Message',
                  style: TextStyle(
                    color: Color(0xFFf9fafb),
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'To: ${order['studentName']}',
                  style: const TextStyle(
                    color: Color(0xFF9ca3af),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Suggested Time Section
                  const Text(
                    'Suggest Alternative Time (Optional)',
                    style: TextStyle(
                      color: Color(0xFFf9fafb),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0e1116),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.1),
                      ),
                    ),
                    child: DropdownButton<String>(
                      value: selectedTime,
                      hint: const Text(
                        'Select time slot...',
                        style: TextStyle(color: Color(0xFF9ca3af)),
                      ),
                      isExpanded: true,
                      dropdownColor: const Color(0xFF1a1f2e),
                      style: const TextStyle(
                        color: Color(0xFFf9fafb),
                        fontSize: 14,
                      ),
                      underline: const SizedBox(),
                      items: timeSlots.map((time) {
                        return DropdownMenuItem(
                          value: time,
                          child: Text(time),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setDialogState(() {
                          selectedTime = value;
                        });
                      },
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Message Section
                  const Text(
                    'Message',
                    style: TextStyle(
                      color: Color(0xFFf9fafb),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF0e1116),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.1),
                      ),
                    ),
                    child: TextField(
                      controller: messageController,
                      maxLines: 4,
                      maxLength: 200,
                      style: const TextStyle(
                        color: Color(0xFFf9fafb),
                        fontSize: 14,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Type your message here...',
                        hintStyle: TextStyle(
                          color: Color(0xFF9ca3af),
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(12),
                        counterStyle: TextStyle(
                          color: Color(0xFF9ca3af),
                          fontSize: 12,
                        ),
                      ),
                      onChanged: (value) {
                        setDialogState(() {});
                      },
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Info box
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3cad2a).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xFF3cad2a).withOpacity(0.2),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: const Color(0xFF3cad2a).withOpacity(0.7),
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'The student will receive your message as a notification',
                            style: TextStyle(
                              color: const Color(0xFF3cad2a).withOpacity(0.9),
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  messageController.dispose();
                  Navigator.pop(context);
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Color(0xFF9ca3af)),
                ),
              ),
              ElevatedButton.icon(
                onPressed: messageController.text.trim().isEmpty
                    ? null
                    : () {
                        final message = messageController.text.trim();
                        final timeInfo = selectedTime != null 
                            ? ' (Suggested time: $selectedTime)'
                            : '';
                        
                        Navigator.pop(context);
                        
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Message sent to ${order['studentName']}$timeInfo',
                            ),
                            backgroundColor: const Color(0xFF3cad2a),
                            duration: const Duration(seconds: 3),
                          ),
                        );
                        
                        messageController.dispose();
                      },
                icon: const Icon(Icons.send, size: 18),
                label: const Text('Send Message'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFc74242),
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: const Color(0xFF9ca3af).withOpacity(0.3),
                  disabledForegroundColor: const Color(0xFF9ca3af),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
