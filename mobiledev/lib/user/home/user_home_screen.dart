import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_settings_provider.dart';
import '../../providers/cart_provider.dart';
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
          'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?auto=format&fit=crop&w=500&q=60', // Placeholder usage if we had network images
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar: "Restaurant App" + Actions
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Restaurant App',
                    style: TextStyle(
                      color: Color(0xFF3cad2a),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      // Language Selector Icon
                      PopupMenuButton<String>(
                        icon: const Icon(Icons.language),
                        onSelected: (String value) {
                          settings.setLanguage(value);
                        },
                        itemBuilder: (BuildContext context) =>
                            <PopupMenuEntry<String>>[
                              const PopupMenuItem<String>(
                                value: 'en',
                                child: Text('English'),
                              ),
                              const PopupMenuItem<String>(
                                value: 'fr',
                                child: Text('Français'),
                              ),
                              const PopupMenuItem<String>(
                                value: 'ar',
                                child: Text('العربية'),
                              ),
                            ],
                      ),
                      IconButton(
                        icon: Icon(
                          isDark
                              ? Icons.light_mode_outlined
                              : Icons.dark_mode_outlined,
                        ),
                        onPressed: () => settings.toggleTheme(),
                      ),
                      IconButton(
                        icon: const Icon(Icons.logout),
                        onPressed: () => _handleLogout(context),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF062c6b), Color(0xFF0a4099)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                settings.t('welcome'),
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Ahmed Ali',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                settings.t('creditBalance'),
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                '\$125.5',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Search Bar
                    TextField(
                      controller: _searchController,
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black,
                      ),
                      decoration: InputDecoration(
                        hintText: '${settings.t('search')}...',
                        hintStyle: TextStyle(
                          color: isDark ? Colors.grey[500] : Colors.grey[600],
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: isDark ? Colors.grey[500] : Colors.grey[600],
                        ),
                        filled: true,
                        fillColor: isDark
                            ? const Color(0xFF1F2430)
                            : Colors.grey[200], // Light grey for light mode
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                    ),

                    const SizedBox(height: 24),

                    // Categories Header
                    Text(
                      settings.t('categories'),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Categories List (Block Style)
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
                          final catName =
                              cat['name'][settings.language] ?? cat['id'];

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedCategory = cat['id'];
                              });
                            },
                            child: Container(
                              width: 100,
                              decoration: BoxDecoration(
                                    color: isSelected
                                        ? const Color(0xFF3cad2a)
                                        : (isDark
                                            ? const Color(0xFF1F2430)
                                            : Colors.white),
                                    borderRadius: BorderRadius.circular(16),
                                    border: isSelected
                                        ? null
                                        : Border.all(
                                            color: isDark
                                                ? Colors.grey.withOpacity(0.1)
                                                : Colors.grey.withOpacity(0.2),
                                          ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        cat['icon'],
                                        style: const TextStyle(fontSize: 28),
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
                                                  : Colors.black),
                                          fontWeight: isSelected
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                          fontSize: 12,
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

                    // Suggestions (Only if All Categories is selected, or always? Figma has it separate)
                    // The user screenshot shows products grid directly below.
                    // But previous request asked for suggestions. I'll keep them but maybe smaller or less intrusive?
                    // Let's stick to the grid first as per screenshot focus.

                    // Products Grid
                    GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.8, // Taller cards
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
                              color: isDark
                                  ? const Color(0xFF1F2430)
                                  : Colors.white, // Dark card bg
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: isDark
                                  ? null
                                  : [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.1),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
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
                                        ? Colors.grey[800]
                                        : Colors.grey[100],
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product['name'][settings.language],
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: isDark
                                                ? Colors.white
                                                : Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const Spacer(),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '\$${product['price']}',
                                              style: const TextStyle(
                                                color: Color(0xFF3cad2a),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.all(4),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFF3cad2a),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: const Icon(
                                                Icons.add,
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
                    const SizedBox(height: 100), // Bottom padding for FAB
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
