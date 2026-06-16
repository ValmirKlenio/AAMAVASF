class Agendamento {
  final int idAgendamento;
  final int idHorario;
  final int idServico;
  final String titulo;
  final String descricao;
  final DateTime data;
  final String hora;
  final int idCategoria;
  final String categoriaNome;
  final String? categoriaCor;
  final String local;
  final String status;

  const Agendamento({
    required this.idAgendamento,
    required this.idHorario,
    required this.idServico,
    required this.titulo,
    required this.descricao,
    required this.data,
    required this.hora,
    required this.idCategoria,
    required this.categoriaNome,
    required this.categoriaCor,
    required this.local,
    required this.status,
  });

  factory Agendamento.fromJson(Map<String, dynamic> json) {
    final horario = json['horario'] is Map<String, dynamic>
        ? json['horario'] as Map<String, dynamic>
        : <String, dynamic>{};
    final datahoraInicio = DateTime.tryParse(
      horario['datahora_inicio']?.toString() ?? '',
    );
    final dataText = json['data']?.toString();

    return Agendamento(
      idAgendamento: _asInt(json['id_agendamento'] ?? json['id']),
      idHorario: _asInt(json['id_horario'] ?? horario['id']),
      idServico: _asInt(json['id_servico'] ?? horario['servico_id']),
      titulo:
          json['titulo']?.toString() ??
          json['servico_titulo']?.toString() ??
          'Agendamento',
      descricao:
          json['descricao']?.toString() ??
          horario['observacao']?.toString() ??
          'Agendamento confirmado para este dia.',
      data:
          DateTime.tryParse(dataText ?? '') ?? datahoraInicio ?? DateTime.now(),
      hora: json['hora']?.toString() ?? _formatHora(datahoraInicio),
      idCategoria: _asInt(json['id_categoria']),
      categoriaNome: json['categoria_nome']?.toString() ?? '',
      categoriaCor: json['categoria_cor']?.toString(),
      local: horario['local']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
    );
  }

  String get dataKey {
    final year = data.year.toString().padLeft(4, '0');
    final month = data.month.toString().padLeft(2, '0');
    final day = data.day.toString().padLeft(2, '0');

    return '$year-$month-$day';
  }

  String get dataHoraLabel {
    final day = data.day.toString().padLeft(2, '0');
    final month = data.month.toString().padLeft(2, '0');

    if (hora.trim().isEmpty) {
      return '$day/$month';
    }

    return '$day/$month - $hora';
  }

  String get statusLabel {
    if (status.isEmpty) {
      return 'Inscrito';
    }

    return status[0].toUpperCase() + status.substring(1).toLowerCase();
  }

  String get cardDescription {
    final parts = <String>[];
    final cleanDescricao = descricao.trim();
    final cleanLocal = local.trim();
    final cleanCategoria = categoriaNome.trim();

    if (cleanDescricao.isNotEmpty) {
      parts.add(cleanDescricao);
    }
    if (cleanLocal.isNotEmpty) {
      parts.add('Local: $cleanLocal');
    }
    if (cleanCategoria.isNotEmpty) {
      parts.add('Categoria: $cleanCategoria');
    }

    if (parts.isEmpty) {
      return 'Agendamento confirmado para este dia.';
    }

    return parts.join('\n');
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

  static String _formatHora(DateTime? value) {
    if (value == null) {
      return '';
    }

    final hour = value.hour.toString().padLeft(2, '0');
    final minute = value.minute.toString().padLeft(2, '0');

    return '$hour:$minute';
  }
}
