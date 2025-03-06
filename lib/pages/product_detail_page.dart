import 'package:controle_estoque_app/core/models/product.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;

  const ProductDetailPage(
    this.product, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Widget getProductInfo(String title, String value) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 15,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
          ),
          Text(
            value,
            overflow: TextOverflow.visible,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 10),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/icone-produtos.png',
            ),
            const SizedBox(width: 15),
            const Text('Produtos'),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 35),
            Center(
              child: product.image == ''
                  ? Image.asset(
                      'assets/images/default-dark.png',
                      width: 150,
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        product.image!,
                        width: 150,
                        height: 150,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'assets/images/default-dark.png',
                            width: 150,
                          );
                        },
                      ),
                    ),
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    getProductInfo("Nome", product.name),
                    getProductInfo("Tipo", product.type),
                    getProductInfo("Marca", product.brand),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    getProductInfo("Data de cadastro",
                        DateFormat('dd/MM/yyyy').format(product.createdAt)),
                    getProductInfo("Última edição",
                        DateFormat('dd/MM/yyyy').format(product.lastEdited)),
                    getProductInfo(
                        "Usuário editor", product.userEmailLastUpdated),
                  ],
                )
              ],
            ),
            const SizedBox(height: 15),
            Text(
              "Descrição",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 15,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 4),
            Text(
              product.description as String,
              style: TextStyle(
                color: Colors.black,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
