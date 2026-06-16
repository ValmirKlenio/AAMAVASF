class Usuario {
  final int id;
  final String nome;
  final String email;
  final String cpf;
  final String telefone;
  final String tipo;
  final DateTime? dataCadastro;
  final String? nomeDependente;
  final DateTime? dataNascDep;

  const Usuario({
    required this.id,
    required this.nome,
    required this.email,
    required this.cpf,
    required this.telefone,
    required this.tipo,
    required this.dataCadastro,
    required this.nomeDependente,
    required this.dataNascDep,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: _asInt(json['id']),
      nome: json['nome']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      cpf: json['cpf']?.toString() ?? '',
      telefone: json['telefone']?.toString() ?? '',
      tipo: json['tipo']?.toString() ?? '',
      dataCadastro: _asDateTime(json['data_cadastro']),
      nomeDependente: json['nome_dependente']?.toString(),
      dataNascDep: _asDateTime(json['data_nasc_dep']),
    );
  }

  String get primeiroNome {
    final partes = nome.trim().split(RegExp(r'\s+'));

    if (partes.isEmpty || partes.first.isEmpty) {
      return 'Usuário';
    }

    return _capitalize(partes.first);
  }

  static String _capitalize(String value) {
    final cleanValue = value.trim();

    if (cleanValue.isEmpty) {
      return cleanValue;
    }

    return cleanValue[0].toUpperCase() + cleanValue.substring(1).toLowerCase();
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

  static DateTime? _asDateTime(dynamic value) {
    if (value == null) {
      return null;
    }

    return DateTime.tryParse(value.toString());
  }
}
