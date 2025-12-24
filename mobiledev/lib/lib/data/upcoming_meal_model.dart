import 'package:cloud_firestore/cloud_firestore.dart';

class UpcomingMeal {
  final String id;
  final Map<String, String> name;
  final Map<String, String> description;
  final double price;
  final String category;
  final DateTime date;
  final String? imageUrl;
  final int voteCount;

  UpcomingMeal({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.date,
    this.voteCount = 0,
    this.imageUrl,
  });

  factory UpcomingMeal.fromJson(Map<String, dynamic> json, String id) {
    return UpcomingMeal(
      id: id,
      name: Map<String, String>.from(json['name'] ?? {'en': 'Unknown'}),
      description: Map<String, String>.from(json['description'] ?? {'en': ''}),
      price: (json['price'] ?? 0).toDouble(),
      category: json['category'] ?? 'uncategorized',
      date: (json['date'] as Timestamp).toDate(),
      voteCount: json['voteCount'] ?? 0,
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'category': category,
      'date': Timestamp.fromDate(date),
      'voteCount': voteCount,
      'imageUrl': imageUrl,
    };
  }

  UpcomingMeal copyWith({
    String? id,
    Map<String, String>? name,
    Map<String, String>? description,
    double? price,
    String? category,
    DateTime? date,
    int? voteCount,
    String? imageUrl,
  }) {
    return UpcomingMeal(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      category: category ?? this.category,
      date: date ?? this.date,
      voteCount: voteCount ?? this.voteCount,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
