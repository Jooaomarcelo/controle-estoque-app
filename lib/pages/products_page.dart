import 'dart:async';
import 'package:controle_estoque_app/core/services/user_service.dart';
import 'package:flutter/material.dart';

import 'package:controle_estoque_app/core/models/product.dart';
import 'package:controle_estoque_app/core/services/product/product_service.dart';

import 'package:controle_estoque_app/components/search_product_bar.dart';
import 'package:controle_estoque_app/components/new_product.dart';
import 'package:controle_estoque_app/components/product_item.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final _isLeitor = UserService().currentUser!.isLeitor;

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

  void _showSuccessDialog() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Produto cadastrado com sucesso!',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'OK',
          onPressed: ScaffoldMessenger.of(context).hideCurrentSnackBar,
        ),
      ),
    );
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
              'assets/images/iconeProdutos.png',
            ),
            const SizedBox(width: 15),
            const Text('Produtos'),
          ],
        ),
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/images/Seta.svg',
          ),
          onPressed: () => Navigator.of(context).pop(),
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

                    return ListView.builder(
                      padding: EdgeInsets.only(bottom: !_isLeitor ? 100 : 0),
                      itemCount: products.length,
                      itemBuilder: (ctx, i) {
                        final product = products[i];

                        if (_search.isEmpty) {
                          return ProductItem(product,
                              onSuccess: _showSuccessDialog);
                        } else if (product.name
                            .toLowerCase()
                            .contains(_search.trim().toLowerCase())) {
                          return ProductItem(product,
                              onSuccess: _showSuccessDialog);
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
      floatingActionButton: _isLeitor
          ? null
          : NewProduct(
              onSuccess: _showSuccessDialog,
            ),
    );
  }
}
