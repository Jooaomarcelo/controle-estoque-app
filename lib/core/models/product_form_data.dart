import 'dart:io';

class ProductFormData {
  String name;
  String type;
  String brand;
  String description;
  File? image;

  ProductFormData({
    this.name = '',
    this.type = '',
    this.brand = '',
    this.description = '',
    this.image,
  });
}