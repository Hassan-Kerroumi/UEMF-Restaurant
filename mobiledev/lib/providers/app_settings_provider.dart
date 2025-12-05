import 'package:flutter/material.dart';

class AppSettingsProvider extends ChangeNotifier {
  // Theme Mode
  ThemeMode _themeMode = ThemeMode.dark;
  ThemeMode get themeMode => _themeMode;
  
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  
  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }
  
  // Language
  String _language = 'en';
  String get language => _language;
  
  void setLanguage(String lang) {
    _language = lang;
    notifyListeners();
  }
  
  // Translations
  Map<String, Map<String, String>> translations = {
    'en': {
      'ordersOfTheDay': 'Orders of the Day',
      'search': 'Search',
      'categories': 'Categories',
      'accept': 'Accept',
      'refuse': 'Refuse',
      'send': 'Send',
      'cancel': 'Cancel',
      'message': 'Message',
      'suggestTime': 'Suggest Time',
      'allOrders': 'All Orders',
      'stats': 'Statistics',
      'products': 'Products',
      'tomorrowPlanned': 'Tomorrow Planned',
      'home': 'Home',
      'orders': 'Orders',
      'upcoming': 'Upcoming',
    },
    'fr': {
      'ordersOfTheDay': 'Commandes du jour',
      'search': 'Rechercher',
      'categories': 'Catégories',
      'accept': 'Accepter',
      'refuse': 'Refuser',
      'send': 'Envoyer',
      'cancel': 'Annuler',
      'message': 'Message',
      'suggestTime': 'Suggérer un horaire',
      'allOrders': 'Toutes les commandes',
      'stats': 'Statistiques',
      'products': 'Produits',
      'tomorrowPlanned': 'Planifié pour demain',
      'home': 'Accueil',
      'orders': 'Commandes',
      'upcoming': 'À venir',
    },
    'ar': {
      'ordersOfTheDay': 'طلبات اليوم',
      'search': 'بحث',
      'categories': 'الفئات',
      'accept': 'قبول',
      'refuse': 'رفض',
      'send': 'إرسال',
    'cancel': 'إلغاء',
      'message': 'رسالة',
      'suggestTime': 'اقتراح وقت',
      'allOrders': 'كل الطلبات',
      'stats': 'إحصائيات',
      'products': 'المنتجات',
      'tomorrowPlanned': 'مخطط لغدا',
      'home': 'الرئيسية',
      'orders': 'الطلبات',
      'upcoming': 'القادمة',
    },
  };
  
  String t(String key) {
    return translations[_language]?[key] ?? key;
  }
  
  // Categories with translations
  List<Map<String, dynamic>> get categories => [
    {
      'id': 'all',
      'name': {'en': 'All', 'fr': 'Tout', 'ar': 'الكل'},
      'icon': '🍽️',
    },
    {
      'id': 'hot-drinks',
      'name': {'en': 'Hot Drinks', 'fr': 'Boissons chaudes', 'ar': 'مشروبات ساخنة'},
      'icon': '☕',
    },
    {
      'id': 'cold-drinks',
      'name': {'en': 'Cold Drinks', 'fr': 'Boissons froides', 'ar': 'مشروبات باردة'},
      'icon': '🥤',
    },
    {
      'id': 'cakes-desserts',
      'name': {'en': 'Cakes & Desserts', 'fr': 'Gâteaux & desserts', 'ar': 'كعك وحلويات'},
      'icon': '🧁',
    },
    {
      'id': 'breakfast',
      'name': {'en': 'Breakfast', 'fr': 'Petit déjeuner', 'ar': 'فطور'},
      'icon': '🥐',
    },
    {
      'id': 'pizza-pasta',
      'name': {'en': 'Pizza & Pasta', 'fr': 'Pizza & pâtes', 'ar': 'بيتزا ومعكرونة'},
      'icon': '🍕',
    },
    {
      'id': 'dishes',
      'name': {'en': 'Main Dishes', 'fr': 'Plats', 'ar': 'أطباق رئيسية'},
      'icon': '🍽️',
    },
    {
      'id': 'sandwiches',
      'name': {'en': 'Sandwiches', 'fr': 'Sandwiches', 'ar': 'ساندويتشات'},
      'icon': '🥪',
    },
    {
      'id': 'salads',
      'name': {'en': 'Salads', 'fr': 'Salades', 'ar': 'سلطات'},
      'icon': '🥗',
    },
    {
      'id': 'dairy',
      'name': {'en': 'Dairy', 'fr': 'Laitage', 'ar': 'ألبان'},
      'icon': '🥛',
    },
    {
      'id': 'snacks',
      'name': {'en': 'Snacks', 'fr': 'Snacks', 'ar': 'وجبات خفيفة'},
      'icon': '🍿',
    },
  ];
  
  String getCategoryName(String categoryId) {
    final category = categories.firstWhere(
      (cat) => cat['id'] == categoryId,
      orElse: () => {'name': {'en': categoryId, 'fr': categoryId, 'ar': categoryId}},
    );
    return category['name'][_language] ?? categoryId;
  }
}
