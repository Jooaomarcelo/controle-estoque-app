import 'dart:io';

class Product {
  final String id;
  final String name;
  final String type;
  final String brand;
  String? description;
  File? image;
  final DateTime createdAt;
  final DateTime lastEdited;
  final String userIdLastUpdated;

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
  });
}
