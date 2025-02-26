import 'package:controle_estoque_app/components/auth_form.dart';
import 'package:controle_estoque_app/core/models/auth_form_data.dart';
import 'package:controle_estoque_app/core/services/user_service.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool _isLoading = false;
  bool? _isLogin;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final newIsLogin = ModalRoute.of(context)?.settings.arguments as bool?;
    if (_isLogin != newIsLogin) {
      setState(() {
        _isLogin = newIsLogin;
      });
    }
  }

  void _showErrorDialog(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }

  Future<void> _handleSubmit(AuthFormData formData) async {
    try {
      setState(() => _isLoading = true);

      if (_isLogin == true) {
        await UserService().login(
          formData.email,
          formData.password,
        );

        if (mounted) Navigator.of(context).popUntil(ModalRoute.withName('/'));
      } else {
        await UserService().signup(
          formData.name,
          formData.email,
          formData.password,
        );

        if (mounted) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            '/auth',
            ModalRoute.withName('/'),
            arguments: true,
          );
        }
      }
    } catch (error) {
      _showErrorDialog('Email ou senha inválida.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLogin == null) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        title: SvgPicture.asset(
          width: 90,
          height: 90,
          'assets/images/logo-light.svg',
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: AuthForm(
            onSubmit: _handleSubmit,
            isLogin: _isLogin!,
            isLoading: _isLoading,
          ),
        ),
      ),
    );
  }
}
