import 'package:flutter/material.dart';

class CartProvider extends ChangeNotifier {
  final Map<String, dynamic> _items = {};

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
        'name': product['name'],
        'price': product['price'],
        'quantity': quantity,
        'pickupTime': pickupTime ?? 'ASAP',
        'orderType': orderType ?? 'Eat In',
        'icon': product['icon'], // Ensure icon is preserved if available
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

  void confirmOrder() {
    if (_items.isEmpty) return;

    _history.add({
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'date': DateTime.now(),
      'items': Map<String, dynamic>.from(_items),
      'total': totalPrice,
      'status': 'Pending', // Pending, Completed, Cancelled
    });

    _items.clear();
    notifyListeners();
  }

  void cancelOrder(String orderId) {
    final index = _history.indexWhere((element) => element['id'] == orderId);
    if (index != -1) {
      _history[index]['status'] = 'Cancelled';
      notifyListeners();
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
    notifyListeners();
  }
}
