class Product {
  final String id;
  final String name;
  final String type;
  final String brand;
  String? description;
  String? image;
  final DateTime createdAt;
  final DateTime lastEdited;
  final String userIdLastUpdated;
  final String userEmailLastUpdated;

  Product({
    required this.id,
    required this.name,
    required this.type,
    required this.brand,
    this.description,
    this.image,
    required this.createdAt,
    required this.lastEdited,
    required this.userIdLastUpdated,
    required this.userEmailLastUpdated,
  });
}
