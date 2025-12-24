class Meal {
  final String id;
  final Map<String, String> name;
  final Map<String, String> description;
  final double price;
  final String category;
  final String? imageUrl;

  Meal({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    this.imageUrl,
  });

  factory Meal.fromJson(Map<String, dynamic> json, String id) {
    return Meal(
      id: id,
      name: Map<String, String>.from(json['name'] ?? {'en': 'Unknown'}),
      description: Map<String, String>.from(json['description'] ?? {'en': ''}),
      price: (json['price'] ?? 0).toDouble(),
      category: json['category'] ?? 'uncategorized',
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'category': category,
      'imageUrl': imageUrl,
    };
  }

  Meal copyWith({
    String? id,
    Map<String, String>? name,
    Map<String, String>? description,
    double? price,
    String? category,
    String? imageUrl,
  }) {
    return Meal(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
