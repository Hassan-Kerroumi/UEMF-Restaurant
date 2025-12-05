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
      'category': 'coffee',
      'price': 5.0,
      'image': 'https://images.unsplash.com/photo-1510591509098-f4fdc6d0ff04?w=400',
    },
    {
      'id': '2',
      'name': 'Cappuccino',
      'nameFr': 'Cappuccino',
      'nameAr': 'كابتشينو',
      'category': 'coffee',
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
        elevation: isDark ? 0 : 1,
        title: Text(
          settings.t('products'),
          style: const TextStyle(
            color: Color(0xFFc74242),
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _addNewProduct,
            icon: Icon(
              Icons.add,
              color: isDark ? const Color(0xFFf9fafb) : const Color(0xFF1a1a1a),
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
          color: isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.1),
        ),
      ),
      child: TextField(
        style: TextStyle(
          color: isDark ? const Color(0xFFf9fafb) : const Color(0xFF1a1a1a),
        ),
        decoration: InputDecoration(
          hintText: '${settings.t('search')}...',
          hintStyle: const TextStyle(
            color: Color(0xFF9ca3af),
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
                        : (isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.1)),
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
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.1),
        ),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
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
                  color: const Color(0xFF9ca3af).withOpacity(0.2),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
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
                          Icons.image,
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
                        ),
                        child: const Icon(
                          Icons.edit,
                          size: 16,
                          color: Color(0xFF3b82f6),
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () => _deleteProduct(product),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.delete,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product['name'] as String,
                            style: TextStyle(
                              color: isDark ? const Color(0xFFf9fafb) : const Color(0xFF1a1a1a),
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            (product['category'] as String).toUpperCase(),
                            style: const TextStyle(
                              color: Color(0xFF9ca3af),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '\$${product['price']}',
                      style: const TextStyle(
                        color: Color(0xFFc74242),
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
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
    String selectedCat = 'coffee';
    File? selectedImage;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          final settings = Provider.of<AppSettingsProvider>(context, listen: false);
          final isDark = settings.isDarkMode;

          return AlertDialog(
            backgroundColor: isDark ? const Color(0xFF1a1f2e) : Colors.white,
            title: Text(
              'Add New Product',
              style: TextStyle(
                color: isDark ? const Color(0xFFf9fafb) : const Color(0xFF1a1a1a),
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
                        color: isDark ? const Color(0xFF0e1116) : Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.1),
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
                                  Icons.add_photo_alternate,
                                  size: 40,
                                  color: const Color(0xFF9ca3af).withOpacity(0.5),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Tap to add image',
                                  style: TextStyle(
                                    color: const Color(0xFF9ca3af).withOpacity(0.8),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  _buildTextField('Product Name (English)', nameController, isDark),
                  const SizedBox(height: 12),
                  _buildTextField('Product Name (French)', nameFrController, isDark),
                  const SizedBox(height: 12),
                  _buildTextField('Product Name (Arabic)', nameArController, isDark),
                  const SizedBox(height: 12),
                  _buildTextField('Price', priceController, isDark, keyboardType: TextInputType.number),
                  const SizedBox(height: 12),
                  
                  // Category Dropdown
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF0e1116) : Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.1),
                      ),
                    ),
                    child: DropdownButton<String>(
                      value: selectedCat,
                      isExpanded: true,
                      dropdownColor: isDark ? const Color(0xFF1a1f2e) : Colors.white,
                      style: TextStyle(
                        color: isDark ? const Color(0xFFf9fafb) : const Color(0xFF1a1a1a),
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
                child: const Text('Cancel'),
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
                    const SnackBar(
                      content: Text('Product added successfully'),
                      backgroundColor: Color(0xFF3cad2a),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFc74242),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Add Product'),
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
            title: Text(
              'Edit Product',
              style: TextStyle(
                color: isDark ? const Color(0xFFf9fafb) : const Color(0xFF1a1a1a),
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
                        color: isDark ? const Color(0xFF0e1116) : Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.1),
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
                                  Icons.add_photo_alternate,
                                  size: 40,
                                  color: const Color(0xFF9ca3af).withOpacity(0.5),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Tap to change image',
                                  style: TextStyle(
                                    color: const Color(0xFF9ca3af).withOpacity(0.8),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  _buildTextField('Product Name (English)', nameController, isDark),
                  const SizedBox(height: 12),
                  _buildTextField('Product Name (French)', nameFrController, isDark),
                  const SizedBox(height: 12),
                  _buildTextField('Product Name (Arabic)', nameArController, isDark),
                  const SizedBox(height: 12),
                  _buildTextField('Price', priceController, isDark, keyboardType: TextInputType.number),
                  const SizedBox(height: 12),
                  
                  // Category Dropdown
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF0e1116) : Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.1),
                      ),
                    ),
                    child: DropdownButton<String>(
                      value: selectedCat,
                      isExpanded: true,
                      dropdownColor: isDark ? const Color(0xFF1a1f2e) : Colors.white,
                      style: TextStyle(
                        color: isDark ? const Color(0xFFf9fafb) : const Color(0xFF1a1a1a),
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
                child: const Text('Cancel'),
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
                    const SnackBar(
                      content: Text('Product updated successfully'),
                      backgroundColor: Color(0xFF3cad2a),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFc74242),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Save Changes'),
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
          title: Text(
            'Delete Product',
            style: TextStyle(
              color: isDark ? const Color(0xFFf9fafb) : const Color(0xFF1a1a1a),
            ),
          ),
          content: Text(
            'Are you sure you want to delete ${product['name']}?',
            style: const TextStyle(color: Color(0xFF9ca3af)),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  products.remove(product);
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${product['name']} deleted'),
                    backgroundColor: const Color(0xFFef4444),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFef4444),
                foregroundColor: Colors.white,
              ),
              child: const Text('Delete'),
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
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          color: Color(0xFF9ca3af),
        ),
        filled: true,
        fillColor: isDark ? const Color(0xFF0e1116) : Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.1),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.1),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFc74242)),
        ),
      ),
    );
  }
}
