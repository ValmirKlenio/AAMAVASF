import 'package:flutter/material.dart';

import '../models/horario_disponivel.dart';
import '../models/servico.dart';
import '../repositories/agendamento_repository.dart';

Future<bool?> showServiceBookingSheet(
  BuildContext context, {
  required Servico service,
}) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _ServiceBookingSheet(service: service),
  );
}

class _ServiceBookingSheet extends StatefulWidget {
  final Servico service;

  const _ServiceBookingSheet({required this.service});

  @override
  State<_ServiceBookingSheet> createState() => _ServiceBookingSheetState();
}

class _ServiceBookingSheetState extends State<_ServiceBookingSheet> {
  final AgendamentoRepository _repository = AgendamentoRepository();
  late Future<List<HorarioDisponivel>> _horariosFuture;
  int? _loadingHorarioId;

  @override
  void initState() {
    super.initState();
    _horariosFuture = _repository.listarHorariosDisponiveis(widget.service.id);
  }

  void _reloadHorarios() {
    setState(() {
      _horariosFuture = _repository.listarHorariosDisponiveis(
        widget.service.id,
      );
    });
  }

  Future<void> _confirmarAgendamento(HorarioDisponivel horario) async {
    final shouldSchedule = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmar agendamento'),
          content: Text(
            '${widget.service.titulo}\n${horario.dataLabel} as ${horario.horaLabel}',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Confirmar'),
            ),
          ],
        );
      },
    );

    if (!mounted || shouldSchedule != true || _loadingHorarioId != null) {
      return;
    }

    setState(() {
      _loadingHorarioId = horario.id;
    });

    try {
      await _repository.agendar(horario.id);

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Agendamento realizado com sucesso.')),
      );
      Navigator.of(context).pop(true);
    } on AgendamentoRepositoryException catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.message)));
      _reloadHorarios();
    } finally {
      if (mounted) {
        setState(() {
          _loadingHorarioId = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.72,
      minChildSize: 0.45,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xffFDFEFD),
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xffD7DCE8),
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.service.titulo,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xff4F545F),
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          height: 1.15,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      icon: const Icon(Icons.close, color: Color(0xff70747D)),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: FutureBuilder<List<HorarioDisponivel>>(
                  future: _horariosFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xff012A9F),
                        ),
                      );
                    }

                    if (snapshot.hasError) {
                      final error = snapshot.error;
                      return _SheetMessage(
                        message: error is AgendamentoRepositoryException
                            ? error.message
                            : 'Nao foi possivel carregar os horarios.',
                        onRetry: _reloadHorarios,
                      );
                    }

                    final horarios = snapshot.data ?? <HorarioDisponivel>[];
                    if (horarios.isEmpty) {
                      return const _SheetMessage(
                        message: 'Nenhum horario disponivel para este servico.',
                      );
                    }

                    return ListView.separated(
                      controller: scrollController,
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                      itemCount: horarios.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final horario = horarios[index];
                        final isLoading = _loadingHorarioId == horario.id;

                        return _HorarioTile(
                          horario: horario,
                          isLoading: isLoading,
                          isDisabled:
                              _loadingHorarioId != null &&
                              _loadingHorarioId != horario.id,
                          onPressed: () => _confirmarAgendamento(horario),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _HorarioTile extends StatelessWidget {
  final HorarioDisponivel horario;
  final bool isLoading;
  final bool isDisabled;
  final VoidCallback onPressed;

  const _HorarioTile({
    required this.horario,
    required this.isLoading,
    required this.isDisabled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xffFDFEFD),
        border: Border.all(color: const Color(0xffF4F5F8), width: 0.8),
        borderRadius: BorderRadius.circular(4),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        title: Text(
          '${horario.dataLabel} - ${horario.horaLabel}',
          style: const TextStyle(
            color: Color(0xff4F545F),
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
        subtitle: Text(
          _subtitle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Color(0xff8C8F97),
            fontSize: 11,
            fontWeight: FontWeight.w400,
            height: 1.25,
          ),
        ),
        trailing: TextButton(
          onPressed: isDisabled || isLoading ? null : onPressed,
          child: isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Agendar'),
        ),
      ),
    );
  }

  String get _subtitle {
    final local = horario.local.trim();
    final vagas = horario.vagasRestantes == 1
        ? '1 vaga'
        : '${horario.vagasRestantes} vagas';

    if (local.isEmpty) {
      return vagas;
    }

    return '$local - $vagas';
  }
}

class _SheetMessage extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const _SheetMessage({required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xff676B74),
                fontSize: 13,
                fontWeight: FontWeight.w500,
                height: 1.25,
              ),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 12),
              TextButton(
                onPressed: onRetry,
                child: const Text('Tentar novamente'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
