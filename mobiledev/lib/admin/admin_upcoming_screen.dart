import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../providers/app_settings_provider.dart';
import '../services/database_service.dart';
import '../data/upcoming_meal_model.dart';

class AdminUpcomingScreen extends StatefulWidget {
  const AdminUpcomingScreen({super.key});

  @override
  State<AdminUpcomingScreen> createState() => _AdminUpcomingScreenState();
}

class _AdminUpcomingScreenState extends State<AdminUpcomingScreen> {
  final ImagePicker _picker = ImagePicker();
  final DatabaseService _db = DatabaseService();
  
  // No local list needed, we stream directly from Firebase

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
      // UPDATED: Now streams directly from the 'upcoming_menu' collection
      body: StreamBuilder<List<UpcomingMeal>>(
        stream: _db.getUpcomingMeals(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          
          final upcomingMeals = snapshot.data ?? [];
          
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Statistics Cards
                  _buildStatistics(isDark, upcomingMeals),
                  const SizedBox(height: 24),

                  // Tomorrow's Menu Section
                  _buildTomorrowMenu(isDark, upcomingMeals),
                  
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

  Widget _buildStatistics(bool isDark, List<UpcomingMeal> meals) {
    final settings = Provider.of<AppSettingsProvider>(context, listen: false);
    
    // Calculate total votes
    int totalVotes = 0;
    for (var meal in meals) {
      totalVotes += meal.voteCount;
    }
    
    // Find top voted item
    UpcomingMeal? topItem;
    if (meals.isNotEmpty) {
      // Sort to find the max
      final sortedMeals = List<UpcomingMeal>.from(meals)
        ..sort((a, b) => b.voteCount.compareTo(a.voteCount));
      
      if (sortedMeals.first.voteCount > 0) {
        topItem = sortedMeals.first;
      }
    }
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1a1f2e) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withOpacity(0.2) : const Color(0xFF062c6b).withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF3cad2a).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.bar_chart_rounded,
                  color: Color(0xFF3cad2a),
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    settings.t('totalVotes'),
                    style: TextStyle(
                      color: isDark ? const Color(0xFF9ca3af) : const Color(0xFF64748b),
                      fontSize: 14,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  Text(
                    totalVotes.toString(),
                    style: TextStyle(
                      color: isDark ? const Color(0xFFf9fafb) : const Color(0xFF1a1a1a),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (topItem != null) ...[
            const SizedBox(height: 20),
            Divider(color: isDark ? Colors.white.withOpacity(0.1) : Colors.grey.withOpacity(0.2)),
            const SizedBox(height: 20),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3b82f6).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.star_rounded,
                    color: Color(0xFF3b82f6),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        settings.t('topRequested'),
                        style: TextStyle(
                          color: isDark ? const Color(0xFF9ca3af) : const Color(0xFF64748b),
                          fontSize: 14,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      Text(
                        topItem.name[settings.language] ?? topItem.name['en'] ?? '',
                        style: TextStyle(
                          color: isDark ? const Color(0xFFf9fafb) : const Color(0xFF1a1a1a),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3b82f6).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${topItem.voteCount} ${settings.t('votes')}',
                    style: const TextStyle(
                      color: Color(0xFF3b82f6),
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      fontFamily: 'Poppins',
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

  Widget _buildTomorrowMenu(bool isDark, List<UpcomingMeal> meals) {
    final settings = Provider.of<AppSettingsProvider>(context, listen: false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              settings.t('tomorrowsMenu'),
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
        if (meals.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                   Icon(Icons.event_busy, color: isDark ? Colors.white24 : Colors.grey[300], size: 48),
                   const SizedBox(height: 16),
                   Text(
                    settings.t('noItemsFound') == 'noItemsFound' ? 'No items planned yet' : settings.t('noItemsFound'),
                    style: TextStyle(
                      color: isDark ? Colors.white54 : Colors.black54,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.70, // Slightly taller for buttons
            ),
            itemCount: meals.length,
            itemBuilder: (context, index) {
              return _buildTomorrowMenuCard(meals[index], isDark);
            },
          ),
      ],
    );
  }

  Widget _buildTomorrowMenuCard(UpcomingMeal item, bool isDark) {
    final settings = Provider.of<AppSettingsProvider>(context, listen: false);

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
                  image: item.imageUrl != null
                      ? (item.imageUrl!.startsWith('data:image')
                          ? DecorationImage(
                              image: MemoryImage(base64Decode(item.imageUrl!.split(',')[1])),
                              fit: BoxFit.cover,
                            )
                          : DecorationImage(
                              image: NetworkImage(item.imageUrl!),
                              fit: BoxFit.cover,
                            ))
                      : null,
                ),
                child: item.imageUrl == null
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
                          size: 16,
                          color: Color(0xFF3b82f6),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => _deleteTomorrowMenuItem(item),
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
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name[settings.language] ?? item.name['en'] ?? '',
                        style: TextStyle(
                          color: isDark ? const Color(0xFFf9fafb) : const Color(0xFF1a1a1a),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                       Text(
                        settings.t(item.category),
                        style: TextStyle(
                          color: isDark ? const Color(0xFF9ca3af) : const Color(0xFF6b7280),
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
                        '\$${item.price}',
                        style: TextStyle(
                          color: isDark ? const Color(0xFF3cad2a) : const Color(0xFF062c6b),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: (isDark ? const Color(0xFF3cad2a) : const Color(0xFF062c6b)).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                             color: (isDark ? const Color(0xFF3cad2a) : const Color(0xFF062c6b)).withOpacity(0.2),
                          )
                        ),
                        child: Row(
                          children: [
                            Icon(
                                Icons.thumb_up_rounded, 
                                size: 12, 
                                color: isDark ? const Color(0xFF3cad2a) : const Color(0xFF062c6b)
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${item.voteCount}',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: isDark ? const Color(0xFF3cad2a) : const Color(0xFF062c6b),
                              ),
                            ),
                          ],
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
    );
  }

  void _addNewMeal() {
    final nameEnController = TextEditingController();
    final nameArController = TextEditingController();
    final nameFrController = TextEditingController();
    final priceController = TextEditingController();
    String selectedType = 'lunch';
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
              settings.t('addItem'),
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
                      height: 120,
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
                                  size: 32,
                                  color: const Color(0xFF9ca3af).withOpacity(0.5),
                                ),
                                const SizedBox(height: 4),
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

                  _buildTextField('${settings.t('productName')} (EN)', nameEnController, isDark),
                  const SizedBox(height: 12),
                  _buildTextField('${settings.t('productName')} (AR)', nameArController, isDark),
                  const SizedBox(height: 12),
                  _buildTextField('${settings.t('productName')} (FR)', nameFrController, isDark),
                  const SizedBox(height: 12),
                  _buildTextField(settings.t('price'), priceController, isDark, keyboardType: TextInputType.number),
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
                                child: Text(settings.t(type).toUpperCase()),
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
                  if (nameEnController.text.isEmpty || priceController.text.isEmpty) {
                    return;
                  }
                  
                  setDialogState(() => isSaving = true);
                  final messenger = ScaffoldMessenger.of(context);
                  
                  try {
                    // Create object with UpcomingMeal model (has voteCount)
                    final newMeal = UpcomingMeal(
                      id: '', // Generated by Firebase
                      name: {
                        'en': nameEnController.text,
                        'ar': nameArController.text,
                        'fr': nameFrController.text,
                      },
                      description: {'en': ''},
                      price: double.tryParse(priceController.text) ?? 0.0,
                      category: selectedType, // Using type as category
                      date: DateTime.now().add(const Duration(days: 1)), // Default to tomorrow
                      voteCount: 0,
                      imageUrl: null,
                    );
                    
                    // THIS calls addUpcomingMeal in database service, which uses 'upcoming_menu' collection
                    await _db.addUpcomingMeal(newMeal, imageBytes: selectedImageBytes, imageName: selectedImageName);
                    
                    if (context.mounted) {
                      Navigator.pop(context);
                      messenger.showSnackBar(
                        SnackBar(
                          content: Text(settings.t('itemAddedToMenu')),
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
                  : Text(settings.t('addItem'), style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600)),
              ),
            ],
          );
        },
      ),
    );
  }

  void _editTomorrowMenuItem(UpcomingMeal item) {
    final nameEnController = TextEditingController(text: item.name['en']);
    final nameArController = TextEditingController(text: item.name['ar']);
    final nameFrController = TextEditingController(text: item.name['fr']);
    final priceController = TextEditingController(text: item.price.toString());
    String selectedType = item.category;
    Uint8List? selectedImageBytes;
    String? selectedImageName;
    String? currentImageUrl = item.imageUrl;
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
              settings.t('editItem'),
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
                        final bytes = await image.readAsBytes();
                        setDialogState(() {
                          selectedImageBytes = bytes;
                          selectedImageName = image.name;
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
                                  size: 32,
                                  color: const Color(0xFF9ca3af).withOpacity(0.5),
                                ),
                                const SizedBox(height: 4),
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
                  
                  _buildTextField('${settings.t('productName')} (EN)', nameEnController, isDark),
                  const SizedBox(height: 12),
                  _buildTextField('${settings.t('productName')} (AR)', nameArController, isDark),
                  const SizedBox(height: 12),
                  _buildTextField('${settings.t('productName')} (FR)', nameFrController, isDark),
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
                                child: Text(settings.t(type).toUpperCase()),
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
                  if (nameEnController.text.isEmpty || priceController.text.isEmpty) {
                    return;
                  }
                  
                  setDialogState(() => isSaving = true);
                  final messenger = ScaffoldMessenger.of(context);
                  
                  try {
                    final updatedMeal = item.copyWith(
                      name: {
                        'en': nameEnController.text,
                        'ar': nameArController.text,
                        'fr': nameFrController.text,
                      },
                      price: double.tryParse(priceController.text) ?? 0.0,
                      category: selectedType,
                    );
                    
                    // Uses updateUpcomingMeal -> 'upcoming_menu'
                    await _db.updateUpcomingMeal(item.id, updatedMeal, newImageBytes: selectedImageBytes, newImageName: selectedImageName);
                    
                    if (context.mounted) {
                      Navigator.pop(context);
                      messenger.showSnackBar(
                        SnackBar(
                          content: Text(settings.t('itemUpdated')),
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

  void _deleteTomorrowMenuItem(UpcomingMeal item) {
    final settings = Provider.of<AppSettingsProvider>(context, listen: false);
    final isDark = settings.isDarkMode;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
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
          '${settings.t('deleteConfirmation')} "${item.name[settings.language] ?? item.name['en']}"?',
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
                // Uses deleteUpcomingMeal -> 'upcoming_menu'
                await _db.deleteUpcomingMeal(item.id);
                
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(settings.t('itemDeleted')),
                      backgroundColor: const Color(0xFF3cad2a),
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error deleting item: $e'),
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
}