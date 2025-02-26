import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:controle_estoque_app/core/models/estoque.dart';

class EstoqueFirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Stream para escutar mudanças no estoque em tempo real
  Stream<List<Estoque>> estoqueStream() {
    return _firestore.collection('estoques').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Estoque.fromMap(doc.id, doc.data())).toList();
    });
  }

  // Adicionar um novo estoque
  Future<void> addEstoque(Estoque estoque) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("Usuário não autenticado");

    final novoEstoque = estoque.copyWith(
      idUsuarioEditou: user.uid,
      dataCadastro: DateTime.now(),
      dataUltimaEdicao: DateTime.now(),
    );

    await _firestore.collection('estoques').add(novoEstoque.toMap());
  }

  // Editar um estoque existente
  Future<void> editEstoque(Estoque estoque) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("Usuário não autenticado");

    final estoqueAtualizado = estoque.copyWith(
      idUsuarioEditou: user.uid,
      dataUltimaEdicao: DateTime.now(),
    );

    await _firestore.collection('estoques').doc(estoque.id).update(estoqueAtualizado.toMap());
  }

  // Remover um estoque
  Future<void> removeEstoque(String id) async {
    await _firestore.collection('estoques').doc(id).delete();
  }

  // Dar baixa (atualizar a quantidade de um estoque)
  Future<void> darBaixa(String id, int quantidadeBaixa) async {
    final doc = await _firestore.collection('estoques').doc(id).get();
    if (!doc.exists) throw Exception("Estoque não encontrado");

    final estoque = Estoque.fromMap(doc.id, doc.data()!);

    final novaQuantidade = estoque.quantidade - quantidadeBaixa;
    if (novaQuantidade < 0) throw Exception("Quantidade insuficiente no estoque!");

    await _firestore.collection('estoques').doc(id).update({
      'quantidade': novaQuantidade,
      'dataUltimaEdicao': DateTime.now().toIso8601String(),
      'idUsuarioEditou': _auth.currentUser?.uid,
    });
  }
}
