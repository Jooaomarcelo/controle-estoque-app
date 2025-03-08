import 'package:controle_estoque_app/core/models/auth_form_data.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final bool isLogin;
  final bool isLoading;
  final Future<void> Function(AuthFormData) onSubmit;

  const AuthForm({
    required this.isLogin,
    required this.isLoading,
    required this.onSubmit,
    super.key,
  });

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formData = AuthFormData();
  final _formKey = GlobalKey<FormState>();

  // FocusNodes
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  // Controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void submit() async {
    FocusScope.of(context).unfocus();

    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) return;

    await widget.onSubmit(_formData);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                widget.isLogin ? 'Login' : "Cadastro",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            SizedBox(height: 50),
            if (!widget.isLogin)
              Text(
                'Nome',
                textAlign: TextAlign.start,
              ),
            if (!widget.isLogin)
              TextFormField(
                key: const ValueKey('name'),
                controller: _nameController,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 3.0,
                        color: Theme.of(context).colorScheme.primary),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(999),
                    borderSide: BorderSide(
                        width: 2.0,
                        color: Theme.of(context).colorScheme.primary),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 30),
                  errorMaxLines: 2,
                  errorStyle: TextStyle(overflow: TextOverflow.visible),
                ),
                onChanged: (name) => _formData.name = name,
                validator: (textField) {
                  final name = textField ?? '';

                  if (name.trim().isEmpty) {
                    return 'Nome de Usuário não pode ser vazio.';
                  }

                  if (name.trim().length < 4) {
                    return 'Nome de Usuário deve ter no mínimo 4 caracteres.';
                  }

                  return null;
                },
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_emailFocusNode);
                },
              ),
            SizedBox(height: 20),
            Text(
              'E-mail',
              textAlign: TextAlign.start,
            ),
            TextFormField(
              key: const ValueKey('email'),
              controller: _emailController,
              focusNode: _emailFocusNode,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      width: 3.0, color: Theme.of(context).colorScheme.primary),
                  borderRadius: BorderRadius.circular(999),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(999),
                  borderSide: BorderSide(
                      width: 2.0, color: Theme.of(context).colorScheme.primary),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 30),
                errorMaxLines: 2,
                errorStyle: TextStyle(overflow: TextOverflow.visible),
              ),
              onChanged: (email) => _formData.email = email,
              validator: (textField) {
                final email = textField ?? '';

                if (email.trim().isEmpty) {
                  return 'E-mail de Usuário não pode ser vazio.';
                }

                if (!email.contains('@')) {
                  return 'Email inválido.';
                }

                return null;
              },
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(_passwordFocusNode);
              },
            ),
            SizedBox(height: 20),
            Text(
              'Senha',
              textAlign: TextAlign.start,
            ),
            TextFormField(
              key: const ValueKey('password'),
              controller: _passwordController,
              focusNode: _passwordFocusNode,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      width: 3.0, color: Theme.of(context).colorScheme.primary),
                  borderRadius: BorderRadius.circular(999),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(999),
                  borderSide: BorderSide(
                      width: 2.0, color: Theme.of(context).colorScheme.primary),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 30),
                errorMaxLines: 2,
                errorStyle: TextStyle(overflow: TextOverflow.visible),
              ),
              onChanged: (password) => _formData.password = password,
              obscureText: true,
              validator: (textField) {
                final password = textField ?? '';

                if (password.trim().length < 6) {
                  return 'A senha deve conter no mínimo 6 caractéres.';
                }

                return null;
              },
              onFieldSubmitted: (_) => submit(),
            ),
            if (widget.isLogin)
              TextButton(
                onPressed: () {},
                child: const Text(
                  'Esqueceu a senha?',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Colors.grey,
                  ),
                ),
              ),
            SizedBox(height: 50),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: submit,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
                child: widget.isLoading
                    ? CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : Text(widget.isLogin ? 'Entrar' : 'Cadastrar'),
              ),
            ),
            SizedBox(height: 25),
            if (widget.isLogin)
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pushNamed(
                    '/auth',
                    arguments: false,
                  ),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.primary,
                    backgroundColor: Colors.white,
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2.0,
                    ),
                  ),
                  child: Text('Cadastrar'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
