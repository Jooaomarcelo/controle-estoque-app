import 'package:controle_estoque_app/core/services/user_service.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Image.asset(
            'assets/images/Logo.png',
            fit: BoxFit.contain,
            height: 89,
          ),
          centerTitle: true,
        ),
        body: Center(
          child: SizedBox(
            width: 240,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Bem vindo, Usuário',
                  softWrap: false,
                  overflow: TextOverflow.visible,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Poppins',
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                SizedBox(
                  height: 29,
                ),
                SizedBox(
                  height: 48,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        side: BorderSide(
                          color: Colors.black,
                          width: 2,
                        ),
                      ),
                      onPressed: () => Navigator.of(context).pushNamed('/user'),
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/images/perfil.png',
                            fit: BoxFit.contain,
                            height: 24,
                          ),
                          SizedBox(
                            width: 22,
                          ),
                          Text(
                            'Perfil',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Poppins',
                              color: Colors.white,
                            ),
                          ),
                        ],
                      )),
                ),
                SizedBox(height: 16),
                SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      side: BorderSide(
                        color: Colors.black,
                        width: 2,
                      ),
                    ),
                    onPressed: () =>
                        Navigator.of(context).pushNamed('/products'),
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/images/iconeProdutos.png',
                          fit: BoxFit.contain,
                          height: 24,
                        ),
                        SizedBox(
                          width: 22,
                        ),
                        Text(
                          'Produtos',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Poppins',
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      side: BorderSide(
                        color: Colors.black,
                        width: 2,
                      ),
                    ),
                    onPressed: () =>
                        Navigator.of(context).pushNamed('/estoque'),
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/images/iconeEstoque.png',
                          fit: BoxFit.contain,
                          height: 24,
                        ),
                        SizedBox(
                          width: 22,
                        ),
                        Text(
                          'Estoque',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Poppins',
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 80,
                ),
                SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      side: BorderSide(
                        color: Colors.black,
                        width: 2,
                      ),
                    ),
                    onPressed: () => UserService().logout(),
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/images/iconeSair.png',
                          fit: BoxFit.contain,
                          height: 24,
                        ),
                        SizedBox(
                          width: 22,
                        ),
                        Text(
                          'Sair',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Poppins',
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
