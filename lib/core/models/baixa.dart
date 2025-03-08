import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_estoque_app/components/mensagem_erro_baixa.dart';
import 'package:flutter/material.dart';

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
  Future<void> registrarBaixa(BuildContext context) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentReference estoqueRef = firestore.collection('estoques').doc(idEstoque);
    DocumentReference baixaRef = firestore.collection('baixas').doc(idBaixa);

    try {
      await firestore.runTransaction((transaction) async {
        final estoqueSnapshot = await transaction.get(estoqueRef);
        if (!estoqueSnapshot.exists) throw Exception('Estoque não encontrado.');

        int quantidadeAtual = estoqueSnapshot['quantidade'] ?? 0;
        if (quantidade > quantidadeAtual){
        showDialog(
          context: context,
          builder: (context) => MensagemErro(
            mensagem: "Quantidade maior do que o limite máximo disponível no estoque.",
            limiteDisponivel: quantidadeAtual,
          ),
          
        );
        
        throw Exception('Quantidade insuficiente no estoque.');
        }

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
