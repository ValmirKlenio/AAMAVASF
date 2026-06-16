class Servico {
  final int id;
  final String titulo;
  final String? descricao;
  final int duracao;
  final double valor;
  final bool ativo;
  final int idCategoria;
  final String? categoriaNome;

  const Servico({
    required this.id,
    required this.titulo,
    required this.descricao,
    required this.duracao,
    required this.valor,
    required this.ativo,
    required this.idCategoria,
    required this.categoriaNome,
  });

  factory Servico.fromJson(Map<String, dynamic> json) {
    return Servico(
      id: _asInt(json['id']),
      titulo: json['titulo']?.toString() ?? '',
      descricao: json['descricao']?.toString(),
      duracao: _asInt(json['duracao']),
      valor: _asDouble(json['valor']),
      ativo: json['ativo'] == true,
      idCategoria: _asInt(json['id_categoria']),
      categoriaNome: json['categoria_nome']?.toString(),
    );
  }

  String get footer {
    if (duracao > 0) {
      return '$duracao minutos';
    }

    if (categoriaNome != null && categoriaNome!.trim().isNotEmpty) {
      return categoriaNome!.trim();
    }

    return '';
  }

  static int _asInt(dynamic value) {
    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static double _asDouble(dynamic value) {
    if (value is double) {
      return value;
    }

    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(value?.toString() ?? '') ?? 0;
  }
}
