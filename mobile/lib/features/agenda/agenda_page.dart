import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/widgets/bottom_menu.dart';
import '../../core/widgets/notification_card.dart';
import '../../core/widgets/wave_header.dart';
import 'models/agendamento.dart';
import 'repositories/agenda_repository.dart';

enum _AgendaTab { eventos, compromissos }

class AgendaPage extends StatefulWidget {
  const AgendaPage({super.key});

  static const Color primaryBlue = Color(0xff012A9F);
  static const Color background = Color(0xffF6F8FC);

  @override
  State<AgendaPage> createState() => _AgendaPageState();
}

class _AgendaPageState extends State<AgendaPage> {
  final AgendaRepository _agendaRepository = AgendaRepository();
  late Future<List<Agendamento>> _agendamentosFuture;
  late DateTime _focusedMonth;
  late DateTime _selectedDate;
  _AgendaTab _selectedTab = _AgendaTab.eventos;
  bool _isCanceling = false;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _focusedMonth = DateTime(now.year, now.month);
    _selectedDate = DateTime(now.year, now.month, now.day);
    _loadAgendamentos();
  }

  void _loadAgendamentos() {
    _agendamentosFuture = _agendaRepository.listarAgendamentos();
  }

  void _selectDate(DateTime date) {
    setState(() {
      _selectedDate = date;
      _focusedMonth = DateTime(date.year, date.month);
    });
  }

  void _changeMonth(int offset) {
    setState(() {
      _focusedMonth = DateTime(
        _focusedMonth.year,
        _focusedMonth.month + offset,
      );
      _selectedDate = DateTime(_focusedMonth.year, _focusedMonth.month, 1);
    });
  }

  void _selectTab(_AgendaTab tab) {
    setState(() {
      _selectedTab = tab;
    });
  }

  Future<void> _cancelarAgendamento(Agendamento agendamento) async {
    if (_isCanceling) {
      return;
    }

    final shouldCancel = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Cancelar agendamento'),
          content: Text('Deseja cancelar ${agendamento.titulo}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Voltar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Cancelar agendamento'),
            ),
          ],
        );
      },
    );

    if (!mounted || shouldCancel != true) {
      return;
    }

    setState(() {
      _isCanceling = true;
    });

    try {
      await _agendaRepository.cancelarAgendamento(agendamento.idAgendamento);

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Agendamento cancelado com sucesso.')),
      );

      setState(_loadAgendamentos);
    } on AgendaRepositoryException catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.message)));
    } finally {
      if (mounted) {
        setState(() {
          _isCanceling = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double scale = _Responsive.scale(context);
    final double horizontalPadding = _Responsive.horizontalPadding(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
        systemStatusBarContrastEnforced: false,
        systemNavigationBarContrastEnforced: false,
      ),
      child: Scaffold(
        backgroundColor: AgendaPage.background,
        body: ScrollConfiguration(
          behavior: const _NoPullScrollBehavior(),
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              children: [
                const _AgendaHeader(),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: Column(
                    children: [
                      SizedBox(height: 10 * scale),

                      _TabsCard(
                        selectedTab: _selectedTab,
                        onTabSelected: _selectTab,
                      ),

                      SizedBox(height: 10 * scale),

                      FutureBuilder<List<Agendamento>>(
                        future: _agendamentosFuture,
                        builder: (context, snapshot) {
                          final agendamentos =
                              (snapshot.data ?? const <Agendamento>[])
                                  .where(
                                    (agendamento) =>
                                        agendamento.status.toLowerCase() !=
                                        'cancelado',
                                  )
                                  .toList();
                          final error = snapshot.hasError
                              ? snapshot.error
                              : null;

                          if (_selectedTab == _AgendaTab.compromissos) {
                            return _AgendaCommitmentsList(
                              agendamentos: agendamentos,
                              isLoading:
                                  snapshot.connectionState !=
                                  ConnectionState.done,
                              error: error,
                              onCancel: _cancelarAgendamento,
                            );
                          }

                          return Column(
                            children: [
                              _CalendarCard(
                                focusedMonth: _focusedMonth,
                                selectedDate: _selectedDate,
                                agendamentos: agendamentos,
                                onDaySelected: _selectDate,
                                onPreviousMonth: () => _changeMonth(-1),
                                onNextMonth: () => _changeMonth(1),
                              ),

                              SizedBox(height: 14 * scale),

                              _EventsDayHeader(selectedDate: _selectedDate),

                              SizedBox(height: 8 * scale),

                              _AgendaEventsList(
                                selectedDate: _selectedDate,
                                agendamentos: agendamentos,
                                isLoading:
                                    snapshot.connectionState !=
                                    ConnectionState.done,
                                error: error,
                              ),
                            ],
                          );
                        },
                      ),

                      SizedBox(height: 24 * scale),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: const BottomMenu(selectedIndex: 2),
      ),
    );
  }
}

class _NoPullScrollBehavior extends MaterialScrollBehavior {
  const _NoPullScrollBehavior();

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const ClampingScrollPhysics();
  }
}

class _Responsive {
  static const double baseWidth = 402;

  static double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double scale(BuildContext context) {
    final width = screenWidth(context);
    return (width / baseWidth).clamp(0.78, 1.0).toDouble();
  }

  static double horizontalPadding(BuildContext context) {
    final width = screenWidth(context);
    return (width * 0.055).clamp(16.0, 24.0).toDouble();
  }

  static bool isSmallScreen(BuildContext context) {
    return screenWidth(context) < 380;
  }

  static bool isVerySmallScreen(BuildContext context) {
    return screenWidth(context) < 340;
  }
}

String _dateKey(DateTime date) {
  final year = date.year.toString().padLeft(4, '0');
  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');

  return '$year-$month-$day';
}

bool _sameDate(DateTime first, DateTime second) {
  return first.year == second.year &&
      first.month == second.month &&
      first.day == second.day;
}

Color _colorFromHex(String? value) {
  final hex = value?.replaceAll('#', '').trim();

  if (hex == null || hex.length != 6) {
    return const Color(0xff0029E0);
  }

  final parsed = int.tryParse(hex, radix: 16);

  if (parsed == null) {
    return const Color(0xff0029E0);
  }

  return Color(0xff000000 | parsed);
}

Color _lightBackground(Color color) {
  return Color.lerp(Colors.white, color, 0.12) ?? const Color(0xffEFF2FD);
}

class _AgendaHeader extends StatelessWidget {
  const _AgendaHeader();

  @override
  Widget build(BuildContext context) {
    final double scale = _Responsive.scale(context);
    final bool isSmallScreen = _Responsive.isSmallScreen(context);
    final bool isVerySmallScreen = _Responsive.isVerySmallScreen(context);

    final double topSafe = MediaQuery.of(context).padding.top;

    final double headerHeight =
        topSafe +
        (isVerySmallScreen
            ? 168 * scale
            : isSmallScreen
            ? 176 * scale
            : 188 * scale);

    return WaveHeader(
      height: headerHeight,
      backgroundColor: AgendaPage.primaryBlue,
      child: Stack(
        children: [
          Positioned(
            top: topSafe + (8 * scale),
            left: 0,
            right: 0,
            child: Text(
              'Agenda',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xffC1CBE9),
                fontSize: 15.32 * scale,
                fontWeight: FontWeight.w700,
                height: 1,
              ),
            ),
          ),

          Positioned(
            top: topSafe + (38 * scale),
            left: 0,
            right: 0,
            child: Column(
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  width: 115 * scale,
                  height: 49 * scale,
                  fit: BoxFit.contain,
                ),

                Text(
                  'AAMAVASF',
                  style: TextStyle(
                    color: const Color(0xffD6DCF0),
                    fontSize: 14.35 * scale,
                    fontWeight: FontWeight.w700,
                    height: 1,
                  ),
                ),

                Text(
                  'ASSOCIAÇÃO DE AMIGOS DO AUTISTA\nDO VALE DO SÃO FRANCISCO',
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: const Color(0xff98A9D5),
                    fontSize: 5.65 * scale,
                    fontWeight: FontWeight.w400,
                    height: 1.25,
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            top: topSafe + (13 * scale),
            right: 24 * scale,
            child: NotificationBellButton(scale: scale),
          ),
        ],
      ),
    );
  }
}

class _TabsCard extends StatelessWidget {
  final _AgendaTab selectedTab;
  final ValueChanged<_AgendaTab> onTabSelected;

  const _TabsCard({required this.selectedTab, required this.onTabSelected});

  @override
  Widget build(BuildContext context) {
    final double scale = _Responsive.scale(context);

    return Container(
      height: 40 * scale,
      decoration: BoxDecoration(
        color: const Color(0xffFDFDFD),
        borderRadius: BorderRadius.circular(10 * scale),
      ),
      child: Row(
        children: [
          Expanded(
            child: _AgendaTabItem(
              label: 'Eventos',
              icon: Icons.calendar_month_outlined,
              isSelected: selectedTab == _AgendaTab.eventos,
              onTap: () => onTabSelected(_AgendaTab.eventos),
            ),
          ),

          Expanded(
            child: _AgendaTabItem(
              label: 'Meus compromissos',
              icon: Icons.person_outline,
              isSelected: selectedTab == _AgendaTab.compromissos,
              onTap: () => onTabSelected(_AgendaTab.compromissos),
            ),
          ),
        ],
      ),
    );
  }
}

class _AgendaTabItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _AgendaTabItem({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final double scale = _Responsive.scale(context);

    final content = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: isSelected ? const Color(0xff536AD3) : const Color(0xff90939C),
          size: (label == 'Eventos' ? 14 : 15) * scale,
        ),
        SizedBox(width: (label == 'Eventos' ? 6 : 7) * scale),
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: isSelected
                  ? const Color(0xff536AD3)
                  : const Color(0xff90939C),
              fontSize: (label == 'Eventos' ? 9.68 : 10.48) * scale,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              height: 1,
            ),
          ),
        ),
      ],
    );

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: isSelected
          ? Container(
              height: 35 * scale,
              margin: EdgeInsets.all(4 * scale),
              decoration: BoxDecoration(
                color: const Color(0xffFEFEFE),
                borderRadius: BorderRadius.circular(4.84 * scale),
                border: Border.all(
                  color: const Color(0xffE7EBF7),
                  width: 0.81 * scale,
                ),
              ),
              child: content,
            )
          : Center(child: content),
    );
  }
}

class _CalendarCard extends StatelessWidget {
  final DateTime focusedMonth;
  final DateTime selectedDate;
  final List<Agendamento> agendamentos;
  final ValueChanged<DateTime> onDaySelected;
  final VoidCallback onPreviousMonth;
  final VoidCallback onNextMonth;

  const _CalendarCard({
    required this.focusedMonth,
    required this.selectedDate,
    required this.agendamentos,
    required this.onDaySelected,
    required this.onPreviousMonth,
    required this.onNextMonth,
  });

  @override
  Widget build(BuildContext context) {
    final double scale = _Responsive.scale(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        14 * scale,
        14 * scale,
        14 * scale,
        12 * scale,
      ),
      decoration: BoxDecoration(
        color: const Color(0xffFEFEFE),
        borderRadius: BorderRadius.circular(5 * scale),
        border: Border.all(color: const Color(0xffF9FBFD), width: 2.42 * scale),
      ),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: onPreviousMonth,
                child: Icon(
                  Icons.chevron_left,
                  size: 18 * scale,
                  color: const Color(0xffA7AAB3),
                ),
              ),

              const Spacer(),

              Text(
                _formatMonth(focusedMonth),
                style: TextStyle(
                  color: const Color(0xff5D72D9),
                  fontSize: 10 * scale,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const Spacer(),

              GestureDetector(
                onTap: onNextMonth,
                child: Icon(
                  Icons.chevron_right,
                  size: 18 * scale,
                  color: const Color(0xffA7AAB3),
                ),
              ),
            ],
          ),

          SizedBox(height: 14 * scale),

          const _CalendarWeekDays(),

          SizedBox(height: 10 * scale),

          _CalendarGrid(
            focusedMonth: focusedMonth,
            selectedDate: selectedDate,
            agendamentos: agendamentos,
            onDaySelected: onDaySelected,
          ),
        ],
      ),
    );
  }

  String _formatMonth(DateTime date) {
    const months = [
      'Janeiro',
      'Fevereiro',
      'Março',
      'Abril',
      'Maio',
      'Junho',
      'Julho',
      'Agosto',
      'Setembro',
      'Outubro',
      'Novembro',
      'Dezembro',
    ];

    return '${months[date.month - 1]} ${date.year}';
  }
}

class _CalendarWeekDays extends StatelessWidget {
  const _CalendarWeekDays();

  @override
  Widget build(BuildContext context) {
    final double scale = _Responsive.scale(context);

    const days = ['DOM', 'SEG', 'TER', 'QUA', 'QUI', 'SEX', 'SAB'];

    return Row(
      children: List.generate(days.length, (index) {
        final bool weekend = index == 0 || index == 6;

        return Expanded(
          child: Center(
            child: Text(
              days[index],
              style: TextStyle(
                color: weekend
                    ? const Color(0xffFF5A5A)
                    : const Color(0xff9EA2AD),
                fontSize: 7.6 * scale,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _CalendarGrid extends StatelessWidget {
  final DateTime focusedMonth;
  final DateTime selectedDate;
  final List<Agendamento> agendamentos;
  final ValueChanged<DateTime> onDaySelected;

  const _CalendarGrid({
    required this.focusedMonth,
    required this.selectedDate,
    required this.agendamentos,
    required this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    final firstDay = DateTime(focusedMonth.year, focusedMonth.month);
    final daysInMonth = DateTime(
      focusedMonth.year,
      focusedMonth.month + 1,
      0,
    ).day;
    final firstWeekdayIndex = firstDay.weekday % 7;
    final totalCells = firstWeekdayIndex + daysInMonth;
    final rowCount = (totalCells / 7).ceil();
    final agendamentosByDate = _groupAgendamentosByDate(agendamentos);

    return Column(
      children: List.generate(rowCount, (row) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: row == rowCount - 1 ? 0 : 10 * _Responsive.scale(context),
          ),
          child: Row(
            children: List.generate(7, (col) {
              final int index = row * 7 + col;
              final int dayNumber = index - firstWeekdayIndex + 1;
              final bool isMuted = dayNumber < 1 || dayNumber > daysInMonth;
              final date = DateTime(
                focusedMonth.year,
                focusedMonth.month,
                isMuted ? 1 : dayNumber,
              );
              final colors = isMuted
                  ? const <Color>[]
                  : _dotColors(agendamentosByDate[_dateKey(date)] ?? []);

              return Expanded(
                child: _CalendarDay(
                  day: isMuted ? null : dayNumber,
                  isSelected: _sameDate(date, selectedDate),
                  dotColors: colors,
                  isWeekend: col == 0 || col == 6,
                  isMuted: isMuted,
                  onTap: isMuted ? null : () => onDaySelected(date),
                ),
              );
            }),
          ),
        );
      }),
    );
  }

  Map<String, List<Agendamento>> _groupAgendamentosByDate(
    List<Agendamento> agendamentos,
  ) {
    final grouped = <String, List<Agendamento>>{};

    for (final agendamento in agendamentos) {
      grouped.putIfAbsent(agendamento.dataKey, () => []).add(agendamento);
    }

    return grouped;
  }

  List<Color> _dotColors(List<Agendamento> agendamentos) {
    return agendamentos
        .map((agendamento) => _colorFromHex(agendamento.categoriaCor))
        .toSet()
        .take(3)
        .toList();
  }
}

class _CalendarDay extends StatelessWidget {
  final int? day;
  final bool isSelected;
  final List<Color> dotColors;
  final bool isWeekend;
  final bool isMuted;
  final VoidCallback? onTap;

  const _CalendarDay({
    required this.day,
    required this.isSelected,
    required this.dotColors,
    required this.isWeekend,
    required this.isMuted,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final double scale = _Responsive.scale(context);

    if (isMuted || day == null) {
      return SizedBox(height: 30 * scale);
    }

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: 30 * scale,
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              if (isSelected)
                Container(
                  width: 27 * scale,
                  height: 27 * scale,
                  decoration: const BoxDecoration(
                    color: Color(0xff0029E0),
                    shape: BoxShape.circle,
                  ),
                ),

              Text(
                '$day',
                style: TextStyle(
                  color: isSelected
                      ? Colors.white
                      : isWeekend
                      ? const Color(0xffFF5A5A)
                      : const Color(0xff4D525D),
                  fontSize: 9 * scale,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),

              if (dotColors.isNotEmpty)
                Positioned(
                  bottom: -5 * scale,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(dotColors.length, (index) {
                      return Padding(
                        padding: EdgeInsets.only(
                          right: index == dotColors.length - 1 ? 0 : 3 * scale,
                        ),
                        child: Container(
                          width: 4 * scale,
                          height: 4 * scale,
                          decoration: BoxDecoration(
                            color: dotColors[index],
                            shape: BoxShape.circle,
                          ),
                        ),
                      );
                    }),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EventsDayHeader extends StatelessWidget {
  final DateTime selectedDate;

  const _EventsDayHeader({required this.selectedDate});

  @override
  Widget build(BuildContext context) {
    final double scale = _Responsive.scale(context);

    return Row(
      children: [
        Text(
          'Eventos do dia',
          style: TextStyle(
            color: const Color(0xff4D4F53),
            fontSize: 11.29 * scale,
            fontWeight: FontWeight.w700,
            height: 1,
          ),
        ),

        const Spacer(),

        Text(
          _formatSelectedDate(selectedDate),
          style: TextStyle(
            color: const Color(0xff5D72D9),
            fontSize: 9.68 * scale,
            fontWeight: FontWeight.w600,
            height: 1,
          ),
        ),

        SizedBox(width: 8 * scale),

        Icon(
          Icons.calendar_month_outlined,
          color: const Color(0xff0029E0),
          size: 14 * scale,
        ),
      ],
    );
  }

  String _formatSelectedDate(DateTime date) {
    const weekdays = [
      'Segunda-feira',
      'Terça-feira',
      'Quarta-feira',
      'Quinta-feira',
      'Sexta-feira',
      'Sábado',
      'Domingo',
    ];
    const months = [
      'Janeiro',
      'Fevereiro',
      'Março',
      'Abril',
      'Maio',
      'Junho',
      'Julho',
      'Agosto',
      'Setembro',
      'Outubro',
      'Novembro',
      'Dezembro',
    ];

    return '${weekdays[date.weekday - 1]}, ${date.day} de ${months[date.month - 1]}';
  }
}

class _AgendaEventsList extends StatelessWidget {
  final DateTime selectedDate;
  final List<Agendamento> agendamentos;
  final bool isLoading;
  final Object? error;

  const _AgendaEventsList({
    required this.selectedDate,
    required this.agendamentos,
    required this.isLoading,
    required this.error,
  });

  @override
  Widget build(BuildContext context) {
    final double scale = _Responsive.scale(context);

    if (isLoading) {
      return SizedBox(
        height: 73 * scale,
        child: const Center(
          child: CircularProgressIndicator(color: AgendaPage.primaryBlue),
        ),
      );
    }

    if (error != null) {
      return _AgendaMessage(
        message: error is AgendaRepositoryException
            ? (error as AgendaRepositoryException).message
            : 'Não foi possível carregar seus agendamentos.',
      );
    }

    final selectedEvents = agendamentos
        .where((agendamento) => _sameDate(agendamento.data, selectedDate))
        .toList();

    if (selectedEvents.isEmpty) {
      return const _AgendaMessage(message: 'Nenhum agendamento para este dia.');
    }

    return Column(
      children: List.generate(selectedEvents.length, (index) {
        final agendamento = selectedEvents[index];
        final categoryColor = _colorFromHex(agendamento.categoriaCor);
        final statusColor = _statusColor(agendamento.status);

        return Padding(
          padding: EdgeInsets.only(
            bottom: index == selectedEvents.length - 1 ? 0 : 8 * scale,
          ),
          child: _AgendaEventCard(
            time: agendamento.hora,
            title: agendamento.titulo,
            description: agendamento.cardDescription,
            status: agendamento.statusLabel,
            icon: _iconForCategory(agendamento.categoriaNome),
            iconColor: categoryColor,
            iconBackground: _lightBackground(categoryColor),
            statusBackground: _lightBackground(statusColor),
            statusColor: statusColor,
            leftBorderColor: categoryColor,
          ),
        );
      }),
    );
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pendente':
        return const Color(0xffFDBA4A);
      case 'cancelado':
        return const Color(0xffFF5A5A);
      case 'realizado':
        return const Color(0xff01A621);
      default:
        return const Color(0xff6176DA);
    }
  }

  IconData _iconForCategory(String category) {
    final label = category.toLowerCase();

    if (label.contains('jur')) {
      return Icons.balance_outlined;
    }

    if (label.contains('palestra') || label.contains('educ')) {
      return Icons.record_voice_over_outlined;
    }

    if (label.contains('sa')) {
      return Icons.volunteer_activism_outlined;
    }

    return Icons.groups_2_outlined;
  }
}

class _AgendaCommitmentsList extends StatelessWidget {
  final List<Agendamento> agendamentos;
  final bool isLoading;
  final Object? error;
  final ValueChanged<Agendamento> onCancel;

  const _AgendaCommitmentsList({
    required this.agendamentos,
    required this.isLoading,
    required this.error,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final double scale = _Responsive.scale(context);

    if (isLoading) {
      return SizedBox(
        height: 73 * scale,
        child: const Center(
          child: CircularProgressIndicator(color: AgendaPage.primaryBlue),
        ),
      );
    }

    if (error != null) {
      return _AgendaMessage(
        message: error is AgendaRepositoryException
            ? (error as AgendaRepositoryException).message
            : 'NÃ£o foi possÃ­vel carregar seus agendamentos.',
      );
    }

    final commitments = List<Agendamento>.from(agendamentos)
      ..sort((first, second) {
        final byDate = first.data.compareTo(second.data);
        if (byDate != 0) {
          return byDate;
        }

        return first.hora.compareTo(second.hora);
      });

    if (commitments.isEmpty) {
      return const _AgendaMessage(message: 'Nenhum compromisso agendado.');
    }

    return Column(
      children: List.generate(commitments.length, (index) {
        final agendamento = commitments[index];
        final categoryColor = _colorFromHex(agendamento.categoriaCor);
        final statusColor = _statusColor(agendamento.status);

        return Padding(
          padding: EdgeInsets.only(
            bottom: index == commitments.length - 1 ? 0 : 8 * scale,
          ),
          child: GestureDetector(
            onTap: () => onCancel(agendamento),
            behavior: HitTestBehavior.opaque,
            child: _AgendaEventCard(
              time: agendamento.dataHoraLabel,
              title: agendamento.titulo,
              description: agendamento.cardDescription,
              status: agendamento.statusLabel,
              icon: _iconForCategory(agendamento.categoriaNome),
              iconColor: categoryColor,
              iconBackground: _lightBackground(categoryColor),
              statusBackground: _lightBackground(statusColor),
              statusColor: statusColor,
              leftBorderColor: categoryColor,
            ),
          ),
        );
      }),
    );
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pendente':
        return const Color(0xffFDBA4A);
      case 'cancelado':
        return const Color(0xffFF5A5A);
      case 'realizado':
        return const Color(0xff01A621);
      default:
        return const Color(0xff6176DA);
    }
  }

  IconData _iconForCategory(String category) {
    final label = category.toLowerCase();

    if (label.contains('jur')) {
      return Icons.balance_outlined;
    }

    if (label.contains('palestra') || label.contains('educ')) {
      return Icons.record_voice_over_outlined;
    }

    if (label.contains('sa')) {
      return Icons.volunteer_activism_outlined;
    }

    return Icons.groups_2_outlined;
  }
}

class _AgendaMessage extends StatelessWidget {
  final String message;

  const _AgendaMessage({required this.message});

  @override
  Widget build(BuildContext context) {
    final double scale = _Responsive.scale(context);

    return Container(
      height: 73 * scale,
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xffFEFEFE),
        borderRadius: BorderRadius.circular(5 * scale),
      ),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: const Color(0xff8C9099),
          fontSize: 9.68 * scale,
          fontWeight: FontWeight.w500,
          height: 1.25,
        ),
      ),
    );
  }
}

class _AgendaEventCard extends StatelessWidget {
  final String time;
  final String title;
  final String description;
  final String status;
  final IconData icon;
  final Color iconColor;
  final Color iconBackground;
  final Color statusBackground;
  final Color statusColor;
  final Color leftBorderColor;

  const _AgendaEventCard({
    required this.time,
    required this.title,
    required this.description,
    required this.status,
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
    required this.statusBackground,
    required this.statusColor,
    required this.leftBorderColor,
  });

  @override
  Widget build(BuildContext context) {
    final double scale = _Responsive.scale(context);

    return Container(
      height: 73 * scale,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xffFEFEFE),
        borderRadius: BorderRadius.circular(5 * scale),
        border: Border(
          left: BorderSide(color: leftBorderColor, width: 4 * scale),
        ),
      ),
      child: Row(
        children: [
          SizedBox(width: 9 * scale),

          Container(
            width: 50 * scale,
            height: 52 * scale,
            decoration: BoxDecoration(
              color: iconBackground,
              borderRadius: BorderRadius.circular(5 * scale),
            ),
            child: Icon(icon, color: iconColor, size: 24 * scale),
          ),

          SizedBox(width: 12 * scale),

          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8 * scale),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    time,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 9.68 * scale,
                      fontWeight: FontWeight.w400,
                      height: 1,
                    ),
                  ),

                  SizedBox(height: 6 * scale),

                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: const Color(0xff55585E),
                      fontSize: 10.48 * scale,
                      fontWeight: FontWeight.w600,
                      height: 1,
                    ),
                  ),

                  SizedBox(height: 5 * scale),

                  Text(
                    description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: const Color(0xff8C9099),
                      fontSize: 8.06 * scale,
                      fontWeight: FontWeight.w400,
                      height: 1.28,
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(width: 8 * scale),

          Container(
            width: status == 'Pendente' ? 59 * scale : 51 * scale,
            height: 20 * scale,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: statusBackground,
              borderRadius: BorderRadius.circular(8.8 * scale),
            ),
            child: Text(
              status,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: statusColor,
                fontSize: status == 'Pendente' ? 8.87 * scale : 8.06 * scale,
                fontWeight: status == 'Pendente'
                    ? FontWeight.w400
                    : FontWeight.w700,
                height: 1,
              ),
            ),
          ),

          SizedBox(width: 8 * scale),

          Icon(
            Icons.chevron_right,
            color: const Color(0xff7F8490),
            size: 16 * scale,
          ),

          SizedBox(width: 8 * scale),
        ],
      ),
    );
  }
}
