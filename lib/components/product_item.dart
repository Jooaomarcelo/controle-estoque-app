import 'package:controle_estoque_app/core/models/product.dart';
import 'package:controle_estoque_app/pages/product_form_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProductItem extends StatelessWidget {
  final Product product;

  const ProductItem(this.product, {super.key});

  @override
  Widget build(BuildContext context) {
    Widget getProductColumn(Map<String, String> values) {
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
      ));
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
            // Imagem do produto
            if (product.image!.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  product.image!,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              )
            else
              Container(
                  width: 60,
                  height: 60,
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Image.asset('assets/images/default-light.png')),

            const SizedBox(width: 20),

            // Informações do produto
            Expanded(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                getProductColumn({
                  'Nome': product.name,
                  'Tipo': product.type,
                }),
                getProductColumn({
                  'Marca': product.brand,
                  'Data de Cadastro':
                      DateFormat('dd/MM/yyyy').format(product.createdAt),
                }),
              ],
            )),

            const SizedBox(width: 20),

            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => ProductFormPage(product: product),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
