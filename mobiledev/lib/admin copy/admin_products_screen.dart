import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../providers/app_settings_provider.dart';

class AdminProductsScreen extends StatefulWidget {
  const AdminProductsScreen({super.key});

  @override
  State<AdminProductsScreen> createState() => _AdminProductsScreenState();
}

class _AdminProductsScreenState extends State<AdminProductsScreen> {
  String searchQuery = '';
  String? selectedCategory;
  final ImagePicker _picker = ImagePicker();
  
  // Mock products data (moved to state to allow modification)
  List<Map<String, dynamic>> products = [
    {
      'id': '1',
      'name': 'Espresso',
      'nameFr': 'Espresso',
      'nameAr': 'إسبريسو',
      'category': 'hot-drinks',
      'price': 5.0,
      'image': 'https://images.unsplash.com/photo-1510591509098-f4fdc6d0ff04?w=400',
    },
    {
      'id': '2',
      'name': 'Cappuccino',
      'nameFr': 'Cappuccino',
      'nameAr': 'كابتشينو',
      'category': 'hot-drinks',
      'price': 6.0,
      'image': 'https://images.unsplash.com/photo-1572442388796-11668a67e53d?w=400',
    },
    {
      'id': '3',
      'name': 'Croissant',
      'nameFr': 'Croissant',
      'nameAr': 'كرواسون',
      'category': 'pastry',
      'price': 3.5,
      'image': 'https://images.unsplash.com/photo-1555507036-ab1f4038808a?w=400',
    },
    {
      'id': '4',
      'name': 'Sandwich',
      'nameFr': 'Sandwich',
      'nameAr': 'ساندويتش',
      'category': 'lunch',
      'price': 8.0,
      'image': 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400',
    },
  ];

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
    final filteredProducts = products.where((product) {
      final matchesSearch = (product['name'] as String).toLowerCase().contains(searchQuery.toLowerCase()) ||
                          (product['nameFr'] as String).toLowerCase().contains(searchQuery.toLowerCase()) ||
                          (product['nameAr'] as String).toLowerCase().contains(searchQuery.toLowerCase());
      final matchesCategory = selectedCategory == null || selectedCategory == 'all' || product['category'] == selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
    
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
  }
  
  Widget _buildProductCard(Map<String, dynamic> product, bool isDark) {
    final image = product['image'];
    final isFileImage = image is File;

    return Container(
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
          Stack(
            children: [
              Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF9ca3af).withOpacity(0.1),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                  image: image != null
                      ? DecorationImage(
                          image: isFileImage 
                              ? FileImage(image as File) 
                              : NetworkImage(image as String) as ImageProvider,
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: image == null
                    ? Center(
                        child: Icon(
                          Icons.fastfood_rounded,
                          size: 40,
                          color: const Color(0xFF9ca3af).withOpacity(0.5),
                        ),
                      )
                    : null,
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => _editProduct(product),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.edit_rounded,
                          size: 16,
                          color: Color(0xFF3b82f6),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => _deleteProduct(product),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.delete_rounded,
                          size: 16,
                          color: Color(0xFFef4444),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product['name'] as String,
                  style: TextStyle(
                    color: isDark ? const Color(0xFFf9fafb) : const Color(0xFF1a1a1a),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  (product['category'] as String).toUpperCase(),
                  style: const TextStyle(
                    color: Color(0xFF9ca3af),
                    fontSize: 10,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${product['price']}',
                      style: TextStyle(
                        color: isDark ? const Color(0xFF3cad2a) : const Color(0xFF062c6b),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  void _addNewProduct() {
    final nameController = TextEditingController();
    final nameFrController = TextEditingController();
    final nameArController = TextEditingController();
    final priceController = TextEditingController();
    String selectedCat = 'hot-drinks';
    File? selectedImage;

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
                        setDialogState(() {
                          selectedImage = File(image.path);
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
                        image: selectedImage != null
                            ? DecorationImage(
                                image: FileImage(selectedImage!),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: selectedImage == null
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
                onPressed: () {
                  if (nameController.text.isEmpty || priceController.text.isEmpty) {
                    return;
                  }
                  
                  setState(() {
                    products.add({
                      'id': DateTime.now().millisecondsSinceEpoch.toString(),
                      'name': nameController.text,
                      'nameFr': nameFrController.text,
                      'nameAr': nameArController.text,
                      'category': selectedCat,
                      'price': double.tryParse(priceController.text) ?? 0.0,
                      'image': selectedImage,
                    });
                  });
                  
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(settings.t('productAdded')),
                      backgroundColor: const Color(0xFF3cad2a),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark ? const Color(0xFF3cad2a) : const Color(0xFF062c6b),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: Text(settings.t('save'), style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600)),
              ),
            ],
          );
        },
      ),
    );
  }
  
  void _editProduct(Map<String, dynamic> product) {
    final nameController = TextEditingController(text: product['name']);
    final nameFrController = TextEditingController(text: product['nameFr']);
    final nameArController = TextEditingController(text: product['nameAr']);
    final priceController = TextEditingController(text: product['price'].toString());
    String selectedCat = product['category'];
    dynamic currentImage = product['image'];
    File? newImage;

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
                        setDialogState(() {
                          newImage = File(image.path);
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
                        image: newImage != null
                            ? DecorationImage(
                                image: FileImage(newImage!),
                                fit: BoxFit.cover,
                              )
                            : (currentImage != null
                                ? DecorationImage(
                                    image: currentImage is File 
                                        ? FileImage(currentImage) 
                                        : NetworkImage(currentImage as String) as ImageProvider,
                                    fit: BoxFit.cover,
                                  )
                                : null),
                      ),
                      child: (newImage == null && currentImage == null)
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
                onPressed: () {
                  setState(() {
                    product['name'] = nameController.text;
                    product['nameFr'] = nameFrController.text;
                    product['nameAr'] = nameArController.text;
                    product['price'] = double.tryParse(priceController.text) ?? 0.0;
                    product['category'] = selectedCat;
                    if (newImage != null) {
                      product['image'] = newImage;
                    }
                  });
                  
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(settings.t('productUpdated')),
                      backgroundColor: const Color(0xFF3cad2a),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark ? const Color(0xFF3cad2a) : const Color(0xFF062c6b),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: Text(settings.t('save'), style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600)),
              ),
            ],
          );
        },
      ),
    );
  }
  
  void _deleteProduct(Map<String, dynamic> product) {
    showDialog(
      context: context,
      builder: (context) {
        final settings = Provider.of<AppSettingsProvider>(context, listen: false);
        final isDark = settings.isDarkMode;
        
        return AlertDialog(
          backgroundColor: isDark ? const Color(0xFF1a1f2e) : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            settings.t('delete'),
            style: TextStyle(
              color: isDark ? const Color(0xFFf9fafb) : const Color(0xFF1a1a1a),
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            settings.t('deleteConfirmation'),
            style: const TextStyle(color: Color(0xFF9ca3af), fontFamily: 'Poppins'),
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
              onPressed: () {
                setState(() {
                  products.remove(product);
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${product['name']} ${settings.t('productDeleted')}'),
                    backgroundColor: const Color(0xFFef4444),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFef4444),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(settings.t('delete'), style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600)),
            ),
          ],
        );
      },
    );
  }
  
  Widget _buildTextField(String label, TextEditingController controller, bool isDark, {TextInputType? keyboardType}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
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
