import 'package:controle_estoque_app/core/models/product.dart';
import 'package:controle_estoque_app/core/models/product_form_data.dart';
import 'package:controle_estoque_app/core/models/user_data.dart';
import 'package:controle_estoque_app/core/services/product/product_firebase_service.dart';

abstract class ProductService {
  Stream<List<Product>> productsStream();

  Future<void> addProduct(UserData user, ProductFormData formData);

  Future<void> editProduct(
      UserData user, ProductFormData formData, Product product);

  Future<void> removeProduct(String productId);

  

  factory ProductService() => ProductFirebaseService();
}
