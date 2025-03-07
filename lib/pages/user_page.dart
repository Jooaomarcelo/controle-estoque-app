import 'package:controle_estoque_app/core/models/user_data.dart';
import 'package:controle_estoque_app/core/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = UserService().currentUser;

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
                  Container(
                    width: 200,
                    height: 200,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: currentUser!.imageUrl.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              currentUser.imageUrl,
                              width: 150,
                              height: 150,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  'assets/images/default-dark.png',
                                  fit: BoxFit.scaleDown,
                                );
                              },
                            ),
                          )
                        : Image.asset(
                            'assets/images/default-light.png',
                            fit: BoxFit.scaleDown,
                          ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    currentUser.name,
                    style: Theme.of(context).textTheme.labelMedium!.copyWith(
                          color: Colors.black,
                        ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    currentUser.tipoUsuario.label,
                    style: Theme.of(context).textTheme.bodySmall,
                  )
                ],
              ),
            ),
            const SizedBox(height: 40),
            Text('E-mail: ${currentUser.email}'),
            const SizedBox(height: 25),
            Text('E-mail: ${currentUser.email}'),
            // Text('Data de cadastro: ${DateFormat('dd/MM/yyyy').format(currentUser.createdAt)}'),
            const SizedBox(height: 25),
            Text('E-mail: ${currentUser.email}'),
            // Text('Código: ${currentUser.code}')
          ],
        ),
      ),
    );
  }
}
