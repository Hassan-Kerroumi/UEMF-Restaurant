import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_settings_provider.dart';
import '../../providers/cart_provider.dart';

class ProductDetailsSheet extends StatefulWidget {
  final Map<String, dynamic> product;

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
    final product = widget.product;
    final name = product['name'][settings.language];
    final double price = product['price'];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Wrap content
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Image / Icon placeholder
          Container(
            height: 150,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                product['icon'] ?? '',
                style: const TextStyle(fontSize: 64),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Quantity
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                settings.t('quantity'),
                style: TextStyle(color: Colors.grey[600]),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      if (_quantity > 1) setState(() => _quantity--);
                    },
                    icon: const Icon(Icons.remove_circle_outline),
                    color: Colors.grey,
                  ),
                  Text(
                    '$_quantity',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  IconButton(
                    onPressed: () => setState(() => _quantity++),
                    icon: const Icon(Icons.add_circle_outline),
                    color: Theme.of(context).primaryColor,
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Pickup Time
          Text(
            settings.t('pickupTime'),
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _pickupTime,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
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
          Text('Type', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
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
                          ? Theme.of(context).primaryColor
                          : Colors.transparent,
                      border: Border.all(
                        color: _orderType == 'eatin'
                            ? Theme.of(context).primaryColor
                            : Colors.grey.withOpacity(0.3),
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      settings.t('eatIn'),
                      style: TextStyle(
                        color: _orderType == 'eatin'
                            ? Colors.white
                            : Theme.of(context).textTheme.bodyMedium?.color,
                        fontWeight: FontWeight.bold,
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
                          ? Theme.of(context).primaryColor
                          : Colors.transparent,
                      border: Border.all(
                        color: _orderType == 'takeaway'
                            ? Theme.of(context).primaryColor
                            : Colors.grey.withOpacity(0.3),
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      settings.t('takeAway'),
                      style: TextStyle(
                        color: _orderType == 'takeaway'
                            ? Colors.white
                            : Theme.of(context).textTheme.bodyMedium?.color,
                        fontWeight: FontWeight.bold,
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
                  const Text(
                    'Total:',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  Text(
                    '\$${(price * _quantity).toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  Provider.of<CartProvider>(context, listen: false).addToCart(
                    product,
                    quantity: _quantity,
                    orderType: _orderType,
                    pickupTime: _pickupTime,
                  );
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Order added to cart'),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(settings.t('confirm')),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
