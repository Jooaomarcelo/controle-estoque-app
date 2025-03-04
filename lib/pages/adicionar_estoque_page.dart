import 'dart:io';

import 'package:controle_estoque_app/components/image_picker_widget.dart';
import 'package:controle_estoque_app/core/models/product.dart';
import 'package:controle_estoque_app/core/models/product_form_data.dart';
import 'package:controle_estoque_app/core/services/estoque/estoque_firebase_service.dart';
import 'package:controle_estoque_app/core/services/product/product_firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:controle_estoque_app/core/models/estoque.dart';
import 'package:image_picker/image_picker.dart';

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
  File? _imagemSelecionada;
  final ImagePicker _picker = ImagePicker();

  List<Product> _produtos = [];
  String? _produtoSelecionado; // ID do produto selecionado
  bool _isLoading = true;
  late ProductFormData _formData;

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

  Future<void> _selecionarImagem() async {
  final XFile? imagem = await _picker.pickImage(
    source: ImageSource.gallery, 
  );

  if (imagem != null) {
    setState(() {
      _imagemSelecionada = File(imagem.path);
    });
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
      //appBar:  AppBar(
        //centerTitle: true,
        //title: Text(widget.estoque == null ? "Adicionar Estoque" : "Editar Estoque"),
      //),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ImagePickerWidget(
                image: _imagemSelecionada == null ? '' : _imagemSelecionada!.path,
                onImagePicked: (image) {
                  setState(() {
                    _imagemSelecionada = image;
                  });
                 
                },
              ),

              SizedBox(height:15),

              Text('Produto', style: Theme.of(context).textTheme.labelMedium),
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
                  
                  validator: (value) => value == null ? "Selecione um produto" : null,
                  decoration: InputDecoration(
                    labelText: 'Selecione um Produto ',
                    labelStyle: Theme.of(context).textTheme.bodySmall,
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                          width: 2, color: Theme.of(context).colorScheme.primary),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 3, color: Theme.of(context).colorScheme.primary),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  ),
                ),
              
              SizedBox(height:15),

              Text('Lote', style: Theme.of(context).textTheme.labelMedium),

              SizedBox(height: 5),
              // Lote
              TextFormField(
                controller: _loteController,
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? "Campo obrigatório" : null,
                decoration: InputDecoration(
                    labelText: 'Informe o lote ',
                    labelStyle: Theme.of(context).textTheme.bodySmall,
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                          width: 2, color: Theme.of(context).colorScheme.primary),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 3, color: Theme.of(context).colorScheme.primary),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  ),
                          ),
              
              SizedBox(height: 15),
              
              Text('Quantidade', style: Theme.of(context).textTheme.labelMedium),
              
              SizedBox(height: 5),
              // Quantidade
              TextFormField(
                controller: _quantidadeController,
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty || int.tryParse(value) == null || int.parse(value) <= 0 ? "Quantidade inválida" : null,
                decoration: InputDecoration(
                    labelText: 'Informe a quantidade ',
                    labelStyle: Theme.of(context).textTheme.bodySmall,
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                          width: 2, color: Theme.of(context).colorScheme.primary),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 3, color: Theme.of(context).colorScheme.primary),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  ),
              ),
             
              SizedBox(height: 15),
             
              Text('Data de validade', style: Theme.of(context).textTheme.labelMedium),
             
              SizedBox(height: 5),
              // Data de Validade com DatePicker
              TextFormField(
                controller: _dataValidadeController,
                
                readOnly: true,
                onTap: _selectDataValidade,
                validator: (value) => value!.isEmpty ? "Campo obrigatório" : null,
                decoration: InputDecoration(
                    labelText: 'Data de validade',
                    labelStyle: Theme.of(context).textTheme.bodySmall,
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                          width: 2, color: Theme.of(context).colorScheme.primary),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 3, color: Theme.of(context).colorScheme.primary),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  ),
              ),
          
              SizedBox(height: 15),
              
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