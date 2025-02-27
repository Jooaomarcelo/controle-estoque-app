import 'package:controle_estoque_app/pages/adicionar_estoque_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Para formatar a data
import 'package:controle_estoque_app/core/models/estoque.dart';


class EstoqueItem extends StatelessWidget {
  final Estoque estoque;
  final String nomeProduto;

  const EstoqueItem({required this.estoque,required this.nomeProduto,super.key});

  @override
  Widget build(BuildContext context) {
    // Função para criar as colunas com chave/valor
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
                      SizedBox(height: 5),
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

            // Informações do estoque
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  getEstoqueColumn({
                    'Produto': nomeProduto,
                    'Lote': estoque.lote.toString(),
                  }),
                  getEstoqueColumn({
                    'Quantidade': estoque.quantidade.toString(),
                    'Data de Cadastro':
                        DateFormat('dd/MM/yyyy').format(estoque.dataCadastro),
                  }),
                ],
              ),
            ),

            const SizedBox(width: 20),

            // Botão de editar, que abre a página para editar o estoque
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => AdicionarEstoquePage(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
