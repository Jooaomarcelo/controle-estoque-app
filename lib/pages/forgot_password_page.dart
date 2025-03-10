import 'dart:async';

import 'package:controle_estoque_app/core/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  bool _isLoading = false;
  bool _isValid = true;
  Timer? _timer;
  int _secondsRemaining = 0;
  String _email = '';

  Future<void> _submit() async {
    if (_timer != null) return;

    setState(() =>
        _isValid = _email.trim().contains('@') && _email.trim().isNotEmpty);

    if (!_isValid) return;

    try {
      setState(() {
        _isLoading = true;

        _secondsRemaining = 30;

        _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          if (_secondsRemaining == 0) {
            timer.cancel();

            setState(() => _timer = null);
          } else {
            setState(() => _secondsRemaining--);
          }
        });
      });

      await UserService().forgotPassword(_email);
    } catch (error) {
      debugPrint('$error');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Positioned(
                top: 40,
                left: 10,
                child: IconButton(
                  icon: SvgPicture.asset(
                    'assets/images/Seta.svg',
                    colorFilter: ColorFilter.mode(
                      Theme.of(context).colorScheme.primary,
                      BlendMode.srcIn,
                    ),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height - kToolbarHeight,
                padding:
                    const EdgeInsets.symmetric(vertical: 50, horizontal: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SvgPicture.asset('assets/images/forgot-password.svg'),
                    Column(
                      children: [
                        Text(
                          'Esqueceu a sua senha?',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        const SizedBox(height: 15),
                        Text(
                          _timer != null
                              ? 'Código enviado! Espere $_secondsRemaining segundos para enviar novamente.'
                              : 'Sem preocupações! Informe seu e-mail e enviaremos um link para você criar uma nova senha.',
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                      ],
                    ),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'E-mail',
                        labelStyle: Theme.of(context).textTheme.bodySmall,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 3.0,
                              color: Theme.of(context).colorScheme.primary),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              width: 2.0,
                              color: Theme.of(context).colorScheme.primary),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 15),
                      ),
                      onChanged: (email) => _email = email,
                      onSubmitted: (_) => _submit(),
                    ),
                    if (!_isValid)
                      Text(
                        'E-mail inválido!',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: Colors.red),
                      ),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          textStyle: Theme.of(context).textTheme.labelMedium,
                        ),
                        child: _isLoading
                            ? CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text('Enviar Link'),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 2,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        Text(' Ou ',
                            style: Theme.of(context).textTheme.labelMedium),
                        Expanded(
                          child: Container(
                            height: 2,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () =>
                            Navigator.of(context).pushNamedAndRemoveUntil(
                          '/auth',
                          ModalRoute.withName('/'),
                          arguments: false,
                        ),
                        style: ElevatedButton.styleFrom(
                          foregroundColor:
                              Theme.of(context).colorScheme.primary,
                          backgroundColor: Colors.white,
                          textStyle: Theme.of(context).textTheme.labelMedium,
                          side: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                            width: 2.0,
                          ),
                        ),
                        child: _isLoading
                            ? CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text('Crie uma nova conta'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
