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
  Future<void> darBaixa(String estoqueId, int quantidade, String userId) async {
    final estoqueRef = _firestore.collection('estoques').doc(estoqueId);
    final baixaRef = _firestore.collection('baixas').doc();

    try {
      await _firestore.runTransaction((transaction) async {
        final estoqueSnapshot = await transaction.get(estoqueRef);
        
        if (!estoqueSnapshot.exists) throw Exception('Estoque não encontrado.');

        int quantidadeAtual = estoqueSnapshot['quantidade'] ?? 0;
        if (quantidade > quantidadeAtual) throw Exception('Quantidade insuficiente no estoque.');

        // Atualiza a quantidade no estoque
        transaction.update(estoqueRef, {'quantidade': quantidadeAtual - quantidade});

        // Cria um registro na coleção "baixa"
        transaction.set(baixaRef, {
          'idEstoque': estoqueId,
          'quantidade': quantidade,
          'data': Timestamp.now(),
          'idUsuario': userId,
        });
      });
    } catch (e) {
      print('Erro ao dar baixa: $e');
      rethrow;
    }
  }
}