import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_settings_provider.dart';
import '../login/login_screen.dart';
import '../services/database_service.dart';
import '../data/order_model.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  String searchQuery = '';
  String selectedStatus = 'all';

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
          // Language Selector
          PopupMenuButton<String>(
            icon: Icon(
              Icons.language_rounded,
              color: isDark ? const Color(0xFFf9fafb) : const Color(0xFF1a1a1a),
            ),
            tooltip: settings.t('changeLanguage'),
            onSelected: (String value) {
              settings.setLanguage(value);
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'en',
                child: Row(
                  children: [
                    const Text('🇬🇧  English'),
                    if (settings.language == 'en') ...[
                      const Spacer(),
                      const Icon(Icons.check_rounded, color: Color(0xFF3cad2a), size: 20),
                    ],
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'fr',
                child: Row(
                  children: [
                    const Text('🇫🇷  Français'),
                    if (settings.language == 'fr') ...[
                      const Spacer(),
                      const Icon(Icons.check_rounded, color: Color(0xFF3cad2a), size: 20),
                    ],
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'ar',
                child: Row(
                  children: [
                    const Text('🇲🇦  العربية'),
                    if (settings.language == 'ar') ...[
                      const Spacer(),
                      const Icon(Icons.check_rounded, color: Color(0xFF3cad2a), size: 20),
                    ],
                  ],
                ),
              ),
            ],
          ),
          
          // Theme Toggle
          IconButton(
            icon: Icon(
              isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
              color: isDark ? const Color(0xFFf9fafb) : const Color(0xFF1a1a1a),
            ),
            tooltip: isDark ? settings.t('lightMode') : settings.t('darkMode'),
            onPressed: () {
              settings.toggleTheme();
            },
          ),
          IconButton(
            icon: Icon(
              Icons.logout_rounded,
              color: isDark ? const Color(0xFFf9fafb) : const Color(0xFF1a1a1a),
            ),
            tooltip: settings.t('logout'),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          ),
          const SizedBox(width: 8),
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
          final now = DateTime.now();
          final filteredOrders = allOrders.where((order) {
            final matchesSearch = order.studentName.toLowerCase().contains(searchQuery.toLowerCase()) ||
                order.id.toLowerCase().contains(searchQuery.toLowerCase());

            // Check if it's today
            final isToday = order.createdAt.year == now.year &&
                order.createdAt.month == now.month &&
                order.createdAt.day == now.day;

            final matchesStatus = selectedStatus == 'all' || order.status == selectedStatus;

            return matchesSearch && isToday && matchesStatus;
          }).toList();

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search Bar
                  _buildSearchBar(isDark, settings),
                  const SizedBox(height: 24),

                  // Categories
                  _buildCategories(isDark, settings),
                  const SizedBox(height: 24),

                  // Orders List
                  filteredOrders.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 100),
                            child: Text(
                              'No orders found for today',
                              style: TextStyle(color: isDark ? Colors.grey : Colors.grey[600]),
                            ),
                          ),
                        )
                      : Column(
                          children: filteredOrders.map((order) => _buildOrderCard(order, isDark, settings)).toList(),
                        ),
                  
                  // Bottom padding for floating nav bar
                  const SizedBox(height: 80),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildOrderCard(RestaurantOrder order, bool isDark, AppSettingsProvider settings) {
    final status = order.status;
    final items = order.items;
    
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
                        order.studentName,
                        style: TextStyle(
                          color: isDark ? const Color(0xFFf9fafb) : const Color(0xFF111827),
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                    ],
                  ),
                ],
              ),
              _buildStatusBadge(status, settings),
            ],
          ),
          const SizedBox(height: 20),
          
          // Items
          ...items.entries.map((entry) {
            final item = entry.value as Map<String, dynamic>;
            final quantity = (item['quantity'] as num?)?.toInt() ?? 1;
            final price = (item['price'] as num?)?.toDouble() ?? 0.0;
            final itemName = (item['name'] is Map)
                ? (item['name'][settings.language] ?? item['name']['en'])
                : item['name'].toString();

            return Padding(
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
                        '${quantity}x',
                        style: TextStyle(
                          color: isDark ? const Color(0xFF3cad2a) : const Color(0xFF062c6b),
                          fontWeight: FontWeight.bold,
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
                          itemName,
                          style: TextStyle(
                            color: isDark ? const Color(0xFFf9fafb) : const Color(0xFF111827),
                            fontFamily: 'Poppins',
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              '${price.toStringAsFixed(2)} MAD',
                              style: TextStyle(
                                color: isDark ? const Color(0xFF9ca3af) : const Color(0xFF6b7280),
                                fontFamily: 'Poppins',
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(width: 4, height: 4, decoration: BoxDecoration(color: isDark ? Colors.white24 : Colors.black26, shape: BoxShape.circle)),
                            const SizedBox(width: 8),
                            Icon(Icons.schedule_rounded, size: 12, color: isDark ? Colors.white54 : Colors.black54),
                            const SizedBox(width: 4),
                            Text(
                              order.pickupTime,
                              style: TextStyle(
                                color: isDark ? Colors.white54 : Colors.black54,
                                fontSize: 12,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(width: 4, height: 4, decoration: BoxDecoration(color: isDark ? Colors.white24 : Colors.black26, shape: BoxShape.circle)),
                            const SizedBox(width: 8),
                            Text(
                              order.type,
                              style: TextStyle(
                                color: isDark ? Colors.white54 : Colors.black54,
                                fontSize: 12,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (status == 'pending')
                    IconButton(
                      onPressed: () => DatabaseService().removeItemFromOrder(order.id, entry.key),
                      icon: const Icon(Icons.close_rounded, size: 20),
                      color: const Color(0xFFef4444),
                      style: IconButton.styleFrom(
                        backgroundColor: const Color(0xFFef4444).withOpacity(0.1),
                        padding: const EdgeInsets.all(8),
                      ),
                    ),
                ],
              ),
            );
          }),
          
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
                    order.pickupTime,
                    style: TextStyle(
                      color: isDark ? const Color(0xFF9ca3af) : const Color(0xFF6b7280),
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
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
                    order.type,
                    style: TextStyle(
                      color: isDark ? const Color(0xFF9ca3af) : const Color(0xFF6b7280),
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Text(
                '${order.total.toStringAsFixed(2)} MAD',
                style: TextStyle(
                  color: isDark ? const Color(0xFF3cad2a) : const Color(0xFF062c6b),
                  fontFamily: 'Poppins',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
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
                    onPressed: () {
                      DatabaseService().updateOrderStatus(order.id, 'accepted');
                    },
                    icon: const Icon(Icons.check_circle_rounded, size: 16),
                    label: Text(settings.t('accept')),
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
                    onPressed: () => _showRefuseDialog(order, settings, isDark),
                    icon: const Icon(Icons.cancel_rounded, size: 16),
                    label: Text(settings.t('refuse')),
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
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSearchBar(bool isDark, AppSettingsProvider settings) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1a1f2e) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withOpacity(0.2) : const Color(0xFF062c6b).withOpacity(0.05),
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
          hintText: settings.t('search'),
          hintStyle: const TextStyle(
            color: Color(0xFF9ca3af),
            fontFamily: 'Poppins',
          ),
          prefixIcon: const Icon(
            Icons.search_rounded,
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

  Widget _buildCategories(bool isDark, AppSettingsProvider settings) {
    final statuses = [
      {'id': 'all', 'name': settings.t('all'), 'icon': Icons.all_inbox_rounded},
      {'id': 'pending', 'name': settings.t('pending'), 'icon': Icons.schedule_rounded},
      {'id': 'accepted', 'name': settings.t('accepted'), 'icon': Icons.check_circle_rounded},
      {'id': 'refused', 'name': settings.t('refused'), 'icon': Icons.cancel_rounded},
    ];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          settings.t('filterByStatus'),
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
            itemCount: statuses.length,
            separatorBuilder: (context, index) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final status = statuses[index];
              final isSelected = selectedStatus == status['id'];
              
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedStatus = status['id'] as String;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected 
                        ? (isDark ? const Color(0xFF3cad2a) : const Color(0xFF062c6b))
                        : (isDark ? const Color(0xFF1a1f2e) : Colors.white),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected 
                        ? (isDark ? const Color(0xFF3cad2a).withOpacity(0.2) : const Color(0xFF062c6b).withOpacity(0.2))
                        : (isDark 
                            ? Colors.white.withOpacity(0.1) 
                            : Colors.black.withOpacity(0.1)),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        status['icon'] as IconData,
                        size: 20,
                        color: isSelected 
                            ? Colors.white 
                            : (isDark ? const Color(0xFFf9fafb) : const Color(0xFF1a1a1a)),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        status['name'] as String,
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

  Widget _buildStatusBadge(String status, AppSettingsProvider settings) {
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
        settings.t(status).toUpperCase(),
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

  void _showRefuseDialog(RestaurantOrder order, AppSettingsProvider settings, bool isDark) {
    final messageController = TextEditingController();
    String? selectedTime;
    final List<String> timeSlots = [
      '08:00', '08:30', '09:00', '09:30', '10:00', '10:30',
      '11:00', '11:30', '12:00', '12:30', '13:00', '13:30',
      '14:00', '14:30', '15:00', '15:30', '16:00', '16:30',
      '17:00', '17:30', '18:00',
    ];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: isDark ? const Color(0xFF1a1f2e) : Colors.white,
              title: Text(settings.t('respondToOrder'), style: TextStyle(color: isDark ? Colors.white : Colors.black)),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(settings.t('suggestAlternativeTime'), style: TextStyle(color: isDark ? Colors.grey : Colors.grey[700], fontSize: 13)),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF0e1116) : Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButton<String>(
                        value: selectedTime,
                        hint: Text(settings.t('selectTimeSlot'), style: const TextStyle(fontSize: 14)),
                        isExpanded: true,
                        dropdownColor: isDark ? const Color(0xFF1a1f2e) : Colors.white,
                        underline: const SizedBox(),
                        items: timeSlots.map((time) => DropdownMenuItem(value: time, child: Text(time))).toList(),
                        onChanged: (value) => setDialogState(() => selectedTime = value),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(settings.t('message'), style: TextStyle(color: isDark ? Colors.grey : Colors.grey[700], fontSize: 13)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: messageController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: settings.t('typeMessage'),
                        filled: true,
                        fillColor: isDark ? const Color(0xFF0e1116) : Colors.grey[100],
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                        contentPadding: const EdgeInsets.all(12),
                      ),
                      style: TextStyle(fontSize: 14, color: isDark ? Colors.white : Colors.black),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(settings.t('cancel'), style: const TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  onPressed: () {
                    final message = messageController.text.trim();
                    final timeInfo = selectedTime != null ? ' (${settings.t('suggestedTime')}: $selectedTime)' : '';
                    Navigator.pop(context);
                    DatabaseService().updateOrderStatus(order.id, 'refused', feedback: '$message$timeInfo');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${settings.t('orderFrom')} ${order.studentName} refused'), backgroundColor: const Color(0xFFef4444)),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFef4444), 
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text(settings.t('refuse')),
                ),
              ],
            );
          },
        );
      },
    );
  }
}