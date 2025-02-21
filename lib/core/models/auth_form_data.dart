enum AuthMode { signup, login }

class AuthFormData {
  String email = '';
  String password = '';
  AuthMode _mode = AuthMode.login;

  bool get isLogin => _mode == AuthMode.login;

  bool get isSignup => _mode == AuthMode.signup;

  void toggleMode() {
    _mode = isLogin ? AuthMode.signup : AuthMode.login;
  }
}
