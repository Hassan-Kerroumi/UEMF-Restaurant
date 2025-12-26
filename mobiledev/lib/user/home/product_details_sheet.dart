import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import '../../providers/app_settings_provider.dart';
import '../../providers/cart_provider.dart';
import '../../data/meal_model.dart';

class ProductDetailsSheet extends StatefulWidget {
  final Meal product;

  const ProductDetailsSheet({super.key, required this.product});

  @override
  State<ProductDetailsSheet> createState() => _ProductDetailsSheetState();
}

class _ProductDetailsSheetState extends State<ProductDetailsSheet> {
  int _quantity = 1;
  String _pickupTime = '12:00';
  String _orderType = 'eatin';

  final List<String> _timeSlots = [
    '08:00',
    '08:30',
    '09:00',
    '09:30',
    '10:00',
    '10:30',
    '11:00',
    '11:30',
    '12:00',
    '12:30',
    '13:00',
    '13:30',
    '14:00',
    '14:30',
    '15:00',
    '15:30',
    '16:00',
    '16:30',
    '17:00',
    '17:30',
    '18:00',
  ];

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<AppSettingsProvider>(context);
    final isDark = settings.isDarkMode;
    final product = widget.product;
    final price = product.price;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1f2937) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Wrap content
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF4b5563) : Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          // Header (Title + Price)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  product.name[settings.language] ?? product.name['en'] ?? '',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                    color: isDark ? const Color(0xFFf9fafb) : const Color(0xFF1a1a1a),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF3cad2a).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$price MAD',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                    color: Color(0xFF3cad2a),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Image / Icon placeholder
          Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0e1116) : const Color(0xFFf3f4f6),
              borderRadius: BorderRadius.circular(16),
              image: product.imageUrl != null
                  ? (product.imageUrl!.startsWith('data:image')
                      ? DecorationImage(
                          image: MemoryImage(base64Decode(product.imageUrl!.split(',')[1])),
                          fit: BoxFit.cover,
                        )
                      : DecorationImage(
                          image: NetworkImage(product.imageUrl!),
                          fit: BoxFit.cover,
                        ))
                  : null,
            ),
            child: product.imageUrl == null
                ? Center(
                    child: Icon(
                      Icons.restaurant_menu_rounded,
                      size: 64,
                      color: isDark ? Colors.white24 : Colors.black12,
                    ),
                  )
                : null,
          ),

          const SizedBox(height: 24),

          // Quantity
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                settings.t('quantity'),
                style: TextStyle(
                  color: isDark ? const Color(0xFF9ca3af) : Colors.grey[600],
                  fontFamily: 'Poppins',
                  fontSize: 14,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      if (_quantity > 1) setState(() => _quantity--);
                    },
                    icon: const Icon(Icons.remove_circle_outline),
                    color: const Color(0xFF9ca3af),
                  ),
                  Container(
                    width: 40,
                    alignment: Alignment.center,
                    child: Text(
                      '$_quantity',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        color: isDark
                            ? const Color(0xFFf9fafb)
                            : const Color(0xFF1a1a1a),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => setState(() => _quantity++),
                    icon: const Icon(Icons.add_circle_outline),
                    color: const Color(0xFF3cad2a),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Pickup Time
          Text(
            settings.t('pickupTime'),
            style: TextStyle(
              color: isDark ? const Color(0xFF9ca3af) : Colors.grey[600],
              fontSize: 14,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            initialValue: _pickupTime,
            dropdownColor: isDark ? const Color(0xFF1a1f2e) : Colors.white,
            style: TextStyle(
              color: isDark ? const Color(0xFFf9fafb) : const Color(0xFF1a1a1a),
              fontFamily: 'Poppins',
            ),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              filled: true,
              fillColor: isDark ? const Color(0xFF0e1116) : Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: isDark
                      ? Colors.white.withOpacity(0.1)
                      : Colors.grey.withOpacity(0.2),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: isDark
                      ? Colors.white.withOpacity(0.1)
                      : Colors.grey.withOpacity(0.2),
                ),
              ),
            ),
            items: _timeSlots
                .map((time) => DropdownMenuItem(value: time, child: Text(time)))
                .toList(),
            onChanged: (val) {
              if (val != null) setState(() => _pickupTime = val);
            },
          ),

          const SizedBox(height: 16),

          // Order Type
          Text(
            'Type',
            style: TextStyle(
              color: isDark ? const Color(0xFF9ca3af) : Colors.grey[600],
              fontSize: 14,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => setState(() => _orderType = 'eatin'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: _orderType == 'eatin'
                          ? const Color(0xFF3cad2a)
                          : Colors.transparent,
                      border: Border.all(
                        color: _orderType == 'eatin'
                            ? const Color(0xFF3cad2a)
                            : (isDark
                                  ? Colors.white.withOpacity(0.1)
                                  : Colors.grey.withOpacity(0.3)),
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      settings.t('eatIn'),
                      style: TextStyle(
                        color: _orderType == 'eatin'
                            ? Colors.white
                            : (isDark
                                  ? const Color(0xFFf9fafb)
                                  : const Color(0xFF1a1a1a)),
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: InkWell(
                  onTap: () => setState(() => _orderType = 'takeaway'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: _orderType == 'takeaway'
                          ? const Color(0xFF3cad2a)
                          : Colors.transparent,
                      border: Border.all(
                        color: _orderType == 'takeaway'
                            ? const Color(0xFF3cad2a)
                            : (isDark
                                  ? Colors.white.withOpacity(0.1)
                                  : Colors.grey.withOpacity(0.3)),
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      settings.t('takeAway'),
                      style: TextStyle(
                        color: _orderType == 'takeaway'
                            ? Colors.white
                            : (isDark
                                  ? const Color(0xFFf9fafb)
                                  : const Color(0xFF1a1a1a)),
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Footer (Total + Confirm)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total:',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? const Color(0xFF9ca3af) : Colors.grey,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  Text(
                    '${(price * _quantity).toStringAsFixed(2)} MAD',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF3cad2a),
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  final productMap = product.toJson();
                  productMap['id'] = product.id;
                  
                  Provider.of<CartProvider>(context, listen: false).addToCart(
                    productMap,
                    quantity: _quantity,
                    orderType: _orderType,
                    pickupTime: _pickupTime,
                  );
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Order added to cart'),
                      backgroundColor: const Color(0xFF3cad2a),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3cad2a),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  settings.t('confirm'),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
