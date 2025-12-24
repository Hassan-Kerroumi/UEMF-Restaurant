import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_settings_provider.dart';
import '../login/login_screen.dart';
import 'message_dialog.dart';
import '../services/database_service.dart';
import '../data/order_model.dart';
import '../scripts/seed_database.dart';

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
            fontWeight: FontWeight.w500,
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
                    Text('🇬🇧  English'),
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
                    Text('🇫🇷  Français'),
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
                    Text('🇲🇦  العربية'),
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
          
          // Seed Database Button (for testing)
          IconButton(
            icon: Icon(
              Icons.cloud_upload_rounded,
              color: isDark ? const Color(0xFFf9fafb) : const Color(0xFF1a1a1a),
            ),
            tooltip: 'Seed Test Data',
            onPressed: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Seed Test Data?'),
                  content: const Text('This will populate your database with sample users, products, orders, and upcoming menu items.\n\nOnly do this ONCE on a fresh database!'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3cad2a),
                      ),
                      child: const Text('Seed Database'),
                    ),
                  ],
                ),
              );
              
              if (confirmed == true && mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('🌱 Seeding database... Please wait'),
                    duration: Duration(seconds: 2),
                  ),
                );
                
                try {
                  await DatabaseSeeder().seedDatabase();
                  
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('✅ Database seeded successfully!'),
                        backgroundColor: Color(0xFF3cad2a),
                        duration: Duration(seconds: 3),
                      ),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('❌ Error seeding database: $e'),
                        backgroundColor: Colors.red,
                        duration: const Duration(seconds: 5),
                      ),
                    );
                  }
                }
              }
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search
              _buildSearchBar(isDark, settings),
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
                    selectedCategory = isSelected ? 'all' : category['id'] as String;
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
                        category['icon'] as IconData,
                        size: 20,
                        color: isSelected 
                            ? Colors.white 
                            : (isDark ? const Color(0xFFf9fafb) : const Color(0xFF1a1a1a)),
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
    final settings = Provider.of<AppSettingsProvider>(context);
    final isDark = settings.isDarkMode;

    return StreamBuilder<List<RestaurantOrder>>(
      stream: DatabaseService().getOrders(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final orders = snapshot.data ?? [];
        if (orders.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Text(
                'No orders found',
                style: TextStyle(
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          );
        }

        // Apply filters locally (search and category)
        final filteredOrders = orders.where((order) {
          if (searchQuery.isEmpty) return true;
          return order.studentName.toLowerCase().contains(searchQuery.toLowerCase()) ||
                 order.id.contains(searchQuery);
        }).toList();

        // Sort: Pending first, then by date descending
        filteredOrders.sort((a, b) {
          if (a.status == 'pending' && b.status != 'pending') return -1;
          if (a.status != 'pending' && b.status == 'pending') return 1;
          return b.createdAt.compareTo(a.createdAt);
        });

        return Column(
          children: filteredOrders.map((order) {
            // Convert to Map for UI compatibility
            final orderMap = {
              'id': order.id,
              'studentName': order.studentName,
              'status': order.status,
              'pickupTime': order.pickupTime,
              'type': order.type,
              'items': order.items.values.toList(), // Convert map values to list
            };
            return _buildOrderCard(orderMap, isDark);
          }).toList(),
        );
      },
    );
  }
  
  Widget _buildOrderCard(Map<String, dynamic> order, bool isDark) {
    final settings = Provider.of<AppSettingsProvider>(context, listen: false);
    final status = order['status'] as String;
    final items = (order['items'] as List).cast<Map<String, dynamic>>();

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
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${settings.t('orderNumber')}${order['id']}',
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
              _buildStatusBadge(status, settings),
            ],
          ),
          const SizedBox(height: 20),
          
          // Items
          ...items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
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
                        '${item['quantity']}x',
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
                          _getLocalizedName(item['name'], settings),
                          style: TextStyle(
                            color: isDark ? const Color(0xFFf9fafb) : const Color(0xFF111827),
                            fontFamily: 'Poppins',
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '\$${item['price']}',
                          style: TextStyle(
                            color: isDark ? const Color(0xFF9ca3af) : const Color(0xFF6b7280),
                            fontFamily: 'Poppins',
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (status == 'pending')
                    IconButton(
                      onPressed: () => _removeItem(order, index),
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
                    order['pickupTime'] as String,
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
                    order['type'] as String,
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
                '\$${totalPrice.toStringAsFixed(2)}',
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
                    onPressed: () => _acceptOrder(order),
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
                    onPressed: () => _refuseOrder(order),
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
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () => _suggestTime(order),
                  icon: const Icon(Icons.chat_bubble_rounded),
                  color: isDark ? const Color(0xFFf9fafb) : const Color(0xFF1a1a1a),
                  style: IconButton.styleFrom(
                    backgroundColor: isDark ? const Color(0xFF1a1f2e) : Colors.white,
                    side: BorderSide(
                      color: isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05),
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
  
  String _getLocalizedName(dynamic nameData, AppSettingsProvider settings) {
    if (nameData is Map) {
      return nameData[settings.language] ?? nameData['en'] ?? nameData.values.first ?? '';
    }
    return nameData.toString();
  }

  void _removeItem(Map<String, dynamic> order, int index) {
    // TODO: Implement removing item from order in database
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Editing orders not supported yet')),
    );
  }

  void _acceptOrder(Map<String, dynamic> order) {
    showDialog(
      context: context,
      builder: (context) {
        final settings = Provider.of<AppSettingsProvider>(context, listen: false);
        final isDark = settings.isDarkMode;
        
        return AlertDialog(
          backgroundColor: isDark ? const Color(0xFF1a1f2e) : Colors.white,
          title: Text(
            settings.t('accept'),
            style: TextStyle(
              color: isDark ? const Color(0xFFf9fafb) : const Color(0xFF1a1a1a),
            ),
          ),
          content: Text(
            '${settings.t('acceptOrderConfirmation')} ${order['studentName']}?',
            style: TextStyle(
              color: isDark ? const Color(0xFF9ca3af) : Colors.grey[600],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(settings.t('cancel')),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                DatabaseService().updateOrderStatus(order['id'], 'accepted');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${settings.t('orderFrom')} ${order['studentName']} ${settings.t('acceptedSuffix')}'),
                    backgroundColor: const Color(0xFF3cad2a),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3cad2a),
                foregroundColor: Colors.white,
              ),
              child: Text(settings.t('accept')),
            ),
          ],
        );
      },
    );
  }
  
  void _refuseOrder(Map<String, dynamic> order) {
    final TextEditingController feedbackController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) {
        final settings = Provider.of<AppSettingsProvider>(context, listen: false);
        final isDark = settings.isDarkMode;
        
        return AlertDialog(
          backgroundColor: isDark ? const Color(0xFF1a1f2e) : Colors.white,
          title: Text(
            settings.t('refuse'),
            style: TextStyle(
              color: isDark ? const Color(0xFFf9fafb) : const Color(0xFF1a1a1a),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${settings.t('refuseOrderConfirmation')} ${order['studentName']}?',
                style: TextStyle(
                  color: isDark ? const Color(0xFF9ca3af) : Colors.grey[600],
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: feedbackController,
                maxLines: 2,
                decoration: InputDecoration(
                  hintText: 'Reason or alternative suggestion...',
                  hintStyle: TextStyle(fontSize: 14, color: isDark ? Colors.grey[500] : Colors.grey[400]),
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
                DatabaseService().updateOrderStatus(order['id'], 'refused', feedback: feedback);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${settings.t('orderFrom')} ${order['studentName']} ${settings.t('refusedSuffix')}'),
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
  
  void _suggestTime(Map<String, dynamic> order) {
    showDialog(
      context: context,
      builder: (context) => MessageDialog(order: order),
    );
  }
}
