import 'dart:io';

import 'package:controle_estoque_app/components/image_picker_widget.dart';
import 'package:controle_estoque_app/core/models/product.dart';
import 'package:controle_estoque_app/core/models/product_form_data.dart';
import 'package:controle_estoque_app/core/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ProductForm extends StatefulWidget {
  final Product? product;
  final bool isLoading;
  final Future<void> Function(ProductFormData) onSubmit;

  const ProductForm({
    required this.product,
    required this.isLoading,
    required this.onSubmit,
    super.key,
  });

  @override
  State<ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
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

  void _submitForm() {
    final isValid = _fomrKey.currentState!.validate();

    if (!isValid) return;

    widget.onSubmit(_formData);
  }

  Widget _getTextField({
    required String field,
    required String label,
    required String initialValue,
    bool isMultiline = false,
  }) {
    return TextFormField(
      key: ValueKey(field),
      initialValue: initialValue,
      onChanged: (value) {
        switch (field) {
          case 'name':
            _formData.name = value;
            break;
          case 'description':
            _formData.description = value;
            break;
          case 'brand':
            _formData.brand = value;
            break;
          case 'type':
            _formData.type = value;
            break;
        }
      },
      validator: (value) {
        final text = value ?? '';

        if (text.trim().isEmpty && field != 'description') {
          return 'Campo obrigatório';
        }

        return null;
      },
      maxLines: isMultiline ? 3 : 1,
      decoration: InputDecoration(
        labelText: label,
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
    );
  }

  void _handleImagePick(File image) {
    // _formData.image = image;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _fomrKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ImagePickerWidget(
              onImagePicked: _handleImagePick,
            ),
            SizedBox(height: 15),
            Text(
              'Nome*',
              style: Theme.of(context).textTheme.labelMedium,
            ),
            SizedBox(height: 5),
            _getTextField(
              field: 'name',
              label: 'Adicione o nome',
              initialValue: _formData.name,
            ),
            SizedBox(height: 15),
            Text(
              'Tipo*',
              style: Theme.of(context).textTheme.labelMedium,
            ),
            SizedBox(height: 5),
            _getTextField(
              field: 'type',
              label: 'Adicione o tipo',
              initialValue: _formData.type,
            ),
            SizedBox(height: 15),
            Text(
              'Marca*',
              style: Theme.of(context).textTheme.labelMedium,
            ),
            SizedBox(height: 5),
            _getTextField(
              field: 'brand',
              label: 'Adicione a marca',
              initialValue: _formData.brand,
            ),
            SizedBox(height: 15),
            Text(
              'Descrição',
              style: Theme.of(context).textTheme.labelMedium,
            ),
            SizedBox(height: 5),
            _getTextField(
              field: 'description',
              label: 'Adicione uma descrição',
              initialValue: _formData.description,
              isMultiline: true,
            ),
            SizedBox(height: 15),
            if (widget.product != null)
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Editado por: ',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      Consumer<UserService>(
                        builder: (ctx, userProvider, _) => Flexible(
                          child: Text(
                            userProvider.usersEmails[
                                    widget.product!.userIdLastUpdated] ??
                                '',
                            style: Theme.of(context).textTheme.bodySmall,
                            overflow: TextOverflow.visible,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Data: ',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      Text(
                        DateFormat('dd/MM/yyyy').format(
                          widget.product!.lastEdited,
                        ),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  )
                ],
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
                child: widget.isLoading
                    ? CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : Text(
                        widget.product == null ? 'Cadastrar' : 'Confirmar',
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
