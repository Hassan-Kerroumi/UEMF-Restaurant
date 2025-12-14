import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_settings_provider.dart';

import 'product_details_sheet.dart';
import '../../login/login_screen.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  String _selectedCategory = 'all';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  // Mock Products
  final List<Map<String, dynamic>> _allProducts = [
    {
      'id': '1',
      'name': {'en': 'Burger', 'fr': 'Burger', 'ar': 'برغر'},
      'price': 12.5,
      'category': 'sandwiches',
      'icon': '🍔',
      'image':
          'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?auto=format&fit=crop&w=500&q=60',
    },
    {
      'id': '2',
      'name': {
        'en': 'Pizza Margherita',
        'fr': 'Pizza Margherita',
        'ar': 'بيتزا مارغريتا',
      },
      'price': 15.0,
      'category': 'pizza-pasta',
      'icon': '🍕',
    },
    {
      'id': '3',
      'name': {'en': 'Coffee', 'fr': 'Café', 'ar': 'قهوة'},
      'price': 3.5,
      'category': 'hot-drinks',
      'icon': '☕',
    },
    {
      'id': '4',
      'name': {'en': 'Ice Cream', 'fr': 'Glace', 'ar': 'مثلجات'},
      'price': 5.0,
      'category': 'cakes-desserts',
      'icon': '🍨',
    },
    {
      'id': '5',
      'name': {'en': 'Salad', 'fr': 'Salade', 'ar': 'سلطة'},
      'price': 8.0,
      'category': 'salads',
      'icon': '🥗',
    },
  ];

  void _showProductDetails(Map<String, dynamic> product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ProductDetailsSheet(product: product),
    );
  }

  void _handleLogout(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<AppSettingsProvider>(context);
    final isDark = settings.isDarkMode;

    // Filter Products
    final filteredProducts = _allProducts.where((product) {
      final name = (product['name'][settings.language] as String).toLowerCase();
      final category = product['category'] as String;

      final matchesSearch = name.contains(_searchQuery.toLowerCase());
      final matchesCategory =
          _selectedCategory == 'all' || category == _selectedCategory;

      return matchesSearch && matchesCategory;
    }).toList();

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF0e1116)
          : const Color(0xFFf5f5f5),
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF1a1f2e) : Colors.white,
        elevation: isDark ? 0 : 1,
        title: Text(
          settings.t('restaurantApp'),
          style: TextStyle(
            color: isDark ? const Color(0xFF3cad2a) : const Color(0xFF062c6b),
            fontSize: 20,
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins',
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(
              Icons.language_rounded,
              color: isDark ? const Color(0xFFf9fafb) : const Color(0xFF1a1a1a),
            ),
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
                      const Icon(
                        Icons.check_rounded,
                        color: Color(0xFF3cad2a),
                        size: 20,
                      ),
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
                      const Icon(
                        Icons.check_rounded,
                        color: Color(0xFF3cad2a),
                        size: 20,
                      ),
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
                      const Icon(
                        Icons.check_rounded,
                        color: Color(0xFF3cad2a),
                        size: 20,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          IconButton(
            icon: Icon(
              isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
              color: isDark ? const Color(0xFFf9fafb) : const Color(0xFF1a1a1a),
            ),
            onPressed: () => settings.toggleTheme(),
          ),
          IconButton(
            icon: Icon(
              Icons.logout_rounded,
              color: isDark ? const Color(0xFFf9fafb) : const Color(0xFF1a1a1a),
            ),
            onPressed: () => _handleLogout(context),
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
              // Profile Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                        ? [const Color(0xFF1a1f2e), const Color(0xFF0e1116)]
                        : [const Color(0xFF062c6b), const Color(0xFF0a4099)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: (isDark ? Colors.black : const Color(0xFF062c6b))
                          .withOpacity(0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          settings.t('welcome'),
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 14,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Ahmed Ali',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          settings.t('creditBalance'),
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 14,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          '\$125.5',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Search Bar
              Container(
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1a1f2e) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark
                        ? Colors.white.withOpacity(0.1)
                        : Colors.black.withOpacity(0.05),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  style: TextStyle(
                    color: isDark
                        ? const Color(0xFFf9fafb)
                        : const Color(0xFF1a1a1a),
                    fontFamily: 'Poppins',
                  ),
                  decoration: InputDecoration(
                    hintText: '${settings.t('search')}...',
                    hintStyle: TextStyle(
                      color: const Color(0xFF9ca3af),
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
                      _searchQuery = value;
                    });
                  },
                ),
              ),

              const SizedBox(height: 24),

              // Categories Header
              Text(
                settings.t('categories'),
                style: TextStyle(
                  color: isDark
                      ? const Color(0xFFf9fafb)
                      : const Color(0xFF1a1a1a),
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 12),

              // Categories List
              SizedBox(
                height: 100,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: settings.categories.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final cat = settings.categories[index];
                    final isSelected = _selectedCategory == cat['id'];
                    final catName = cat['name'][settings.language] ?? cat['id'];

                    IconData iconData;
                    switch (cat['id']) {
                      case 'all':
                        iconData = Icons.restaurant_outlined;
                        break;
                      case 'hot-drinks':
                        iconData = Icons.coffee_outlined;
                        break;
                      case 'cold-drinks':
                        iconData = Icons.icecream_outlined;
                        break;
                      case 'cakes-desserts':
                        iconData = Icons.cake_outlined;
                        break;
                      case 'breakfast':
                        iconData = Icons.bakery_dining_outlined;
                        break;
                      case 'pizza-pasta':
                        iconData = Icons.local_pizza_outlined;
                        break;
                      case 'dishes':
                        iconData = Icons.dinner_dining_outlined;
                        break;
                      case 'sandwiches':
                        iconData = Icons.lunch_dining_outlined;
                        break;
                      case 'salads':
                        iconData = Icons.rice_bowl_outlined;
                        break;
                      case 'dairy':
                        // Material Checkroom is a hanger, not dairy.
                        // local_drink is a cup.
                        // Let's use local_drink for now or find better?
                        iconData = Icons.local_drink_outlined;
                        break;
                      case 'snacks':
                        iconData = Icons.cookie_outlined;
                        break;
                      default:
                        iconData = Icons.fastfood_outlined;
                    }

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedCategory = cat['id'];
                        });
                      },
                      child: Container(
                        width: 100,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF3cad2a)
                              : (isDark
                                    ? const Color(0xFF1a1f2e)
                                    : Colors.white),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? Colors.transparent
                                : (isDark
                                      ? Colors.white.withOpacity(0.1)
                                      : Colors.black.withOpacity(0.05)),
                          ),
                          boxShadow: [
                            if (!isSelected)
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              iconData,
                              size: 32,
                              color: isSelected
                                  ? Colors.white
                                  : (isDark
                                        ? Colors.white
                                        : const Color(0xFF1a1a1a)),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              catName,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : (isDark
                                          ? Colors.white
                                          : const Color(0xFF1a1a1a)),
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                                fontSize: 12,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),

              // Products Grid
              GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.8,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = filteredProducts[index];
                  return GestureDetector(
                    onTap: () => _showProductDetails(product),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1a1f2e) : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isDark
                              ? Colors.white.withOpacity(0.05)
                              : Colors.transparent,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: isDark
                                ? Colors.black.withOpacity(0.2)
                                : const Color(0xFF062c6b).withOpacity(0.08),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Image Placeholder
                          Expanded(
                            flex: 3,
                            child: Container(
                              color: isDark
                                  ? const Color(0xFF0e1116)
                                  : const Color(0xFFf3f4f6),
                              child: Center(
                                child: Text(
                                  product['icon'],
                                  style: const TextStyle(fontSize: 48),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product['name'][settings.language],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: isDark
                                          ? const Color(0xFFf9fafb)
                                          : const Color(0xFF111827),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                  const Spacer(),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '\$${product['price']}',
                                        style: TextStyle(
                                          color: isDark
                                              ? const Color(0xFF3cad2a)
                                              : const Color(0xFF062c6b),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF3cad2a),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.add_rounded,
                                          size: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 100), // Bottom padding for FAB and Nav
            ],
          ),
        ),
      ),
    );
  }
}
