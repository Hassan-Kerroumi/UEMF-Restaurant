import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import '../../providers/app_settings_provider.dart';
import '../../services/database_service.dart';
import '../../data/meal_model.dart';
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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showProductDetails(Meal product) {
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

  IconData _getCategoryIcon(String categoryId) {
    switch (categoryId) {
      case 'all':
        return Icons.grid_view_rounded;
      case 'burgers':
        return Icons.lunch_dining_rounded;
      case 'pizza':
        return Icons.local_pizza_rounded;
      case 'platters':
        return Icons.set_meal_rounded;
      case 'sandwiches':
        return Icons.bakery_dining_rounded;
      case 'drinks':
        return Icons.local_drink_rounded;
      default:
        return Icons.restaurant_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<AppSettingsProvider>(context);
    final isDark = settings.isDarkMode;
    final db = DatabaseService();

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0e1116) : const Color(0xFFf5f5f5),
      body: SafeArea(
        child: StreamBuilder<List<Meal>>(
          stream: db.getMeals(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final allProducts = snapshot.data ?? [];
            
            // Filter Products
            final filteredProducts = allProducts.where((product) {
              final name = (product.name[settings.language] ?? product.name['en'] ?? '').toLowerCase();
              final category = product.category;

              final matchesSearch = name.contains(_searchQuery.toLowerCase());
              final matchesCategory = _selectedCategory == 'all' || category == _selectedCategory;

              return matchesSearch && matchesCategory;
            }).toList();

            return RefreshIndicator(
              onRefresh: () async {
                setState(() {});
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                settings.t('welcome'),
                                style: TextStyle(
                                  color: isDark ? const Color(0xFF9ca3af) : const Color(0xFF64748b),
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              Text(
                                'Hungry?',
                                style: TextStyle(
                                  color: isDark ? const Color(0xFFf9fafb) : const Color(0xFF1a1a1a),
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                               PopupMenuButton<String>(
                                icon: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: isDark ? const Color(0xFF1a1f2e) : Colors.white,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isDark ? Colors.white.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.language_rounded,
                                    color: isDark ? const Color(0xFFf9fafb) : const Color(0xFF1a1a1a),
                                    size: 20,
                                  ),
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
                                          const SizedBox(width: 8),
                                          const Icon(Icons.check, color: Color(0xFF3cad2a), size: 16),
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
                                          const SizedBox(width: 8),
                                          const Icon(Icons.check, color: Color(0xFF3cad2a), size: 16),
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
                                          const SizedBox(width: 8),
                                          const Icon(Icons.check, color: Color(0xFF3cad2a), size: 16),
                                        ],
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 12),
                              GestureDetector(
                                onTap: () => _handleLogout(context),
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: isDark ? const Color(0xFF1a1f2e) : Colors.white,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isDark ? Colors.white.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.logout_rounded,
                                    color: Color(0xFFef4444),
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Search Bar
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF1a1f2e) : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isDark ? Colors.white.withOpacity(0.05) : const Color(0xFFe5e7eb),
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
                          onChanged: (value) {
                            setState(() {
                              _searchQuery = value;
                            });
                          },
                          style: TextStyle(
                            color: isDark ? const Color(0xFFf9fafb) : const Color(0xFF1a1a1a),
                            fontFamily: 'Poppins',
                          ),
                          decoration: InputDecoration(
                            icon: Icon(
                              Icons.search_rounded,
                              color: isDark ? const Color(0xFF9ca3af) : const Color(0xFF9ca3af),
                            ),
                            hintText: settings.t('searchPlaceholder') == 'searchPlaceholder' ? 'Search for food...' : settings.t('searchPlaceholder'),
                            hintStyle: TextStyle(
                              color: isDark ? const Color(0xFF9ca3af) : const Color(0xFF9ca3af),
                              fontFamily: 'Poppins',
                            ),
                            border: InputBorder.none,
                            suffixIcon: _searchQuery.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear, size: 20),
                                    onPressed: () {
                                      setState(() {
                                        _searchController.clear();
                                        _searchQuery = '';
                                      });
                                    },
                                  )
                                : null,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Categories
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        settings.t('categories'),
                        style: TextStyle(
                          color: isDark ? const Color(0xFFf9fafb) : const Color(0xFF1a1a1a),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 40,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        children: [
                          _buildCategoryItem('all', settings.t('all'), isDark, icon: Icons.grid_view_rounded),
                          ...settings.categories.map((cat) => _buildCategoryItem(
                                cat['id'] as String,
                                settings.t(cat['id'] as String),
                                isDark,
                                icon: _getCategoryIcon(cat['id'] as String),
                              )),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Popular Items Grid
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            settings.t('popular'),
                            style: TextStyle(
                              color: isDark ? const Color(0xFFf9fafb) : const Color(0xFF1a1a1a),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    if (filteredProducts.isEmpty) 
                      Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(Icons.search_off_rounded, size: 48, color: isDark ? Colors.white24 : Colors.grey[300]),
                              const SizedBox(height: 16),
                              Text(
                                'No items found',
                                style: TextStyle(
                                  color: isDark ? Colors.white54 : Colors.grey[500],
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      GridView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.70, // Optimized for new card design
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: filteredProducts.length,
                        itemBuilder: (context, index) {
                          return _buildProductCard(filteredProducts[index], isDark);
                        },
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // --- Creative Product Card ---
  Widget _buildProductCard(Meal product, bool isDark) {
    final settings = Provider.of<AppSettingsProvider>(context, listen: false);

    return GestureDetector(
      onTap: () => _showProductDetails(product),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1a1f2e) : Colors.white,
          borderRadius: BorderRadius.circular(24), // Softer corners
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Image Area (Expanded)
              Expanded(
                flex: 4,
                child: Stack(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                      child: _buildProductImage(product.imageUrl, isDark),
                    ),
                    // Gradient overlay for depth
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.03),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 2. Info Area
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.name[settings.language] ?? product.name['en'] ?? '',
                            style: TextStyle(
                              color: isDark ? const Color(0xFFf9fafb) : const Color(0xFF1a1a1a),
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Poppins',
                              height: 1.2,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            settings.t(product.category),
                            style: TextStyle(
                              color: isDark ? Colors.grey[400] : Colors.grey[600],
                              fontSize: 11,
                              fontFamily: 'Poppins',
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '\$${product.price.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: isDark ? const Color(0xFF3cad2a) : const Color(0xFF062c6b),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          // "Add" Mini Button
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF3cad2a) : const Color(0xFF062c6b),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.add_rounded, color: Colors.white, size: 18),
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
      ),
    );
  }

  // Helper to handle various image states
  Widget _buildProductImage(String? imageUrl, bool isDark) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return Container(
        color: isDark ? const Color(0xFF0e1116) : const Color(0xFFf3f4f6),
        child: Center(
          child: Icon(
            Icons.fastfood_rounded,
            size: 32,
            color: isDark ? Colors.white24 : Colors.grey[400],
          ),
        ),
      );
    }

    // Check for Base64
    if (imageUrl.startsWith('data:image')) {
      try {
        return Image.memory(
          base64Decode(imageUrl.split(',')[1]),
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _buildErrorImage(isDark),
        );
      } catch (e) {
        return _buildErrorImage(isDark);
      }
    }

    // Network Image with Loading Builder
    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          color: isDark ? const Color(0xFF0e1116) : const Color(0xFFf3f4f6),
          child: Center(
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  isDark ? Colors.white24 : Colors.grey[400]!,
                ),
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                    : null,
              ),
            ),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        // Log the error to debug console if you are developing
        debugPrint('Image load error for $imageUrl: $error');
        return _buildErrorImage(isDark);
      },
    );
  }

  Widget _buildErrorImage(bool isDark) {
    return Container(
      color: isDark ? const Color(0xFF0e1116) : const Color(0xFFf3f4f6),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.broken_image_rounded,
              color: isDark ? Colors.white24 : Colors.grey[400],
              size: 28,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryItem(String id, String label, bool isDark, {IconData? icon}) {
    final isSelected = _selectedCategory == id;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = id;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? const Color(0xFF3cad2a) : const Color(0xFF062c6b))
              : (isDark ? const Color(0xFF1a1f2e) : Colors.white),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? Colors.transparent
                : (isDark ? Colors.white.withOpacity(0.05) : const Color(0xFFe5e7eb)),
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: (isDark ? const Color(0xFF3cad2a) : const Color(0xFF062c6b)).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  )
                ]
              : null,
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 16,
                color: isSelected
                    ? Colors.white
                    : (isDark ? const Color(0xFF9ca3af) : const Color(0xFF64748b)),
              ),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : (isDark ? const Color(0xFFf9fafb) : const Color(0xFF64748b)),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                fontSize: 12,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      ),
    );
  }
}