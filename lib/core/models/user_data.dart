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
  final String? id;
  final String code;
  final String email;
  final String name;
  String imageUrl;
  final TipoUsuario _tipoUsuario;
  final DateTime createdAt;

  UserData({
    this.id,
    required this.code,
    required this.name,
    required this.email,
    this.imageUrl = '',
    TipoUsuario tipoUsuario = TipoUsuario.leitor,
    required this.createdAt,
  }) : _tipoUsuario = tipoUsuario;

  TipoUsuario get tipoUsuario => _tipoUsuario;

  bool get isLeitor => _tipoUsuario == TipoUsuario.leitor;
}
