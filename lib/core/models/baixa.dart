import 'package:cloud_firestore/cloud_firestore.dart';

class Baixa {
  final String idBaixa;
  final String idEstoque;
  final int quantidade;
  final DateTime data;
  final String idUsuario;

  Baixa({
    required this.idBaixa,
    required this.idEstoque,
    required this.quantidade,
    required this.data,
    required this.idUsuario,
  }
  );

  Map<String, dynamic> toMap() {
    return {
      'idBaixa': idBaixa,
      'idEstoque': idEstoque,
      'quantidade': quantidade,
      'data': data.toIso8601String(),
      'idUsuario': idUsuario,
    };
  }

  // Registra a baixa e atualiza o estoque
  Future<void> registrarBaixa() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentReference estoqueRef = firestore.collection('estoques').doc(idEstoque);
    DocumentReference baixaRef = firestore.collection('baixas').doc(idBaixa);

    try {
      await firestore.runTransaction((transaction) async {
        final estoqueSnapshot = await transaction.get(estoqueRef);
        if (!estoqueSnapshot.exists) throw Exception('Estoque não encontrado.');

        int quantidadeAtual = estoqueSnapshot['quantidade'] ?? 0;
        if (quantidade > quantidadeAtual) throw Exception('Quantidade insuficiente no estoque.');

        // Atualiza a quantidade no estoque
        transaction.update(estoqueRef, {'quantidade': quantidadeAtual - quantidade});

        // Registra a baixa na coleção "baixas"
        transaction.set(baixaRef, toMap());
      });

      print('Baixa registrada com sucesso!');
    } catch (e) {
      print('Erro ao registrar baixa: $e');
      rethrow;
    }
  }
}
