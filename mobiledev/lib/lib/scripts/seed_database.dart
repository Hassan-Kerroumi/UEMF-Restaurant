import 'package:cloud_firestore/cloud_firestore.dart';

/// This script seeds the Firestore database with test data
/// Run this ONCE after setting up your Firebase project
/// 
/// To run: Create a button in your app that calls seedDatabase()
/// or run it from a test environment

class DatabaseSeeder {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> seedDatabase() async {
    print('🌱 Starting database seeding...');
    
    try {
      await _seedUsers();
      await _seedProducts();
      await _seedOrders();
      await _seedUpcomingMenu();
      
      print('✅ Database seeding completed successfully!');
    } catch (e) {
      print('❌ Error seeding database: $e');
      rethrow;
    }
  }

  Future<void> _seedUsers() async {
    print('👥 Seeding users...');
    
    final users = [
      {
        'id': 'hassan_admin',
        'data': {
          'password': '0000000',
          'role': 'admin',
          'name': 'Hassan Admin',
          'email': 'hassan.admin@uemf.ac.ma',
        }
      },
      {
        'id': 'user1',
        'data': {
          'password': '000000',
          'role': 'user',
          'name': 'Ahmed Benali',
          'email': 'ahmed.benali@uemf.ac.ma',
          'studentId': 'STU001',
        }
      },
      {
        'id': 'user2',
        'data': {
          'password': '000000',
          'role': 'user',
          'name': 'Sarah Alaoui',
          'email': 'sarah.alaoui@uemf.ac.ma',
          'studentId': 'STU002',
        }
      },
      {
        'id': 'user3',
        'data': {
          'password': '000000',
          'role': 'user',
          'name': 'Youssef Idrissi',
          'email': 'youssef.idrissi@uemf.ac.ma',
          'studentId': 'STU003',
        }
      },
    ];

    for (var user in users) {
      await _firestore.collection('users').doc(user['id'] as String).set(user['data'] as Map<String, dynamic>);
      print('  ✓ Created user: ${user['id']}');
    }
  }

  Future<void> _seedProducts() async {
    print('🍕 Seeding products...');
    
    final products = [
      {
        'name': {'en': 'Espresso', 'fr': 'Espresso', 'ar': 'إسبريسو'},
        'description': {
          'en': 'Strong Italian coffee',
          'fr': 'Café italien fort',
          'ar': 'قهوة إيطالية قوية'
        },
        'price': 12.0,
        'category': 'hot-drinks',
        'imageUrl': 'https://images.unsplash.com/photo-1510591509098-f4fdc6d0ff04?w=400',
      },
      {
        'name': {'en': 'Cappuccino', 'fr': 'Cappuccino', 'ar': 'كابتشينو'},
        'description': {
          'en': 'Espresso with steamed milk foam',
          'fr': 'Espresso avec mousse de lait',
          'ar': 'إسبريسو مع رغوة الحليب'
        },
        'price': 18.0,
        'category': 'hot-drinks',
        'imageUrl': 'https://images.unsplash.com/photo-1572442388796-11668a67e53d?w=400',
      },
      {
        'name': {'en': 'Fresh Orange Juice', 'fr': 'Jus d\'Orange Frais', 'ar': 'عصير برتقال طازج'},
        'description': {
          'en': '100% natural fresh orange juice',
          'fr': 'Jus d\'orange frais 100% naturel',
          'ar': 'عصير برتقال طازج طبيعي 100%'
        },
        'price': 15.0,
        'category': 'cold-drinks',
        'imageUrl': 'https://images.unsplash.com/photo-1600271886742-f049cd451bba?w=400',
      },
      {
        'name': {'en': 'Chocolate Cake', 'fr': 'Gâteau au Chocolat', 'ar': 'كعكة الشوكولاتة'},
        'description': {
          'en': 'Rich chocolate cake with chocolate frosting',
          'fr': 'Gâteau au chocolat riche avec glaçage au chocolat',
          'ar': 'كعكة شوكولاتة غنية مع صقيع الشوكولاتة'
        },
        'price': 25.0,
        'category': 'cakes-desserts',
        'imageUrl': 'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=400',
      },
      {
        'name': {'en': 'Butter Croissant', 'fr': 'Croissant au Beurre', 'ar': 'كرواسون بالزبدة'},
        'description': {
          'en': 'Fresh French butter croissant',
          'fr': 'Croissant français au beurre frais',
          'ar': 'كرواسون فرنسي طازج بالزبدة'
        },
        'price': 10.0,
        'category': 'breakfast',
        'imageUrl': 'https://images.unsplash.com/photo-1555507036-ab1f4038808a?w=400',
      },
      {
        'name': {'en': 'Margherita Pizza', 'fr': 'Pizza Margherita', 'ar': 'بيتزا مارغريتا'},
        'description': {
          'en': 'Classic pizza with tomato, mozzarella, and basil',
          'fr': 'Pizza classique avec tomate, mozzarella et basilic',
          'ar': 'بيتزا كلاسيكية مع الطماطم والموزاريلا والريحان'
        },
        'price': 45.0,
        'category': 'pizza-pasta',
        'imageUrl': 'https://images.unsplash.com/photo-1574071318508-1cdbab80d002?w=400',
      },
      {
        'name': {'en': 'Caesar Salad', 'fr': 'Salade César', 'ar': 'سلطة سيزر'},
        'description': {
          'en': 'Fresh romaine lettuce with Caesar dressing and croutons',
          'fr': 'Laitue romaine fraîche avec vinaigrette César et croûtons',
          'ar': 'خس روماني طازج مع صلصة سيزر وخبز محمص'
        },
        'price': 30.0,
        'category': 'salads',
        'imageUrl': 'https://images.unsplash.com/photo-1546793665-c74683f339c1?w=400',
      },
      {
        'name': {'en': 'Club Sandwich', 'fr': 'Sandwich Club', 'ar': 'ساندويتش كلوب'},
        'description': {
          'en': 'Triple-decker sandwich with chicken, bacon, lettuce, and tomato',
          'fr': 'Sandwich triple épaisseur avec poulet, bacon, laitue et tomate',
          'ar': 'ساندويتش ثلاثي مع دجاج ولحم مقدد وخس وطماطم'
        },
        'price': 35.0,
        'category': 'sandwiches',
        'imageUrl': 'https://images.unsplash.com/photo-1528735602780-2552fd46c7af?w=400',
      },
    ];

    for (var product in products) {
      await _firestore.collection('products').add(product);
      final nameMap = product['name'] as Map<String, dynamic>;
      print('  ✓ Created product: ${nameMap['en']}');
    }
  }

  Future<void> _seedOrders() async {
    print('📦 Seeding orders...');
    
    final orders = [
      {
        'studentName': 'Ahmed Benali',
        'items': [
          {
            'id': 'item1',
            'name': {'en': 'Cappuccino', 'fr': 'Cappuccino', 'ar': 'كابتشينو'},
            'price': 18.0,
            'quantity': 2,
          },
          {
            'id': 'item2',
            'name': {'en': 'Croissant', 'fr': 'Croissant au Beurre', 'ar': 'كرواسون بالزبدة'},
            'price': 10.0,
            'quantity': 1,
          }
        ],
        'total': 46.0,
        'status': 'pending',
        'createdAt': Timestamp.fromDate(DateTime.now().subtract(const Duration(hours: 2))),
        'pickupTime': '10:30',
        'type': 'breakfast',
        'feedback': '',
      },
      {
        'studentName': 'Sarah Alaoui',
        'items': [
          {
            'id': 'item3',
            'name': {'en': 'Margherita Pizza', 'fr': 'Pizza Margherita', 'ar': 'بيتزا مارغريتا'},
            'price': 45.0,
            'quantity': 1,
          },
          {
            'id': 'item4',
            'name': {'en': 'Fresh Orange Juice', 'fr': 'Jus d\'Orange Frais', 'ar': 'عصير برتقال طازج'},
            'price': 15.0,
            'quantity': 2,
          }
        ],
        'total': 75.0,
        'status': 'accepted',
        'createdAt': Timestamp.fromDate(DateTime.now().subtract(const Duration(hours: 4))),
        'pickupTime': '12:00',
        'type': 'lunch',
        'feedback': '',
      },
      {
        'studentName': 'Youssef Idrissi',
        'items': [
          {
            'id': 'item5',
            'name': {'en': 'Espresso', 'fr': 'Espresso', 'ar': 'إسبريسو'},
            'price': 12.0,
            'quantity': 5,
          }
        ],
        'total': 60.0,
        'status': 'refused',
        'createdAt': Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 1))),
        'pickupTime': '15:30',
        'type': 'snack',
        'feedback': 'Out of espresso beans. Please try Cappuccino or come at 16:00 when we restock.',
      },
      {
        'studentName': 'Ahmed Benali',
        'items': [
          {
            'id': 'item6',
            'name': {'en': 'Club Sandwich', 'fr': 'Sandwich Club', 'ar': 'ساندويتش كلوب'},
            'price': 35.0,
            'quantity': 1,
          },
          {
            'id': 'item7',
            'name': {'en': 'Caesar Salad', 'fr': 'Salade César', 'ar': 'سلطة سيزر'},
            'price': 30.0,
            'quantity': 1,
          }
        ],
        'total': 65.0,
        'status': 'completed',
        'createdAt': Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 1, hours: 12))),
        'pickupTime': '13:00',
        'type': 'lunch',
        'feedback': '',
      },
    ];

    for (var order in orders) {
      await _firestore.collection('orders').add(order);
      print('  ✓ Created order for: ${order['studentName']}');
    }
  }

  Future<void> _seedUpcomingMenu() async {
    print('🔮 Seeding upcoming menu...');
    
    final upcomingItems = [
      {
        'name': {'en': 'Gourmet Beef Burger', 'fr': 'Burger de Bœuf Gourmet', 'ar': 'برجر لحم بقري فاخر'},
        'description': {
          'en': 'Premium beef burger with special sauce',
          'fr': 'Burger de bœuf premium avec sauce spéciale',
          'ar': 'برجر لحم بقري ممتاز مع صلصة خاصة'
        },
        'price': 50.0,
        'category': 'dishes',
        'date': Timestamp.fromDate(DateTime.now().add(const Duration(days: 4))),
        'voteCount': 24,
        'imageUrl': 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400',
      },
      {
        'name': {'en': 'Sushi Platter', 'fr': 'Plateau de Sushi', 'ar': 'طبق سوشي'},
        'description': {
          'en': 'Assorted fresh sushi rolls',
          'fr': 'Rouleaux de sushi frais assortis',
          'ar': 'مجموعة سوشي طازجة متنوعة'
        },
        'price': 65.0,
        'category': 'dishes',
        'date': Timestamp.fromDate(DateTime.now().add(const Duration(days: 6))),
        'voteCount': 18,
        'imageUrl': 'https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?w=400',
      },
      {
        'name': {'en': 'Classic Tiramisu', 'fr': 'Tiramisu Classique', 'ar': 'تيراميسو كلاسيكي'},
        'description': {
          'en': 'Italian coffee-flavored dessert',
          'fr': 'Dessert italien au café',
          'ar': 'حلوى إيطالية بنكهة القهوة'
        },
        'price': 28.0,
        'category': 'cakes-desserts',
        'date': Timestamp.fromDate(DateTime.now().add(const Duration(days: 3))),
        'voteCount': 32,
        'imageUrl': 'https://images.unsplash.com/photo-1571877227200-a0d98ea607e9?w=400',
      },
      {
        'name': {'en': 'Acai Smoothie Bowl', 'fr': 'Bol de Smoothie Açaï', 'ar': 'بول سموثي أساي'},
        'description': {
          'en': 'Healthy acai bowl with fresh fruits and granola',
          'fr': 'Bol d\'açaï sain avec fruits frais et granola',
          'ar': 'بول أساي صحي مع فواكه طازجة وجرانولا'
        },
        'price': 35.0,
        'category': 'breakfast',
        'date': Timestamp.fromDate(DateTime.now().add(const Duration(days: 5))),
        'voteCount': 15,
        'imageUrl': 'https://images.unsplash.com/photo-1590301157890-4810ed352733?w=400',
      },
    ];

    for (var item in upcomingItems) {
      await _firestore.collection('upcoming_menu').add(item);
      final nameMap = item['name'] as Map<String, dynamic>;
      print('  ✓ Created upcoming item: ${nameMap['en']}');
    }
  }

  /// Helper method to clear all data (use with caution!)
  Future<void> clearAllData() async {
    print('🗑️  Clearing all data...');
    
    final collections = ['users', 'products', 'orders', 'upcoming_menu'];
    
    for (var collection in collections) {
      final snapshot = await _firestore.collection(collection).get();
      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }
      print('  ✓ Cleared collection: $collection');
    }
    
    print('✅ All data cleared!');
  }
}
