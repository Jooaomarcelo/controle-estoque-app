import 'dart:io';

import 'package:controle_estoque_app/core/models/product.dart';
import 'package:controle_estoque_app/core/models/product_form_data.dart';
import 'package:controle_estoque_app/core/models/user_data.dart';

import 'package:controle_estoque_app/core/services/product/product_service.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

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

  Future<String?> _uploadProductImage(File? image, String imageName) async {
    if (image == null) return '';
    final storage = FirebaseStorage.instance;

    final imageRef = storage.ref().child('images').child(imageName);
    await imageRef.putFile(image).whenComplete(() {});

    return await imageRef.getDownloadURL();
  }

  @override
  Future<void> addProduct(UserData user, ProductFormData formData) async {
    final store = FirebaseFirestore.instance;

    // Upload da imagem do produto
    final imageName = formData.imageFile != null
        ? formData.imageFile!.path.split('/').last.replaceAll('scaled_', '')
        : '${formData.name.trim().toLowerCase().replaceAll(' ', '_')}.jpg}';

    final imageUrl = await _uploadProductImage(formData.image, imageName);

    final product = Product(
      id: '',
      name: formData.name,
      type: formData.type,
      brand: formData.brand,
      description: formData.description,
      image: imageUrl,
      createdAt: DateTime.now(),
      lastEdited: DateTime.now(),
      userIdLastUpdated: user.id!,
      userEmailLastUpdated: user.email,
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

    // Upload da imagem do produto
    final imageName = formData.imageFile != null
        ? formData.imageFile!.path.split('/').last.replaceAll('scaled_', '')
        : '${formData.name.trim().toLowerCase().replaceAll(' ', '_')}.jpg}';

    final imageUrl = await _uploadProductImage(formData.imageFile, imageName);

    final editedProduct = Product(
      id: '',
      name: formData.name,
      type: formData.type,
      brand: formData.brand,
      description: formData.description,
      image: imageUrl == '' ? product.image : imageUrl,
      createdAt: product.createdAt,
      lastEdited: DateTime.now(),
      userIdLastUpdated: user.id!,
      userEmailLastUpdated: user.email,
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
      image: doc['imagemUrl'],
      createdAt: DateTime.parse(doc['dataCadastro']),
      lastEdited: DateTime.parse(doc['dataUltimaEdicao']),
      userIdLastUpdated: doc['idUsuarioEditou'],
      userEmailLastUpdated: doc['emailUsuarioEditou'],
    );
  }

  Map<String, dynamic> _toFirestore(Product product, SetOptions? options) {
    return {
      'nome': product.name,
      'tipo': product.type,
      'marca': product.brand,
      'descricao': product.description,
      'imagemUrl': product.image,
      'dataCadastro': product.createdAt.toIso8601String(),
      'dataUltimaEdicao': product.lastEdited.toIso8601String(),
      'idUsuarioEditou': product.userIdLastUpdated,
      'emailUsuarioEditou': product.userEmailLastUpdated,
    };
  }

  Future<List<Product>> buscarProdutos() async {
    final store = FirebaseFirestore.instance;

    try {
      // Buscar todos os produtos ordenados por data de cadastro
      final snapshot = await store
          .collection('products')
          .orderBy('dataCadastro', descending: true)
          .get();

      // Converter os dados de cada documento para instâncias de Product
      final produtos = snapshot.docs.map((doc) {
        return _fromFirestore(doc, null);
      }).toList();

      return produtos;
    } catch (e) {
      print('Erro ao buscar produtos: $e');
      return [];
    }
  }
}
