import 'package:controle_estoque_app/core/models/user_data.dart';
import 'package:controle_estoque_app/core/services/user_service.dart';
import 'package:controle_estoque_app/pages/auth_page.dart';
import 'package:controle_estoque_app/pages/home_page.dart';
import 'package:controle_estoque_app/pages/loading_page.dart';
import 'package:flutter/material.dart';

class AuthOrAppPage extends StatelessWidget {
  const AuthOrAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserData?>(
      stream: UserService().userChanges,
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingPage();
        } else {
          return snapshot.hasData ? const HomePage() : AuthPage();
        }
      },
    );
  }
}
