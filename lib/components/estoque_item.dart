import 'package:controle_estoque_app/core/models/estoque.dart';
import 'package:controle_estoque_app/pages/adicionar_estoque_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';


class EstoqueItem extends StatefulWidget {
  final Estoque estoque;
  final String nomeProduto;
  final int initialQuantidade;
  final Function(String,int) onQuantidadeAlterada;


  const EstoqueItem({
    super.key,
    required this.estoque,
    required this.nomeProduto,
    required this.initialQuantidade,
    required this.onQuantidadeAlterada,
    }); 

  @override
  _EstoqueItemState createState() => _EstoqueItemState();
}

class _EstoqueItemState extends State<EstoqueItem> {
  late int quantidadeBaixa;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    quantidadeBaixa = widget.initialQuantidade;
  }
  @override
  void didUpdateWidget(covariant EstoqueItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if(oldWidget.initialQuantidade != widget.initialQuantidade){
      quantidadeBaixa = widget.initialQuantidade;
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget getEstoqueColumn(Map<String, String> values) {
      return Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: values.entries
              .map((entry) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.key,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                        ),
                        softWrap: false,
                        overflow: TextOverflow.visible,
                      ),
                      Text(
                        entry.value,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 5),
                    ],
                  ))
              .toList(),
        ),
      );
    }

    return Card(
      color: Theme.of(context).colorScheme.primary.withAlpha(25),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(
          color: Theme.of(context).colorScheme.primary,
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => AdicionarEstoquePage(estoque: widget.estoque),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 60,
                height: 60,
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Image.asset('assets/images/default-light.png'),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    getEstoqueColumn({
                      'Produto': widget.nomeProduto,
                      'Lote': widget.estoque.lote.toString(),
                    }),
                    getEstoqueColumn({
                      'Quantidade': widget.estoque.quantidade.toString(),
                      'Data de Cadastro':
                          DateFormat('dd/MM/yyyy').format(widget.estoque.dataCadastro),
                    }),
                  ],
                ),
              ),
              const SizedBox(width: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        quantidadeBaixa = quantidadeBaixa > 0 ? quantidadeBaixa - 1 : 0;
                        
                        print(quantidadeBaixa);
                      });
                    widget.onQuantidadeAlterada(widget.estoque.id, quantidadeBaixa);
                  
                    },
                    child: SvgPicture.asset(
                      'assets/images/icone1.svg',
                      width: 16,
                    ),
                  ),
                  SizedBox(width: 1),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/images/CaixaDoValor.svg',
                      ),
                      Positioned(
                        child: Text(
                          quantidadeBaixa.toString(),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 1),
                  InkWell(
                    onTap: () {
                      setState(() {
                        quantidadeBaixa = quantidadeBaixa + 1;
                        
                      });
                    widget.onQuantidadeAlterada(widget.estoque.id, quantidadeBaixa);
                    print(quantidadeBaixa);

                    },
                    child: SvgPicture.asset(
                      'assets/images/icone2.svg',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}