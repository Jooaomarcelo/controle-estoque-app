import 'package:controle_estoque_app/core/models/product.dart';
import 'package:controle_estoque_app/core/services/estoque/estoque_firebase_service.dart';
import 'package:controle_estoque_app/core/services/product/product_firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:controle_estoque_app/core/models/estoque.dart';

class AdicionarEstoquePage extends StatefulWidget {
  final Estoque? estoque; // Estoque para edição (opcional)

  const AdicionarEstoquePage({Key? key, this.estoque}) : super(key: key);

  @override
  _AdicionarEstoquePageState createState() => _AdicionarEstoquePageState();
}

class _AdicionarEstoquePageState extends State<AdicionarEstoquePage> {
  final _formKey = GlobalKey<FormState>();
  final EstoqueFirebaseService _estoqueService = EstoqueFirebaseService();
  final ProductFirebaseService _produtoService = ProductFirebaseService();

  final TextEditingController _loteController = TextEditingController();
  final TextEditingController _quantidadeController = TextEditingController();
  final TextEditingController _dataValidadeController = TextEditingController();

  List<Product> _produtos = [];
  String? _produtoSelecionado; // ID do produto selecionado

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarProdutos();

    if (widget.estoque != null) {
      // Preencher os campos com os dados do estoque existente
      _produtoSelecionado = widget.estoque!.idProduto;
      _loteController.text = widget.estoque!.lote.toString();
      _quantidadeController.text = widget.estoque!.quantidade.toString();
      _dataValidadeController.text = widget.estoque!.dataValidade.toIso8601String();
    }
  }

  Future<void> _carregarProdutos() async {
    final produtos = await _produtoService.buscarProdutos();
    setState(() {
      _produtos = produtos;
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _loteController.dispose();
    _quantidadeController.dispose();
    _dataValidadeController.dispose();
    super.dispose();
  }

  Future<void> _salvarEstoque() async {
    if (_formKey.currentState!.validate()) {
      if (_produtoSelecionado == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Selecione um produto!")),
        );
        return;
      }

      final lote = int.tryParse(_loteController.text) ?? 0;
      final quantidade = int.tryParse(_quantidadeController.text) ?? 0;
      final dataValidade = DateTime.tryParse(_dataValidadeController.text) ?? DateTime.now();

      final estoque = Estoque(
        id: widget.estoque?.id ?? "", // Gerado pelo Firebase se for novo
        idProduto: _produtoSelecionado!,
        lote: lote,
        quantidade: quantidade,
        dataValidade: dataValidade,
        dataCadastro: widget.estoque?.dataCadastro ?? DateTime.now(),
        dataUltimaEdicao: DateTime.now(),
        idUsuarioEditou: "user_id_aqui", // Substituir pelo ID do usuário autenticado
      );

      if (widget.estoque == null) {
        await _estoqueService.addEstoque(estoque);
      } else {
        await _estoqueService.editEstoque(estoque);
      }

      Navigator.pop(context);
    }
  }

  Future<void> _selectDataValidade() async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (selectedDate != null) {
      setState(() {
        _dataValidadeController.text = selectedDate.toIso8601String().split('T').first;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.estoque == null ? "Adicionar Estoque" : "Editar Estoque"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Carregamento dos produtos com indicador de progresso
              if (_isLoading)
                Center(child: CircularProgressIndicator())
              else
                DropdownButtonFormField<String>(
                  value: _produtoSelecionado,
                  onChanged: (value) {
                    setState(() {
                      _produtoSelecionado = value;
                    });
                  },
                  items: _produtos.map((produto) {
                    return DropdownMenuItem(
                      value: produto.id,
                      child: Text(produto.name),
                    );
                  }).toList(),
                  decoration: InputDecoration(labelText: "Selecione um Produto"),
                  validator: (value) => value == null ? "Selecione um produto" : null,
                ),

              // Lote
              TextFormField(
                controller: _loteController,
                decoration: InputDecoration(labelText: "Lote"),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? "Campo obrigatório" : null,
              ),
              // Quantidade
              TextFormField(
                controller: _quantidadeController,
                decoration: InputDecoration(labelText: "Quantidade"),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty || int.tryParse(value) == null || int.parse(value) <= 0 ? "Quantidade inválida" : null,
              ),
              // Data de Validade com DatePicker
              TextFormField(
                controller: _dataValidadeController,
                decoration: InputDecoration(labelText: "Data de Validade (YYYY-MM-DD)"),
                readOnly: true,
                onTap: _selectDataValidade,
                validator: (value) => value!.isEmpty ? "Campo obrigatório" : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _salvarEstoque,
                child: Text(widget.estoque == null ? "Adicionar" : "Salvar Alterações"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
