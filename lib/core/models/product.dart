class Product {
  final String id;
  final String name;
  final String type;
  final String brand;
  String? description;
  final DateTime createdAt;
  final DateTime lastEdited;
  final String userIdLastUpdated;

  Product({
    required this.id,
    required this.name,
    required this.type,
    required this.brand,
    this.description,
    required this.createdAt,
    required this.lastEdited,
    required this.userIdLastUpdated,
  });
}
