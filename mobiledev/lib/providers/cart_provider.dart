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

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
