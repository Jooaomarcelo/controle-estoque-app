import 'dart:async';

import 'package:controle_estoque_app/components/new_estoque.dart';
import 'package:controle_estoque_app/components/search_product_bar_estoque.dart';
import 'package:controle_estoque_app/core/models/estoque.dart';
import 'package:controle_estoque_app/core/services/estoque/estoque_firebase_service.dart';
import 'package:controle_estoque_app/core/services/product/product_firebase_service.dart';
import 'package:controle_estoque_app/pages/adicionar_estoque_page.dart' show AdicionarEstoquePage;
import 'package:flutter/material.dart';

class EstoquePage1 extends StatefulWidget {
  const EstoquePage1({Key? key}) : super(key: key);

  @override
  State<EstoquePage1> createState() => _EstoquePage1State();
}
class _EstoquePage1State extends State<EstoquePage1> {
  final EstoqueFirebaseService _estoqueService = EstoqueFirebaseService();
  final ProductFirebaseService _productService = ProductFirebaseService();
  String _searchQuery = "";
  Map<String, String> _productNames = {};

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/images/estoque.png', height: 30),
            const SizedBox(width: 15),
            const Text("Estoque"),
          ],
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
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: estoquesFiltrados.length,
                      itemBuilder: (context, index) {
                        final estoque = estoquesFiltrados[index];
                        final nomeProduto =
                            _productNames[estoque.idProduto] ?? "Produto desconhecido";
                        return Card(
                          child: ListTile(
                            title: Text(nomeProduto),
                            subtitle: Text(
                              "Lote: ${estoque.lote}, Quantidade: ${estoque.quantidade}",
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AdicionarEstoquePage(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}