import 'package:controle_estoque_app/pages/auth_page.dart';
import 'package:controle_estoque_app/pages/products_page.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:controle_estoque_app/pages/auth_or_app_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color.fromRGBO(60, 78, 105, 1),
          primary: Color.fromRGBO(60, 78, 105, 1),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromRGBO(60, 78, 105, 1),
          foregroundColor: Colors.white,
          titleTextStyle: TextStyle(
            fontSize: 24,
            fontFamily: 'Poppins',
          ),
          toolbarHeight: 80,
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: Color.fromRGBO(60, 78, 105, 1),
          ),
          labelMedium: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color.fromRGBO(60, 78, 105, 1),
          ),
          bodySmall: TextStyle(
            fontSize: 16,
            color: Colors.black54,
          ),
          bodyMedium: TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        useMaterial3: true,
      ),
      routes: {
        '/': (ctx) => const AuthOrAppPage(),
        '/auth': (ctx) => const AuthPage(),
        '/products': (ctx) => const ProductsPage(),
      },
    );
  }
}
