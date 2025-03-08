import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_estoque_app/components/estoque_item.dart';
import 'package:controle_estoque_app/components/new_estoque_button.dart';
import 'package:controle_estoque_app/components/search_product_bar_estoque.dart';
import 'package:controle_estoque_app/core/models/baixa.dart';
import 'package:controle_estoque_app/core/models/estoque.dart';
import 'package:controle_estoque_app/core/services/estoque/estoque_firebase_service.dart';
import 'package:controle_estoque_app/core/services/product/product_firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';



class EstoquePage1 extends StatefulWidget {
  const EstoquePage1({super.key});

  @override
  State<EstoquePage1> createState() => _EstoquePage1State();
}

class _EstoquePage1State extends State<EstoquePage1> {
  final EstoqueFirebaseService _estoqueService = EstoqueFirebaseService();
  final ProductFirebaseService _productService = ProductFirebaseService();
  
  String _searchQuery = "";
  Map<String, String> _productNames = {};
  final Map<String, int> _quantidadesAjustadas = {}; // Para armazenar as quantidades ajustadas

  @override
  void initState() {
    super.initState();
    _loadProductNames();
  }

  Future<void> _loadProductNames() async {
    final produtos = await _productService.buscarProdutos();
    setState(() {
      _productNames = {for (var p in produtos) p.id: p.name};
    });
  }

  void _updateSearch(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
    });
  }

  void _atualizarQuantidade(String estoqueId, int novaQuantidade) {
    setState(() {
      _quantidadesAjustadas[estoqueId] = novaQuantidade; // Atualiza a quantidade ajustada
    });
  }

  Future<void> salvarBaixas() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Usuário não autenticado!')),
    );
    return;
  }

  if (_quantidadesAjustadas.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Nenhuma alteração feita.')),
    );
    return;
  }

  try {
    for (var entry in _quantidadesAjustadas.entries) {
      final estoqueId = entry.key;
      final quantidade = entry.value;

      if (quantidade > 0) { // Só registrar se a quantidade for maior que 0
        final baixa = Baixa(
          idBaixa: FirebaseFirestore.instance.collection('baixas').doc().id, // Gerando um novo ID
          idEstoque: estoqueId,
          quantidade: quantidade,
          data: DateTime.now(),
          idUsuario: user.uid,
        );

        await baixa.registrarBaixa();
      }
    }

    setState(() {
      _quantidadesAjustadas.clear(); // Limpa as baixas registradas
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Baixas salvas com sucesso!')),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erro ao salvar baixas: $e')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/estoque.png',
              height: 30,
              color: Colors.white,
            ),
            const SizedBox(width: 15),
            const Text(
              'Estoque',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/images/Seta.svg',
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
            child: SearchProductBar(onSearch: _updateSearch),
          ),
          Expanded(
            child: StreamBuilder<List<Estoque>>(
              stream: _estoqueService.estoqueStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("Nenhum estoque encontrado"));
                }

                final estoquesFiltrados = snapshot.data!.where((estoque) {
                  final nomeProduto = _productNames[estoque.idProduto] ?? "";
                  return nomeProduto.toLowerCase().contains(_searchQuery);
                }).toList();

                if (estoquesFiltrados.isEmpty) {
                  return const Center(child: Text("Nenhum item encontrado"));
                }

                return SingleChildScrollView(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7715,
                    child: ListView.builder(
                      padding: const EdgeInsets.only(bottom: 70),
                      itemCount: estoquesFiltrados.length,
                      itemBuilder: (context, index) {
                        final estoque = estoquesFiltrados[index];
                        return EstoqueItem(
                          key: ValueKey(estoque.id),
                          estoque: estoque,
                          nomeProduto: _productNames[estoque.idProduto] ?? 'Produto desconhecido',
                          initialQuantidade: _quantidadesAjustadas[estoque.id] ?? 0,
                          onQuantidadeAlterada: _atualizarQuantidade,
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
         // NewEstoqueButtton(onPressed:salvarBaixas),
        ],
      ),
     floatingActionButton: NewEstoqueButtton(onPressed: salvarBaixas),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}