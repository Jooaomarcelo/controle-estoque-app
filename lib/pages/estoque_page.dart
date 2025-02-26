import 'package:controle_estoque_app/core/models/product.dart';
import 'package:controle_estoque_app/core/services/estoque/estoque_firebase_service.dart';
import 'package:controle_estoque_app/core/services/product/product_firebase_service.dart';
import 'package:controle_estoque_app/core/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:controle_estoque_app/core/models/estoque.dart';
import 'package:controle_estoque_app/pages/adicionar_estoque_page.dart';


class EstoquePage extends StatefulWidget {
  final EstoqueFirebaseService _estoqueService = EstoqueFirebaseService();
  final ProductFirebaseService _produtoService = ProductFirebaseService();
  
  
  
  @override
  _EstoquePageState createState() => _EstoquePageState();
}

class _EstoquePageState extends State<EstoquePage> {
  List<Product> _produtos = [];
 
  @override
  void initState() {
    super.initState();
    _carregarProdutos();
  }

  // Carregar os produtos
  Future<void> _carregarProdutos() async {
    final produtos = await widget._produtoService.buscarProdutos();
    setState(() {
      _produtos = produtos;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Gerenciar Estoque"),
      ),
      body: StreamBuilder<List<Estoque>>(
        stream: widget._estoqueService.estoqueStream(),
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
              // Encontrar o nome do produto pelo idProduto
              final produto = _produtos.firstWhere(
                (produto) => produto.id == estoque.idProduto,
                orElse: () => Product(id: '', name: 'Produto não encontrado',type: '',brand: '',createdAt: DateTime(0,0,0),lastEdited: DateTime(0,0,0) ,userIdLastUpdated: ''),
              );

              return Card(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  title: Text("Produto: ${produto.name}"), // Exibindo o nome do produto
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
    final userId = UserService().currentUser?.id;


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
                if (quantidade > 0 && userId != null) {
                  await widget._estoqueService.darBaixa(estoque.id, quantidade,userId!);
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erro: Quantidade inválida ou usuário não identificado.'))
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}