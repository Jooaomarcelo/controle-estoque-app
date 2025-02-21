enum TipoUsuario { administrador, estoquista, leitor }

extension TipoUsuarioExtension on TipoUsuario {
  String get label {
    switch (this) {
      case TipoUsuario.administrador:
        return 'Administrador';
      case TipoUsuario.estoquista:
        return 'Estoquista';
      case TipoUsuario.leitor:
        return 'Leitor';
    }
  }
}

class UserData {
  final String id;
  final String email;
  TipoUsuario _tipoUsuario;

  UserData({
    required this.id,
    required this.email,
    TipoUsuario tipoUsuario = TipoUsuario.leitor,
  }) : _tipoUsuario = tipoUsuario;

  TipoUsuario get tipoUsuario => _tipoUsuario;

  bool get isAdministrador => _tipoUsuario == TipoUsuario.administrador;

  bool get isEstoquista => _tipoUsuario == TipoUsuario.estoquista;

  void changeUserType(TipoUsuario tipoUsuario) {
    _tipoUsuario = tipoUsuario;
  }
}
