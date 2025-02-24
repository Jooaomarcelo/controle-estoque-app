import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_estoque_app/core/models/product.dart';
import 'package:controle_estoque_app/core/models/product_form_data.dart';
import 'package:controle_estoque_app/core/models/user_data.dart';
import 'package:controle_estoque_app/core/services/product/product_service.dart';

class ProductFirebaseService implements ProductService {
  @override
  Stream<List<Product>> productsStream() {
    final store = FirebaseFirestore.instance;

    final snapshot = store
        .collection('products')
        .orderBy('dataCadastro', descending: true)
        .withConverter(fromFirestore: _fromFirestore, toFirestore: _toFirestore)
        .snapshots();

    return snapshot.map((snap) => snap.docs.map((doc) => doc.data()).toList());
  }

  @override
  Future<void> addProduct(UserData user, ProductFormData formData) async {
    final store = FirebaseFirestore.instance;

    final product = Product(
      id: '',
      name: formData.name,
      type: formData.type,
      brand: formData.brand,
      description: formData.description,
      createdAt: DateTime.now(),
      lastEdited: DateTime.now(),
      userIdLastUpdated: user.id,
    );

    await store
        .collection('products')
        .withConverter(fromFirestore: _fromFirestore, toFirestore: _toFirestore)
        .add(product);
  }

  @override
  Future<void> editProduct(
    UserData user,
    ProductFormData formData,
    Product product,
  ) async {
    final store = FirebaseFirestore.instance;

    final editedProduct = Product(
      id: '',
      name: formData.name,
      type: formData.type,
      brand: formData.brand,
      description: formData.description,
      createdAt: DateTime.now(),
      lastEdited: DateTime.now(),
      userIdLastUpdated: user.id,
    );

    await store
        .collection('products')
        .doc(product.id)
        .withConverter(fromFirestore: _fromFirestore, toFirestore: _toFirestore)
        .set(editedProduct);
  }

  @override
  Future<void> removeProduct(String productId) async {
    final store = FirebaseFirestore.instance;

    await store.collection('products').doc(productId).delete();
  }

  Product _fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
    SnapshotOptions? options,
  ) {
    return Product(
      id: doc.id,
      name: doc['nome'],
      type: doc['tipo'],
      brand: doc['marca'],
      description: doc['descricao'],
      createdAt: DateTime.parse(doc['dataCadastro']),
      lastEdited: DateTime.parse(doc['dataUltimaEdicao']),
      userIdLastUpdated: doc['idUsuarioEditou'],
    );
  }

  Map<String, dynamic> _toFirestore(Product product, SetOptions? options) {
    return {
      'nome': product.name,
      'tipo': product.type,
      'marca': product.brand,
      'descricao': product.description,
      'dataCadastro': product.createdAt.toIso8601String(),
      'dataUltimaEdicao': product.lastEdited.toIso8601String(),
      'idUsuarioEditou': product.userIdLastUpdated,
    };
  }
}
