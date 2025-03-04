class Estoque {
  String id;
  String idProduto;
  int lote;
  int quantidade;
  DateTime dataValidade;
  DateTime dataCadastro;
  DateTime dataUltimaEdicao;
  String idUsuarioEditou;
  String? image;

  Estoque({
    required this.id,
    required this.idProduto,
    required this.lote,
    required this.quantidade,
    required this.dataValidade,
    required this.dataCadastro,
    required this.dataUltimaEdicao,
    required this.idUsuarioEditou,
    this.image,
  });

  // Converte um documento Firestore para Estoque
  factory Estoque.fromMap(String id, Map<String, dynamic> map) {
    return Estoque(
      id: id,
      idProduto: map['idProduto'],
      lote: map['lote'],
      quantidade: map['quantidade'],
      dataValidade: DateTime.parse(map['dataValidade']),
      dataCadastro: DateTime.parse(map['dataCadastro']),
      dataUltimaEdicao: DateTime.parse(map['dataUltimaEdicao']),
      idUsuarioEditou: map['idUsuarioEditou'],
    );
  }

  // Converte um objeto Estoque para Map<String, dynamic> (para salvar no Firebase)
  Map<String, dynamic> toMap() {
    return {
      'idProduto': idProduto,
      'lote': lote,
      'quantidade': quantidade,
      'dataValidade': dataValidade.toIso8601String(),
      'dataCadastro': dataCadastro.toIso8601String(),
      'dataUltimaEdicao': dataUltimaEdicao.toIso8601String(),
      'idUsuarioEditou': idUsuarioEditou,
    };
  }

  // Método copyWith para editar apenas alguns campos do objeto
  Estoque copyWith({
    String? id,
    String? idProduto,
    int? lote,
    int? quantidade,
    DateTime? dataValidade,
    DateTime? dataCadastro,
    DateTime? dataUltimaEdicao,
    String? idUsuarioEditou,
  }) {
    return Estoque(
      id: id ?? this.id,
      idProduto: idProduto ?? this.idProduto,
      lote: lote ?? this.lote,
      quantidade: quantidade ?? this.quantidade,
      dataValidade: dataValidade ?? this.dataValidade,
      dataCadastro: dataCadastro ?? this.dataCadastro,
      dataUltimaEdicao: dataUltimaEdicao ?? this.dataUltimaEdicao,
      idUsuarioEditou: idUsuarioEditou ?? this.idUsuarioEditou,
    );
  }
}
