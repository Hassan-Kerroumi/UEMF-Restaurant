import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../providers/app_settings_provider.dart';
import '../services/database_service.dart';
import '../data/meal_model.dart';

class AdminProductsScreen extends StatefulWidget {
  const AdminProductsScreen({super.key});

  @override
  State<AdminProductsScreen> createState() => _AdminProductsScreenState();
}

class _AdminProductsScreenState extends State<AdminProductsScreen> {
  String searchQuery = '';
  String? selectedCategory;
  final ImagePicker _picker = ImagePicker();
  final DatabaseService _db = DatabaseService();
  final bool _isLoading = false;
 

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
          settings.t('products'),
          style: TextStyle(
            color: isDark ? const Color(0xFF3cad2a) : const Color(0xFF062c6b),
            fontSize: 24,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: IconButton(
              onPressed: _addNewProduct,
              style: IconButton.styleFrom(
                backgroundColor: isDark ? const Color(0xFF3cad2a).withOpacity(0.1) : const Color(0xFF062c6b).withOpacity(0.1),
                padding: const EdgeInsets.all(12),
              ),
              icon: Icon(
                Icons.add_circle_rounded,
                color: isDark ? const Color(0xFF3cad2a) : const Color(0xFF062c6b),
                size: 24,
              ),
            ),
          ),
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
              _buildCategories(isDark, settings),
              const SizedBox(height: 24),
              
              // Products Grid
              _buildProductsGrid(isDark, settings),
              
              // Bottom padding for floating nav bar
              const SizedBox(height: 80),
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
          hintText: '${settings.t('search')}...',
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
            vertical: 14,
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
    final categories = settings.categories;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          settings.t('categories'),
          style: TextStyle(
            color: isDark ? const Color(0xFFf9fafb) : const Color(0xFF1a1a1a),
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 44,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
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
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected 
                        ? (isDark ? const Color(0xFF3cad2a) : const Color(0xFF062c6b)) 
                        : (isDark ? const Color(0xFF1a1f2e) : Colors.white),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected 
                        ? Colors.transparent
                        : (isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05)),
                    ),
                    boxShadow: [
                      if (isSelected)
                        BoxShadow(
                          color: (isDark ? const Color(0xFF3cad2a) : const Color(0xFF062c6b)).withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                    ],
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
      ],
    );
  }
  
  Widget _buildProductsGrid(bool isDark, AppSettingsProvider settings) {
    return StreamBuilder<List<Meal>>(
      stream: _db.getMeals(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        
        final allProducts = snapshot.data ?? [];
        final filteredProducts = allProducts.where((product) {
          final matchesSearch = (product.name['en'] ?? '').toLowerCase().contains(searchQuery.toLowerCase()) ||
                              (product.name['fr'] ?? '').toLowerCase().contains(searchQuery.toLowerCase()) ||
                              (product.name['ar'] ?? '').toLowerCase().contains(searchQuery.toLowerCase());
          final matchesCategory = selectedCategory == null || selectedCategory == 'all' || product.category == selectedCategory;
          return matchesSearch && matchesCategory;
        }).toList();

        if (filteredProducts.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Text(
                settings.t('noProductsFound'),
                style: TextStyle(
                  color: isDark ? Colors.white70 : Colors.black54,
                  fontSize: 16,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          );
        }
        
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.75,
          ),
          itemCount: filteredProducts.length,
          itemBuilder: (context, index) {
            return _buildProductCard(filteredProducts[index], isDark);
          },
        );
      },
    );
  }
  
  // In lib/admin/admin_products_screen.dart

  // 1. Helper to handle network images, base64, and placeholders cleanly
  Widget _buildProductImage(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return Container(
        width: double.infinity,
        color: Colors.grey.withOpacity(0.1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.fastfood_rounded, size: 40, color: Colors.grey.withOpacity(0.5)),
            const SizedBox(height: 4),
            Text("No Image", style: TextStyle(color: Colors.grey.withOpacity(0.5), fontSize: 10)),
          ],
        ),
      );
    }

    try {
      // Handle Base64 images (if any)
      if (imageUrl.startsWith('data:image')) {
        return Image.memory(
          base64Decode(imageUrl.split(',')[1]),
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.broken_image_rounded)),
        );
      }
      // Handle Network images (Firebase/Unsplash)
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: SizedBox(
              width: 20, height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.grey),
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                    : null,
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          // If the URL is bad, show a broken link icon
          return Center(child: Icon(Icons.broken_image_rounded, color: Colors.grey.withOpacity(0.5)));
        },
      );
    } catch (e) {
      return const Center(child: Icon(Icons.error_outline_rounded));
    }
  }

  // 2. The Creative Card Design
  Widget _buildProductCard(Meal product, bool isDark) {
    final settings = Provider.of<AppSettingsProvider>(context, listen: false);
    
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1a1f2e) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Area (Top 60%)
                Expanded(
                  flex: 3,
                  child: _buildProductImage(product.imageUrl),
                ),
                
                // Info Area (Bottom 40%)
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Category Badge
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: (isDark ? const Color(0xFF3cad2a) : const Color(0xFF062c6b)).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                product.category.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? const Color(0xFF3cad2a) : const Color(0xFF062c6b),
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            // Product Name
                            Text(
                              product.name[settings.language] ?? product.name['en'] ?? '',
                              style: TextStyle(
                                color: isDark ? const Color(0xFFf9fafb) : const Color(0xFF1a1a1a),
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Poppins',
                                height: 1.1,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        // Price
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: TextStyle(
                            color: isDark ? const Color(0xFF3cad2a) : const Color(0xFF062c6b),
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Floating Edit/Delete Actions (Glassmorphism)
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () => _editProduct(product),
                      child: const Padding(
                        padding: EdgeInsets.all(4),
                        child: Icon(Icons.edit_rounded, size: 14, color: Colors.white),
                      ),
                    ),
                    Container(width: 1, height: 12, color: Colors.white.withOpacity(0.3), margin: const EdgeInsets.symmetric(horizontal: 4)),
                    InkWell(
                      onTap: () => _deleteProduct(product),
                      child: const Padding(
                        padding: EdgeInsets.all(4),
                        child: Icon(Icons.delete_rounded, size: 14, color: Color(0xFFff6b6b)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Icon(icon, size: 16, color: color),
      ),
    );
  }
  
  void _addNewProduct() {
    final nameController = TextEditingController();
    final nameFrController = TextEditingController();
    final nameArController = TextEditingController();
    final descriptionController = TextEditingController();
    final priceController = TextEditingController();
    String selectedCat = 'hot-drinks';
    Uint8List? selectedImageBytes;
    String? selectedImageName;
    bool isSaving = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          final settings = Provider.of<AppSettingsProvider>(context, listen: false);
          final isDark = settings.isDarkMode;

          return AlertDialog(
            backgroundColor: isDark ? const Color(0xFF1a1f2e) : Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Text(
              settings.t('addNewProduct'),
              style: TextStyle(
                color: isDark ? const Color(0xFFf9fafb) : const Color(0xFF1a1a1a),
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Image Picker
                  GestureDetector(
                    onTap: () async {
                      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                      if (image != null) {
                        final bytes = await image.readAsBytes();
                        setDialogState(() {
                          selectedImageBytes = bytes;
                          selectedImageName = image.name;
                        });
                      }
                    },
                    child: Container(
                      height: 150,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF0e1116) : Colors.grey[100],
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05),
                        ),
                        image: selectedImageBytes != null
                                ? DecorationImage(
                                    image: MemoryImage(selectedImageBytes!),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: selectedImageBytes == null
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_a_photo_rounded,
                                  size: 40,
                                  color: const Color(0xFF9ca3af).withOpacity(0.5),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  settings.t('uploadImage'),
                                  style: TextStyle(
                                    color: const Color(0xFF9ca3af).withOpacity(0.8),
                                    fontSize: 12,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ],
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  _buildTextField('${settings.t('productName')} (English)', nameController, isDark),
                  const SizedBox(height: 12),
                  _buildTextField('${settings.t('productName')} (French)', nameFrController, isDark),
                  const SizedBox(height: 12),
                  _buildTextField('${settings.t('productName')} (Arabic)', nameArController, isDark),
                  const SizedBox(height: 12),
                  _buildTextField(settings.t('price'), priceController, isDark, keyboardType: TextInputType.number),
                  const SizedBox(height: 12),
                  
                  // Category Dropdown
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF0e1116) : Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDark ? Colors.white.withOpacity(0.1) : Colors.transparent,
                      ),
                    ),
                    child: DropdownButton<String>(
                      value: selectedCat,
                      isExpanded: true,
                      dropdownColor: isDark ? const Color(0xFF1a1f2e) : Colors.white,
                      style: TextStyle(
                        color: isDark ? const Color(0xFFf9fafb) : const Color(0xFF1a1a1a),
                        fontFamily: 'Poppins',
                      ),
                      underline: const SizedBox(),
                      items: settings.categories
                          .where((c) => c['id'] != 'all')
                          .map((cat) => DropdownMenuItem<String>(
                                value: cat['id'] as String,
                                child: Text((cat['name'] as Map<String, String>)[settings.language] ?? ''),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setDialogState(() {
                            selectedCat = value;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  settings.t('cancel'),
                  style: const TextStyle(color: Color(0xFF9ca3af), fontFamily: 'Poppins'),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark ? const Color(0xFF3cad2a) : const Color(0xFF062c6b),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                onPressed: isSaving ? null : () async {
                  if (nameController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter a name'), backgroundColor: Colors.orange),
                    );
                    return;
                  }
                  final price = double.tryParse(priceController.text.trim());
                  if (price == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter a valid price'), backgroundColor: Colors.orange),
                    );
                    return;
                  }
                  
                  setDialogState(() => isSaving = true);
                  final messenger = ScaffoldMessenger.of(context);
                  
                  try {
                    // Create basic meal object without image first
                    final newMeal = Meal(
                      id: '', // Will be assigned by Firebase
                      name: {
                        'en': nameController.text,
                        'fr': nameFrController.text,
                        'ar': nameArController.text,
                      },
                      description: {'en': descriptionController.text.trim()}, 
                      price: price,
                      category: selectedCat,
                      imageUrl: null,
                    );
                    
                    // Add meal to database with image
                    await _db.addMeal(newMeal, imageBytes: selectedImageBytes, imageName: selectedImageName);
                    
                    if (context.mounted) {
                      Navigator.pop(context);
                      messenger.showSnackBar(
                        SnackBar(
                          content: Text(settings.t('productAdded')),
                          backgroundColor: const Color(0xFF3cad2a),
                        ),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      setDialogState(() => isSaving = false);
                      messenger.showSnackBar(
                        SnackBar(
                          content: Text('Error: $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
                child: isSaving 
                  ? const SizedBox(
                      height: 24, 
                      width: 24, 
                      child: CircularProgressIndicator(
                        color: Colors.white, 
                        strokeWidth: 3,
                      )
                    )
                  : Text(settings.t('save'), style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600)),
              ),
            ],
          );
        },
      ),
    );
  }
  
  void _editProduct(Meal product) {
    final nameController = TextEditingController(text: product.name['en']);
    final nameFrController = TextEditingController(text: product.name['fr']);
    final nameArController = TextEditingController(text: product.name['ar']);
    final descriptionController = TextEditingController(text: product.description['en'] ?? product.description['fr'] ?? '');
    final priceController = TextEditingController(text: product.price.toString());
    String selectedCat = product.category;
    Uint8List? selectedImageBytes;
    String? selectedImageName;
    String? currentImageUrl = product.imageUrl;
    bool isSaving = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          final settings = Provider.of<AppSettingsProvider>(context, listen: false);
          final isDark = settings.isDarkMode;

          return AlertDialog(
            backgroundColor: isDark ? const Color(0xFF1a1f2e) : Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Text(
              settings.t('editProduct'),
              style: TextStyle(
                color: isDark ? const Color(0xFFf9fafb) : const Color(0xFF1a1a1a),
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Image Picker
                  GestureDetector(
                    onTap: () async {
                      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                      if (image != null) {
                        final bytes = await image.readAsBytes();
                        setDialogState(() {
                          selectedImageBytes = bytes;
                          selectedImageName = image.name;
                        });
                      }
                    },
                    child: Container(
                      height: 150,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF0e1116) : Colors.grey[100],
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05),
                        ),
                        image: selectedImageBytes != null
                            ? DecorationImage(
                                image: MemoryImage(selectedImageBytes!),
                                fit: BoxFit.cover,
                              )
                            : (currentImageUrl != null
                                ? DecorationImage(
                                    image: NetworkImage(currentImageUrl),
                                    fit: BoxFit.cover,
                                  )
                                : null),
                      ),
                      child: (selectedImageBytes == null && currentImageUrl == null)
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_a_photo_rounded,
                                  size: 40,
                                  color: const Color(0xFF9ca3af).withOpacity(0.5),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  settings.t('changeImage'),
                                  style: TextStyle(
                                    color: const Color(0xFF9ca3af).withOpacity(0.8),
                                    fontSize: 12,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ],
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  _buildTextField('${settings.t('productName')} (English)', nameController, isDark),
                  const SizedBox(height: 12),
                  _buildTextField('${settings.t('productName')} (French)', nameFrController, isDark),
                  const SizedBox(height: 12),
                  _buildTextField('${settings.t('productName')} (Arabic)', nameArController, isDark),
                  const SizedBox(height: 12),
                  _buildTextField(settings.t('price'), priceController, isDark, keyboardType: TextInputType.number),
                  const SizedBox(height: 12),
                  
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF0e1116) : Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDark ? Colors.white.withOpacity(0.1) : Colors.transparent,
                      ),
                    ),
                    child: DropdownButton<String>(
                      value: selectedCat,
                      isExpanded: true,
                      dropdownColor: isDark ? const Color(0xFF1a1f2e) : Colors.white,
                      style: TextStyle(
                        color: isDark ? const Color(0xFFf9fafb) : const Color(0xFF1a1a1a),
                        fontFamily: 'Poppins',
                      ),
                      underline: const SizedBox(),
                      items: settings.categories
                          .where((c) => c['id'] != 'all')
                          .map((cat) => DropdownMenuItem<String>(
                                value: cat['id'] as String,
                                child: Text((cat['name'] as Map<String, String>)[settings.language] ?? ''),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setDialogState(() {
                            selectedCat = value;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  settings.t('cancel'),
                  style: const TextStyle(color: Color(0xFF9ca3af), fontFamily: 'Poppins'),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark ? const Color(0xFF3cad2a) : const Color(0xFF062c6b),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                onPressed: isSaving ? null : () async {
                  if (nameController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter a name'), backgroundColor: Colors.orange),
                    );
                    return;
                  }
                  final price = double.tryParse(priceController.text.trim());
                  if (price == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter a valid price'), backgroundColor: Colors.orange),
                    );
                    return;
                  }
                  
                  setDialogState(() => isSaving = true);
                  final messenger = ScaffoldMessenger.of(context);
                  
                  try {
                    final updatedMeal = product.copyWith(
                      name: {
                        'en': nameController.text,
                        'fr': nameFrController.text,
                        'ar': nameArController.text,
                      },
                      description: product.description.isEmpty 
                          ? {'en': descriptionController.text.trim()}
                          : {...product.description, 'en': descriptionController.text.trim()},
                      price: price,
                      category: selectedCat,
                    );
                    
                    await _db.updateMeal(product.id, updatedMeal, newImageBytes: selectedImageBytes, newImageName: selectedImageName);
                    
                    if (context.mounted) {
                      Navigator.pop(context);
                      messenger.showSnackBar(
                        SnackBar(
                          content: Text(settings.t('productUpdated')),
                          backgroundColor: const Color(0xFF3cad2a),
                        ),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      setDialogState(() => isSaving = false);
                      messenger.showSnackBar(
                        SnackBar(
                          content: Text('Error: $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
                child: isSaving 
                  ? const SizedBox(
                      height: 24, 
                      width: 24, 
                      child: CircularProgressIndicator(
                        color: Colors.white, 
                        strokeWidth: 3,
                      )
                    )
                  : Text(settings.t('save'), style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600)),
              ),
            ],
          );
        },
      ),
    );
  }

  void _deleteProduct(Meal product) {
    final settings = Provider.of<AppSettingsProvider>(context, listen: false);
    final isDark = settings.isDarkMode;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1a1f2e) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          settings.t('deleteProduct'),
          style: TextStyle(
            color: isDark ? const Color(0xFFf9fafb) : const Color(0xFF1a1a1a),
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          '${settings.t('deleteConfirmation')} "${product.name[settings.language] ?? product.name['en']}"?',
          style: TextStyle(
            color: isDark ? Colors.white70 : Colors.black87,
            fontFamily: 'Poppins',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              settings.t('cancel'),
              style: const TextStyle(color: Color(0xFF9ca3af), fontFamily: 'Poppins'),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await _db.deleteMeal(product.id);
                
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(settings.t('productDeleted')),
                      backgroundColor: const Color(0xFF3cad2a),
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error deleting product: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFef4444),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text(settings.t('delete'), style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
  
  Widget _buildTextField(String label, TextEditingController controller, bool isDark, {TextInputType? keyboardType, int maxLines = 1}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: TextStyle(
        color: isDark ? const Color(0xFFf9fafb) : const Color(0xFF1a1a1a),
        fontFamily: 'Poppins',
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          color: Color(0xFF9ca3af),
          fontFamily: 'Poppins',
        ),
        filled: true,
        fillColor: isDark ? const Color(0xFF0e1116) : Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? const Color(0xFF3cad2a) : const Color(0xFF062c6b),
            width: 1.5,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }
}
