import 'package:controle_estoque_app/core/models/product.dart';
import 'package:controle_estoque_app/core/models/product_form_data.dart';
import 'package:controle_estoque_app/core/services/product/product_service.dart';
import 'package:controle_estoque_app/core/services/user_service.dart';
import 'package:flutter/material.dart';

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

  final _fomrKey = GlobalKey<FormState>();

  late ProductFormData _formData;

  @override
  void initState() {
    super.initState();

    _formData = widget.product != null
        ? ProductFormData(
            name: widget.product!.name,
            brand: widget.product!.brand,
            description: widget.product!.description ?? '',
            type: widget.product!.type,
          )
        : ProductFormData();
  }

  Future<void> _submitForm() async {
    final isValid = _fomrKey.currentState!.validate();

    if (!isValid) return;

    final currentUser = UserService().currentUser;

    if (currentUser == null) {
      // Handle error
      return;
    }

    try {
      setState(() => _isLoading = true);

      if (widget.product == null) {
        await ProductService().addProduct(
          currentUser,
          _formData,
        );
      } else {
        await ProductService().editProduct(
          currentUser,
          _formData,
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
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Formulário de Produto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _fomrKey,
          child: Column(
            children: [
              TextFormField(
                key: ValueKey('name'),
                initialValue: _formData.name,
                validator: (value) {
                  final name = value ?? '';

                  if (name.trim().isEmpty) {
                    return 'Nome é obrigatório';
                  }

                  return null;
                },
                onChanged: (value) => _formData.name = value,
                decoration: const InputDecoration(labelText: 'Nome*'),
              ),
              TextFormField(
                key: ValueKey('description'),
                initialValue: _formData.description,
                onChanged: (value) => _formData.description = value,
                decoration: const InputDecoration(labelText: 'Descrição'),
              ),
              TextFormField(
                key: ValueKey('brand'),
                initialValue: _formData.brand,
                validator: (value) {
                  final brand = value ?? '';

                  if (brand.trim().isEmpty) {
                    return 'Marca é obrigatório';
                  }

                  return null;
                },
                onChanged: (value) => _formData.brand = value,
                decoration: const InputDecoration(labelText: 'Marca*'),
              ),
              TextFormField(
                key: ValueKey('type'),
                initialValue: _formData.type,
                validator: (value) {
                  final type = value ?? '';

                  if (type.trim().isEmpty) {
                    return 'Tipo é obrigatório';
                  }

                  return null;
                },
                onChanged: (value) => _formData.type = value,
                decoration: const InputDecoration(labelText: 'Tipo*'),
              ),
              SizedBox(height: 50),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: _submitForm,
                  child: _isLoading
                      ? CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : Text(
                          widget.product == null ? 'Adicionar' : 'Editar',
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
