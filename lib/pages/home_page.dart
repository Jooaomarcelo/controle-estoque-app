import 'package:controle_estoque_app/core/services/user_service.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Home Page'),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.logout,
                color: Colors.white,
              ),
              onPressed: () {
                UserService().logout();
              },
            )
          ],
        ),
        body: Center(
          child: ElevatedButton(
              onPressed: () => Navigator.of(context).pushNamed('/products'),
              child: Row(
                children: [
                  Icon(Icons.menu_open_sharp),
                  Text('Produtos'),
                ],
              )),
        ));
  }
}
