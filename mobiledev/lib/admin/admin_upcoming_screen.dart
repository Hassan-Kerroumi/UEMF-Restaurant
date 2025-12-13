import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../providers/app_settings_provider.dart';

class AdminUpcomingScreen extends StatefulWidget {
  const AdminUpcomingScreen({super.key});

  @override
  State<AdminUpcomingScreen> createState() => _AdminUpcomingScreenState();
}

class _AdminUpcomingScreenState extends State<AdminUpcomingScreen> {
  final ImagePicker _picker = ImagePicker();

  // Tomorrow's Menu Items (Admin suggestions)
  List<Map<String, dynamic>> tomorrowMenu = [
    {
      'id': '1',
      'name': 'Special Tajine',
      'nameAr': 'طاجين خاص',
      'nameFr': 'Tajine Spécial',
      'price': 45.0,
      'type': 'lunch',
      'image': 'https://images.unsplash.com/photo-1541518763669-27fef04b14ea?w=400',
      'voteCount': 15,
    },
    {
      'id': '2',
      'name': 'Couscous Royal',
      'nameAr': 'كسكس ملكي',
      'nameFr': 'Couscous Royal',
      'price': 50.0,
      'type': 'lunch',
      'image': 'https://images.unsplash.com/photo-1585937421612-70a008356f36?w=400',
      'voteCount': 28,
    },
    {
      'id': '3',
      'name': 'Grilled Chicken',
      'nameAr': 'دجاج مشوي',
      'nameFr': 'Poulet Grillé',
      'price': 35.0,
      'type': 'dinner',
      'image': 'https://images.unsplash.com/photo-1532550907401-a500c9a57435?w=400',
      'voteCount': 12,
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
          settings.t('tomorrowPlanned'),
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
              onPressed: _addNewMeal,
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
              // Statistics Cards
              _buildStatistics(isDark),
              const SizedBox(height: 24),

              // Tomorrow's Menu Section
              _buildTomorrowMenu(isDark),
              
              // Bottom padding for floating nav bar
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatistics(bool isDark) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF062c6b), Color(0xFF041e4a)],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF062c6b).withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
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
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '24',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF3cad2a), Color(0xFF2d8a20)],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF3cad2a).withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
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
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '42',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
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

  Widget _buildTomorrowMenu(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Tomorrow\'s Menu',
              style: TextStyle(
                color: isDark ? const Color(0xFFf9fafb) : const Color(0xFF1a1a1a),
                fontSize: 18,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.6,
          ),
          itemCount: tomorrowMenu.length,
          itemBuilder: (context, index) {
            return _buildTomorrowMenuCard(tomorrowMenu[index], isDark);
          },
        ),
      ],
    );
  }

  Widget _buildTomorrowMenuCard(Map<String, dynamic> item, bool isDark) {
    final image = item['image'];
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
                height: 110,
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
                          Icons.restaurant_menu_rounded,
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
                      onTap: () => _editTomorrowMenuItem(item),
                      child: Container(
                        padding: const EdgeInsets.all(6),
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
                          size: 14,
                          color: Color(0xFF3b82f6),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          tomorrowMenu.remove(item);
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(6),
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
                          size: 14,
                          color: Color(0xFFef4444),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['name'] as String,
                    style: TextStyle(
                      color: isDark ? const Color(0xFFf9fafb) : const Color(0xFF1a1a1a),
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                 
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${item['price']}',
                        style: TextStyle(
                          color: isDark ? const Color(0xFF3cad2a) : const Color(0xFF062c6b),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      color: (isDark ? const Color(0xFF3cad2a) : const Color(0xFF062c6b)).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: (isDark ? const Color(0xFF3cad2a) : const Color(0xFF062c6b)).withOpacity(0.2),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.people_rounded,
                          size: 14,
                          color: isDark ? const Color(0xFF3cad2a) : const Color(0xFF062c6b),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${item['voteCount'] ?? 0} Votes',
                          style: TextStyle(
                            color: isDark ? const Color(0xFF3cad2a) : const Color(0xFF062c6b),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _addNewMeal() {
    final nameEnController = TextEditingController();
    final nameArController = TextEditingController();
    final nameFrController = TextEditingController();
    final priceController = TextEditingController();
    String selectedType = 'lunch';
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
              'Add Menu Item',
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
                      height: 120,
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
                                  size: 32,
                                  color: const Color(0xFF9ca3af).withOpacity(0.5),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Add Image',
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

                  _buildTextField('Product Name (EN)', nameEnController, isDark),
                  const SizedBox(height: 12),
                  _buildTextField('Product Name (AR)', nameArController, isDark),
                  const SizedBox(height: 12),
                  _buildTextField('Product Name (FR)', nameFrController, isDark),
                  const SizedBox(height: 12),
                  _buildTextField('Price', priceController, isDark, keyboardType: TextInputType.number),
                  const SizedBox(height: 12),
                  
                  // Meal Type Dropdown
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
                      value: selectedType,
                      isExpanded: true,
                      dropdownColor: isDark ? const Color(0xFF1a1f2e) : Colors.white,
                      style: TextStyle(
                        color: isDark ? const Color(0xFFf9fafb) : const Color(0xFF1a1a1a),
                        fontFamily: 'Poppins',
                      ),
                      underline: const SizedBox(),
                      items: ['breakfast', 'lunch', 'dinner']
                          .map((type) => DropdownMenuItem(
                                value: type,
                                child: Text(type.toUpperCase()),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setDialogState(() {
                            selectedType = value;
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
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Color(0xFF9ca3af), fontFamily: 'Poppins'),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (nameEnController.text.isEmpty || priceController.text.isEmpty) {
                    return;
                  }
                  
                  setState(() {
                    tomorrowMenu.add({
                      'id': DateTime.now().millisecondsSinceEpoch.toString(),
                      'name': nameEnController.text,
                      'nameAr': nameArController.text,
                      'nameFr': nameFrController.text,
                      'price': double.tryParse(priceController.text) ?? 0.0,
                      'type': selectedType,
                      'image': selectedImage,
                      'voteCount': 0,
                    });
                  });
                  
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Item added to menu'),
                      backgroundColor: Color(0xFF3cad2a),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark ? const Color(0xFF3cad2a) : const Color(0xFF062c6b),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: const Text('Add Item', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600)),
              ),
            ],
          );
        },
      ),
    );
  }

  void _editTomorrowMenuItem(Map<String, dynamic> item) {
    final nameEnController = TextEditingController(text: item['name']);
    final nameArController = TextEditingController(text: item['nameAr']);
    final nameFrController = TextEditingController(text: item['nameFr']);
    final priceController = TextEditingController(text: item['price'].toString());
    String selectedType = item['type'] ?? 'lunch';
    dynamic currentImage = item['image'];
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
              'Edit Menu Item',
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
                      height: 120,
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
                                  size: 32,
                                  color: const Color(0xFF9ca3af).withOpacity(0.5),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Change Image',
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
                  _buildTextField('Product Name (EN)', nameEnController, isDark),
                  const SizedBox(height: 12),
                  _buildTextField('Product Name (AR)', nameArController, isDark),
                  const SizedBox(height: 12),
                  _buildTextField('Product Name (FR)', nameFrController, isDark),
                  const SizedBox(height: 12),
                  _buildTextField('Price', priceController, isDark, keyboardType: TextInputType.number),
                  const SizedBox(height: 12),
                  
                  // Meal Type Dropdown
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
                      value: selectedType,
                      isExpanded: true,
                      dropdownColor: isDark ? const Color(0xFF1a1f2e) : Colors.white,
                      style: TextStyle(
                        color: isDark ? const Color(0xFFf9fafb) : const Color(0xFF1a1a1a),
                        fontFamily: 'Poppins',
                      ),
                      underline: const SizedBox(),
                      items: ['breakfast', 'lunch', 'dinner']
                          .map((type) => DropdownMenuItem(
                                value: type,
                                child: Text(type.toUpperCase()),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setDialogState(() {
                            selectedType = value;
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
                child: const Text('Cancel', style: TextStyle(color: Color(0xFF9ca3af), fontFamily: 'Poppins')),
              ),
              ElevatedButton(
                onPressed: () {
                  if (nameEnController.text.isNotEmpty && priceController.text.isNotEmpty) {
                    setState(() {
                      item['name'] = nameEnController.text;
                      item['nameAr'] = nameArController.text;
                      item['nameFr'] = nameFrController.text;
                      item['price'] = double.tryParse(priceController.text) ?? 0.0;
                      item['type'] = selectedType;
                      if (newImage != null) {
                        item['image'] = newImage;
                      }
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Menu item updated'),
                        backgroundColor: Color(0xFF3cad2a),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3cad2a),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: const Text('Save Changes', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600)),
              ),
            ],
          );
        },
      ),
    );
  }
}
