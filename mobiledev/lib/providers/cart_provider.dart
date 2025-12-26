import 'package:flutter/material.dart';
import '../services/database_service.dart';
import '../data/order_model.dart';

class CartProvider extends ChangeNotifier {
  final Map<String, dynamic> _items = {};
  String? _editingOrderId;

  // User Info Storage
  String? _userId;
  String? _userName;

  Map<String, dynamic> get items => _items;
  int get itemCount => _items.length;

  double get totalPrice {
    double total = 0.0;
    _items.forEach((key, item) {
      total += (item['price'] as double) * (item['quantity'] as int);
    });
    return total;
  }

  // CALL THIS ON LOGIN
  void setUser(String id, String name) {
    _userId = id;
    _userName = name;
    notifyListeners();
  }

  void addToCart(
    Map<String, dynamic> product, {
    int quantity = 1,
    String? pickupTime,
    String? orderType,
  }) {
    if (_items.containsKey(product['id'])) {
      _items[product['id']]['quantity'] += quantity;
    } else {
      _items[product['id']] = {
        'id': product['id'],
        'name': product['name'],
        'price': product['price'],
        'quantity': quantity,
        'pickupTime': pickupTime ?? 'ASAP',
        'orderType': orderType ?? 'Eat In',
        'icon': product['icon'],
        'imageUrl': product['imageUrl'],
      };
    }
    notifyListeners();
  }

  void removeFromCart(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void updateQuantity(String productId, int quantity) {
    if (_items.containsKey(productId)) {
      if (quantity <= 0) {
        removeFromCart(productId);
      } else {
        _items[productId]['quantity'] = quantity;
        notifyListeners();
      }
    }
  }

  void startEditing(String orderId) {
    _editingOrderId = orderId;
    notifyListeners();
  }

  Future<void> confirmOrder() async {
    if (_items.isEmpty) return;

    // Ensure we have a user
    if (_userId == null) {
      throw Exception("User not logged in");
    }

    final timestamp = DateTime.now();
    final firstItem = _items.values.first;
    final pickupTime = firstItem['pickupTime'] ?? 'ASAP';
    final orderType = firstItem['orderType'] ?? 'Eat In';

    try {
      // Sanitize items (remove heavy image data) before saving
      final sanitizedItems = _items.map((key, value) {
        final item = Map<String, dynamic>.from(value);
        item.remove('imageUrl');
        item.remove('icon');
        return MapEntry(key, item);
      });

      if (_editingOrderId != null) {
        final order = RestaurantOrder(
          id: _editingOrderId!,
          createdAt: timestamp,
          total: totalPrice,
          status: 'pending',
          items: sanitizedItems,
          userId: _userId!,
          studentName: _userName ?? 'Student',
          pickupTime: pickupTime,
          type: orderType,
        );
        await DatabaseService().updateOrder(_editingOrderId!, order);
        _editingOrderId = null;
      } else {
        final order = RestaurantOrder(
          id: '',
          createdAt: timestamp,
          total: totalPrice,
          status: 'pending',
          items: sanitizedItems,
          userId: _userId!,
          studentName: _userName ?? 'Student',
          pickupTime: pickupTime,
          type: orderType,
        );
        await DatabaseService().createOrder(order);
      }

      _items.clear();
      notifyListeners();
    } catch (e) {
      debugPrint('Error processing order: $e');
      rethrow;
    }
  }

  void clearCart() {
    _items.clear();
    _editingOrderId = null;
    notifyListeners();
  }
}
