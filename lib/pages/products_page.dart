import 'package:controle_estoque_app/core/models/product.dart';
import 'package:controle_estoque_app/core/models/user_data.dart';
import 'package:controle_estoque_app/core/services/product/product_service.dart';
import 'package:controle_estoque_app/core/services/user_service.dart';
import 'package:controle_estoque_app/pages/product_form_page.dart';
import 'package:flutter/material.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Produtos'),
      ),
      body: StreamBuilder(
        stream: ProductService().productsStream(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('Nenhum produto cadastrado!'),
            );
          } else {
            final products = snapshot.data as List<Product>;

            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (ctx, i) {
                final product = products[i];

                return ListTile(
                  leading: ClipRRect(
                      borderRadius: BorderRadius.circular(45),
                      child: Container(
                        height: 50,
                        width: 90,
                        alignment: Alignment.center,
                        color: Colors.grey[300],
                        padding: const EdgeInsets.all(5),
                        child: Text(product.type),
                      )),
                  title: Text(
                    '${product.name} (${product.brand})',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(product.description ?? ''),
                      const SizedBox(height: 5),
                      FutureBuilder(
                        future: UserService()
                            .getUserById(product.userIdLastUpdated),
                        builder: (ctx, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Text('Obtendo usuário...');
                          } else {
                            final user = snapshot.data as UserData;

                            return Text(
                              'Editado por ${user.email} em ${product.lastEdited}',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => ProductFormPage(product: product),
                      ),
                    ),
                    icon: Icon(Icons.edit),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => const ProductFormPage(),
          ),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
