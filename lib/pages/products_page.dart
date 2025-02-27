import 'dart:async';
import 'package:controle_estoque_app/core/services/user_service.dart';
import 'package:flutter/material.dart';

import 'package:controle_estoque_app/core/models/product.dart';
import 'package:controle_estoque_app/core/services/product/product_service.dart';

import 'package:controle_estoque_app/components/search_product_bar.dart';
import 'package:controle_estoque_app/components/new_product.dart';
import 'package:controle_estoque_app/components/product_item.dart';
import 'package:provider/provider.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  Timer? _timer;
  final ValueNotifier<bool> _isSearching = ValueNotifier(false);
  String _search = '';

  void _handleSearch(String value) {
    _isSearching.value = true;

    if (_timer?.isActive ?? false) _timer?.cancel();

    _timer = Timer(const Duration(milliseconds: 1000), () {
      setState(() {
        _isSearching.value = false;
        _search = value;
      });
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
            Image.asset(
              'assets/images/icone-produtos.png',
            ),
            const SizedBox(width: 15),
            const Text('Produtos'),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
        child: Column(
          children: [
            SearchProductBar(onSearch: _handleSearch),
            const SizedBox(height: 7.5),
            ValueListenableBuilder<bool>(
              valueListenable: _isSearching,
              builder: (_, isSearching, __) {
                if (isSearching) {
                  return const LinearProgressIndicator();
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
            SizedBox(height: 7.5),
            Expanded(
              child: StreamBuilder(
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
                    // Pegamos os IDs únicos dos usuários que editaram os produtos
                    final userIds = products
                        .map((p) => p.userIdLastUpdated)
                        .toSet()
                        .toList();

                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      Provider.of<UserService>(context)
                          .getUsersByProductsUsersIds(userIds);
                    });

                    return ListView.builder(
                      padding: EdgeInsets.only(bottom: 100),
                      itemCount: products.length,
                      itemBuilder: (ctx, i) {
                        final product = products[i];

                        if (_search.isEmpty) {
                          return ProductItem(product);
                        } else if (product.name
                            .toLowerCase()
                            .contains(_search.trim().toLowerCase())) {
                          return ProductItem(product);
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: const NewProduct(),
    );
  }
}
