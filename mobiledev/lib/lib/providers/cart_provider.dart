import 'package:flutter/material.dart';
import '../services/database_service.dart';
import '../data/order_model.dart';


class CartProvider extends ChangeNotifier {
  final Map<String, dynamic> _items = {};
  String? _editingOrderId;

  Map<String, dynamic> get items => _items;

  int get itemCount => _items.length;

  double get totalPrice {
    double total = 0.0;
    _items.forEach((key, item) {
      total += (item['price'] as double) * (item['quantity'] as int);
    });
    return total;
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
        'name': product['name'], // Store the whole map or string
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

  // History
  final List<Map<String, dynamic>> _history = [];
  List<Map<String, dynamic>> get history => _history;

  // Start editing a specific order
  void startEditing(String orderId) {
    _editingOrderId = orderId;
    notifyListeners();
  }

  Future<void> confirmOrder() async {
    if (_items.isEmpty) return;

    final timestamp = DateTime.now();
    
    // Extract info from first item (simplified logic)
    final firstItem = _items.values.first;
    final pickupTime = firstItem['pickupTime'] ?? 'ASAP';
    final orderType = firstItem['orderType'] ?? 'Eat In';
    
    try {
      if (_editingOrderId != null) {
        // Updating existing order
        final order = RestaurantOrder(
          id: _editingOrderId!,
          createdAt: timestamp, // Or preserve original? Usually update changes time or keeps original? Let's update time or keep? User said "keep the old". Assuming ID.
          total: totalPrice,
          status: 'pending',
          items: Map<String, dynamic>.from(_items),
          studentName: 'Student', 
          pickupTime: pickupTime,
          type: orderType,
        );
        
        await DatabaseService().updateOrder(_editingOrderId!, order);
        _editingOrderId = null; // Reset after update
      } else {
        // Creating new order
        final order = RestaurantOrder(
          id: '', 
          createdAt: timestamp,
          total: totalPrice,
          status: 'pending',
          items: Map<String, dynamic>.from(_items),
          studentName: 'Student', 
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

  Future<void> cancelOrder(String orderId) async {
    try {
      await DatabaseService().updateOrderStatus(orderId, 'cancelled');
    } catch (e) {
      debugPrint('Error cancelling order: $e');
    }
  }

  void restoreOrderToCart(String orderId) {
    final index = _history.indexWhere((element) => element['id'] == orderId);
    if (index != -1) {
      final order = _history[index];
      final itemsMap = order['items'] as Map<String, dynamic>;

      // Clear current cart first? Or merge? Usually edit implies replacing current context.
      // Let's clear current cart to be safe and load this order.
      _items.clear();
      _items.addAll(itemsMap);

      // Remove from history since it's now back in cart (or mark as cancelled/edited)
      _history.removeAt(index);

      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    _editingOrderId = null; // Also clear editing state
    notifyListeners();
  }
}
