import 'package:cloud_firestore/cloud_firestore.dart';

class RestaurantOrder {
  final String id;
  final DateTime createdAt;
  final double total;
  final String status;
  final Map<String, dynamic> items;
  final String userId; // Added
  final String studentName;
  final String pickupTime;
  final String type;
  final String feedback;

  RestaurantOrder({
    required this.id,
    required this.createdAt,
    required this.total,
    required this.status,
    required this.items,
    required this.userId, // Required
    this.studentName = 'Student',
    this.pickupTime = 'ASAP',
    this.type = 'Eat In',
    this.feedback = '',
  });

  factory RestaurantOrder.fromJson(Map<String, dynamic> json, String id) {
    return RestaurantOrder(
      id: id,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      total: (json['total'] ?? 0).toDouble(),
      status: json['status'] ?? 'Pending',
      items: Map<String, dynamic>.from(json['items'] ?? {}),
      userId: json['userId'] ?? '', // Handle migration
      studentName: json['studentName'] ?? 'Student',
      pickupTime: json['pickupTime'] ?? 'ASAP',
      type: json['type'] ?? 'Eat In',
      feedback: json['feedback'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'createdAt': Timestamp.fromDate(createdAt),
      'total': total,
      'status': status,
      'items': items,
      'userId': userId, // Save to DB
      'studentName': studentName,
      'pickupTime': pickupTime,
      'type': type,
      'feedback': feedback,
    };
  }

  RestaurantOrder copyWith({
    String? id,
    DateTime? createdAt,
    double? total,
    String? status,
    Map<String, dynamic>? items,
    String? userId,
    String? studentName,
    String? pickupTime,
    String? type,
    String? feedback,
  }) {
    return RestaurantOrder(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      total: total ?? this.total,
      status: status ?? this.status,
      items: items ?? this.items,
      userId: userId ?? this.userId,
      studentName: studentName ?? this.studentName,
      pickupTime: pickupTime ?? this.pickupTime,
      type: type ?? this.type,
      feedback: feedback ?? this.feedback,
    );
  }
}