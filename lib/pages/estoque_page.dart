import 'package:controle_estoque_app/core/services/estoque/estoque_firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:controle_estoque_app/core/models/estoque.dart';
import 'package:controle_estoque_app/pages/adicionar_estoque_page.dart';

class EstoquePage extends StatelessWidget {
  final EstoqueFirebaseService _estoqueService = EstoqueFirebaseService();

  EstoquePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Gerenciar Estoque"),
      ),
      body: StreamBuilder<List<Estoque>>(
        stream: _estoqueService.estoqueStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("Nenhum estoque cadastrado."));
          }

          final estoques = snapshot.data!;

          return ListView.builder(
            itemCount: estoques.length,
            itemBuilder: (context, index) {
              final estoque = estoques[index];

              return Card(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  title: Text("Produto: ${estoque.idProduto}"),
                  subtitle: Text("Lote: ${estoque.lote} | Quantidade: ${estoque.quantidade}"),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'editar') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AdicionarEstoquePage(estoque: estoque),
                          ),
                        );
                      } else if (value == 'dar_baixa') {
                        _exibirDialogoBaixa(context, estoque);
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(value: 'editar', child: Text("Editar")),
                      PopupMenuItem(value: 'dar_baixa', child: Text("Dar Baixa")),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AdicionarEstoquePage(),
            ),
          );
        },
      ),
    );
  }

  void _exibirDialogoBaixa(BuildContext context, Estoque estoque) {
    final TextEditingController quantidadeController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Dar Baixa no Estoque"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Quantidade atual: ${estoque.quantidade}"),
              SizedBox(height: 10),
              TextField(
                controller: quantidadeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: "Quantidade a dar baixa"),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text("Cancelar"),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: Text("Confirmar"),
              onPressed: () async {
                int quantidade = int.tryParse(quantidadeController.text) ?? 0;
                if (quantidade > 0) {
                  await _estoqueService.darBaixa(estoque.id, quantidade);
                  Navigator.pop(context);
                }
              },
            ),
          ],
        );
      },
    );
  }
}
