import 'dart:io';

import 'package:controle_estoque_app/core/models/user_data.dart';
import 'package:controle_estoque_app/core/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final _currentUser = UserService().currentUser;
  File? _image;
  bool _isLoading = false;

  void _handleImagePressed() async {
    final res = await showDialog<bool>(
      context: context,
      builder: (ctx) => Dialog(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              style: ElevatedButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.primary,
                backgroundColor: Colors.white,
                side: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2.0,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _currentUser!.imageUrl.isEmpty ? Icons.add : Icons.edit,
                    color: Theme.of(context).colorScheme.primary,
                    size: 25,
                  ),
                  SizedBox(width: 10),
                  Text(
                    _currentUser.imageUrl.isEmpty
                        ? 'Adicionar Foto'
                        : 'Editar Foto',
                    style: Theme.of(context).textTheme.labelMedium!.copyWith(
                          fontWeight: FontWeight.normal,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    if (res == null) return;

    _pickImage();
  }

  void _pickImage() async {
    final picker = ImagePicker();

    final pickedImage = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 150,
    );

    if (pickedImage == null) return;

    setState(() {
      _image = File(pickedImage.path);
    });

    try {
      setState(() => _isLoading = true);

      await UserService().updateUserImage(_image!);
    } catch (error) {
      debugPrint('$error');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Widget _showUserImage(String imageUrl) {
    if (imageUrl.isEmpty && !_isLoading) {
      return Image.asset(
        'assets/images/default-light-user.png',
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(
            'assets/images/default-light-user.png',
            fit: BoxFit.cover,
          );
        },
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
              'assets/images/perfil.png',
            ),
            const SizedBox(width: 15),
            const Text('Perfil'),
          ],
        ),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(
          vertical: 40,
          horizontal: 20,
        ),
        padding: EdgeInsets.symmetric(
          vertical: 40,
          horizontal: 15,
        ),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary,
            width: 3,
          ),
          color: Theme.of(context).colorScheme.primary.withAlpha(25),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Column(
                children: [
                  InkWell(
                    onTap: _handleImagePressed,
                    child: Container(
                      width: 200,
                      height: 200,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : _showUserImage(_currentUser!.imageUrl),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _currentUser!.name,
                    style: Theme.of(context).textTheme.labelMedium!.copyWith(
                          color: Colors.black,
                        ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _currentUser.tipoUsuario.label,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 40),
            Text('E-mail: ${_currentUser.email}'),
            const SizedBox(height: 25),
            Text(
                'Data de cadastro: ${DateFormat('dd/MM/yyyy').format(_currentUser.createdAt)}'),
            const SizedBox(height: 25),
            Text('Código: ${_currentUser.code}')
          ],
        ),
      ),
    );
  }
}
