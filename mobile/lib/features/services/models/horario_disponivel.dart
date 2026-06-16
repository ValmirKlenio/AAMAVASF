class HorarioDisponivel {
  final int id;
  final DateTime datahoraInicio;
  final int vagasTotal;
  final int vagasOcupadas;
  final String local;
  final String? observacao;
  final int servicoId;
  final bool temVagas;

  const HorarioDisponivel({
    required this.id,
    required this.datahoraInicio,
    required this.vagasTotal,
    required this.vagasOcupadas,
    required this.local,
    required this.observacao,
    required this.servicoId,
    required this.temVagas,
  });

  factory HorarioDisponivel.fromJson(Map<String, dynamic> json) {
    return HorarioDisponivel(
      id: _asInt(json['id']),
      datahoraInicio:
          DateTime.tryParse(json['datahora_inicio']?.toString() ?? '') ??
          DateTime.now(),
      vagasTotal: _asInt(json['vagas_total']),
      vagasOcupadas: _asInt(json['vagas_ocupadas']),
      local: json['local']?.toString() ?? '',
      observacao: json['observacao']?.toString(),
      servicoId: _asInt(json['servico_id']),
      temVagas: json['tem_vagas'] == true,
    );
  }

  int get vagasRestantes => vagasTotal - vagasOcupadas;

  String get dataLabel {
    final day = datahoraInicio.day.toString().padLeft(2, '0');
    final month = datahoraInicio.month.toString().padLeft(2, '0');
    final year = datahoraInicio.year.toString().padLeft(4, '0');

    return '$day/$month/$year';
  }

  String get horaLabel {
    final hour = datahoraInicio.hour.toString().padLeft(2, '0');
    final minute = datahoraInicio.minute.toString().padLeft(2, '0');

    return '$hour:$minute';
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
}
