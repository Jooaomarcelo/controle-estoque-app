import 'package:controle_estoque_app/components/product_form.dart';
import 'package:controle_estoque_app/core/models/product.dart';
import 'package:controle_estoque_app/core/models/product_form_data.dart';
import 'package:controle_estoque_app/core/services/product/product_service.dart';
import 'package:controle_estoque_app/core/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProductFormPage extends StatefulWidget {
  final Product? product;

  const ProductFormPage({
    this.product,
    super.key,
  });

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  bool _isLoading = false;

  Future<void> _handleSubmit(ProductFormData formData) async {
    try {
      setState(() => _isLoading = true);

      final currentUser = UserService().currentUser;

      if (currentUser == null) {
        // Handle error
        return;
      }

      if (widget.product == null) {
        await ProductService().addProduct(
          currentUser,
          formData,
        );
      } else {
        await ProductService().editProduct(
          currentUser,
          formData,
          widget.product!,
        );
      }
    } catch (error) {
      // Handle error
      debugPrint('Error: $error');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              ProductForm(
                product: widget.product,
                isLoading: _isLoading,
                onSubmit: _handleSubmit,
              ),
              Positioned(
                top: 10,
                left: 10,
                child: IconButton(
                  icon: SvgPicture.asset(
                    'assets/images/Seta.svg',
                    colorFilter: ColorFilter.mode(
                      Theme.of(context).colorScheme.primary,
                      BlendMode.srcIn,
                    ),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
