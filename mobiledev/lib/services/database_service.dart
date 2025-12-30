import 'dart:async';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../data/meal_model.dart';
import '../data/order_model.dart';
import '../data/upcoming_meal_model.dart';

class DatabaseService {
  // Singleton pattern
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;

  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Use getter to ensure we get the instance after settings are configured in main.dart
  FirebaseFirestore get _firestore => FirebaseFirestore.instance;

  DatabaseService._internal();

  // Collections
  // UPDATED: Changed from 'products' to 'meals' as requested
  CollectionReference get _mealsRef => _firestore.collection('meals');
  CollectionReference get _ordersRef => _firestore.collection('orders');
  CollectionReference get _upcomingRef =>
      _firestore.collection('upcoming_menu');
  CollectionReference get _usersRef => _firestore.collection('users');

  // ===== USER MANAGEMENT =====

  /// Verify user credentials
  Future<Map<String, dynamic>?> verifyUser(
    String username,
    String password,
  ) async {
    try {
      // 1. Try finding by 'username'
      var querySnapshot = await _usersRef
          .where('username', isEqualTo: username)
          .limit(1)
          .get();

      // 2. Try finding by 'email'
      if (querySnapshot.docs.isEmpty) {
        querySnapshot = await _usersRef
            .where('email', isEqualTo: username)
            .limit(1)
            .get();
      }

      // 3. Manual ID check
      if (querySnapshot.docs.isEmpty) {
        final doc = await _usersRef.doc(username).get();
        if (doc.exists) {
          final data = doc.data() as Map<String, dynamic>;
          if (data['password'] == password) {
            data['id'] = doc.id; // CRITICAL: Inject ID
            return data;
          }
        }
        return null;
      }

      final doc = querySnapshot.docs.first;
      final data = doc.data() as Map<String, dynamic>;

      if (data['password'] == password) {
        data['id'] = doc.id; // CRITICAL: Inject ID
        return data;
      }

      return null;
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  /// Stream user data (balance, etc)
  Stream<Map<String, dynamic>> getUserStream(String userId) {
    return _usersRef.doc(userId).snapshots().map((doc) {
      if (doc.exists && doc.data() != null) {
        return doc.data() as Map<String, dynamic>;
      } else {
        return {};
      }
    });
  }
  // ===== MEAL (PRODUCT) MANAGEMENT =====

  /// Get all meals as a stream
  Stream<List<Meal>> getMeals() {
    return _mealsRef.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Meal.fromJson(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  /// Add a new meal to the 'meals' collection
  // In lib/services/database_service.dart

  Future<String> addMeal(
    Meal meal, {
    Uint8List? imageBytes,
    String? imageName,
  }) async {
    try {
      String? imageUrl;

      // 1. Upload the image if bytes are provided
      if (imageBytes != null && imageName != null) {
        imageUrl = await _uploadImage(imageBytes, imageName, 'meals');
      }

      // 2. Convert meal to map
      final mealData = meal.toJson();

      // 3. IMPORTANT: Attach the URL to the data before saving
      if (imageUrl != null) {
        mealData['imageUrl'] = imageUrl;
      }

      // 4. Save to Firestore
      final docRef = await _mealsRef.add(mealData);
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to add meal: $e');
    }
  }

  /// Update an existing meal
  Future<void> updateMeal(
    String mealId,
    Meal meal, {
    Uint8List? newImageBytes,
    String? newImageName,
  }) async {
    try {
      String? imageUrl;
      if (newImageBytes != null && newImageName != null) {
        imageUrl = await _uploadImage(newImageBytes, newImageName, 'meals');
      }

      final mealData = meal.toJson();
      if (imageUrl != null) {
        mealData['imageUrl'] = imageUrl;
      }

      await _mealsRef.doc(mealId).update(mealData);
    } catch (e) {
      throw Exception('Failed to update meal: $e');
    }
  }

  /// Delete a meal
  Future<void> deleteMeal(String mealId) async {
    try {
      await _mealsRef.doc(mealId).delete();
    } catch (e) {
      throw Exception('Failed to delete meal: $e');
    }
  }

  // ===== ORDER MANAGEMENT =====

  Stream<List<RestaurantOrder>> getOrders({String? userId}) {
    Query query = _ordersRef.orderBy('createdAt', descending: true);

    // Filter by user ID if provided
    if (userId != null && userId.isNotEmpty) {
      query = query.where('userId', isEqualTo: userId);
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return RestaurantOrder.fromJson(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }).toList();
    });
  }

  Future<String> createOrder(RestaurantOrder order) async {
    try {
      final docRef = await _ordersRef.add(order.toJson());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create order: $e');
    }
  }

  Future<void> updateOrder(String orderId, RestaurantOrder order) async {
    try {
      await _ordersRef.doc(orderId).update(order.toJson());
    } catch (e) {
      throw Exception('Failed to update order: $e');
    }
  }

  Future<void> deleteOrder(String orderId) async {
    try {
      await _ordersRef.doc(orderId).delete();
    } catch (e) {
      throw Exception('Failed to delete order: $e');
    }
  }

  Future<void> updateOrderStatus(
    String orderId,
    String status, {
    String feedback = '',
  }) async {
    try {
      final updates = {'status': status};
      if (feedback.isNotEmpty) {
        updates['feedback'] = feedback;
      }
      await _ordersRef.doc(orderId).update(updates);
    } catch (e) {
      throw Exception('Failed to update order status: $e');
    }
  }

  Future<void> removeItemFromOrder(String orderId, String itemKey) async {
    try {
      final doc = await _ordersRef.doc(orderId).get();
      if (!doc.exists) return;

      final data = doc.data() as Map<String, dynamic>;
      final items = Map<String, dynamic>.from(data['items'] ?? {});

      if (items.containsKey(itemKey)) {
        final removedItem = items[itemKey] as Map<String, dynamic>;
        final itemPrice = (removedItem['price'] as num?)?.toDouble() ?? 0.0;
        final itemQuantity = (removedItem['quantity'] as num?)?.toInt() ?? 1;

        items.remove(itemKey);

        final double currentTotal = (data['total'] as num?)?.toDouble() ?? 0.0;
        final double newTotal = currentTotal - (itemPrice * itemQuantity);

        await _ordersRef.doc(orderId).update({
          'items': items,
          'total': newTotal,
        });
      }
    } catch (e) {
      throw Exception('Failed to remove item: $e');
    }
  }

  // ===== UPCOMING MENU MANAGEMENT =====

  Stream<List<UpcomingMeal>> getUpcomingMeals() {
    return _upcomingRef.orderBy('date', descending: false).snapshots().map((
      snapshot,
    ) {
      return snapshot.docs.map((doc) {
        return UpcomingMeal.fromJson(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }).toList();
    });
  }

  Future<String> addUpcomingMeal(
    UpcomingMeal meal, {
    Uint8List? imageBytes,
    String? imageName,
  }) async {
    try {
      String? imageUrl;
      if (imageBytes != null && imageName != null) {
        imageUrl = await _uploadImage(imageBytes, imageName, 'upcoming');
      }

      final mealData = meal.toJson();
      if (imageUrl != null) {
        mealData['imageUrl'] = imageUrl;
      }

      final docRef = await _upcomingRef.add(mealData);
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to add upcoming meal: $e');
    }
  }

  Future<void> updateUpcomingMeal(
    String mealId,
    UpcomingMeal meal, {
    Uint8List? newImageBytes,
    String? newImageName,
  }) async {
    try {
      String? imageUrl;
      if (newImageBytes != null && newImageName != null) {
        imageUrl = await _uploadImage(newImageBytes, newImageName, 'upcoming');
      }

      final mealData = meal.toJson();
      if (imageUrl != null) {
        mealData['imageUrl'] = imageUrl;
      }

      await _upcomingRef.doc(mealId).update(mealData);
    } catch (e) {
      throw Exception('Failed to update upcoming meal: $e');
    }
  }

  Future<void> deleteUpcomingMeal(String mealId) async {
    try {
      await _upcomingRef.doc(mealId).delete();
    } catch (e) {
      throw Exception('Failed to delete upcoming meal: $e');
    }
  }

  Future<void> voteForMeal(String mealId) async {
    try {
      await _upcomingRef.doc(mealId).update({
        'voteCount': FieldValue.increment(1),
      });
    } catch (e) {
      throw Exception('Failed to vote: $e');
    }
  }

  Future<void> removeVoteForMeal(String mealId) async {
    try {
      await _upcomingRef.doc(mealId).update({
        'voteCount': FieldValue.increment(-1),
      });
    } catch (e) {
      throw Exception('Failed to remove vote: $e');
    }
  }

  // ===== HELPER METHODS =====

  Future<String> _uploadImage(
    Uint8List imageBytes,
    String imageName,
    String folder,
  ) async {
    try {
      final String fileName =
          '${DateTime.now().millisecondsSinceEpoch}_$imageName';
      final Reference storageRef = _storage.ref().child('$folder/$fileName');

      final metadata = SettableMetadata(contentType: 'image/jpeg');

      final UploadTask uploadTask = storageRef.putData(imageBytes, metadata);
      final TaskSnapshot snapshot = await uploadTask;

      final String downloadUrl = await snapshot.ref.getDownloadURL().timeout(
        const Duration(seconds: 20),
        onTimeout: () =>
            throw Exception('Upload timed out. Please check your connection.'),
      );
      return downloadUrl;
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }
}
