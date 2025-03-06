import 'dart:io';

class ProductFormData {
  String name;
  String type;
  String brand;
  String description;
  File? imageFile;
  String? imageUrl;

  ProductFormData({
    this.name = '',
    this.type = '',
    this.brand = '',
    this.description = '',
    this.imageFile,
    this.imageUrl,
  });

  dynamic get image => imageFile ?? imageUrl;
}
