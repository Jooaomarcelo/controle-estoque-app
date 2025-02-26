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
  final String name;
  String imageUrl;
  final TipoUsuario _tipoUsuario;

  UserData({
    required this.id,
    required this.name,
    required this.email,
    this.imageUrl = '',
    TipoUsuario tipoUsuario = TipoUsuario.leitor,
  }) : _tipoUsuario = tipoUsuario;

  TipoUsuario get tipoUsuario => _tipoUsuario;

  bool get isLeitor => _tipoUsuario == TipoUsuario.leitor;
}
