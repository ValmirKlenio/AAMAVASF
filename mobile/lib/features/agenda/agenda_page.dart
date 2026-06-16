import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/widgets/bottom_menu.dart';
import '../../core/widgets/notification_card.dart';
import '../../core/widgets/wave_header.dart';

class AgendaPage extends StatelessWidget {
  const AgendaPage({super.key});

  static const Color primaryBlue = Color(0xff012A9F);
  static const Color background = Color(0xffF6F8FC);

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
        backgroundColor: background,
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

                      const _TabsCard(),

                      SizedBox(height: 10 * scale),

                      const _CalendarCard(),

                      SizedBox(height: 14 * scale),

                      const _EventsDayHeader(),

                      SizedBox(height: 8 * scale),

                      const _AgendaEventCard(
                        time: '09:00-11:00',
                        title: 'Oficina de Habilidades Sociais',
                        description:
                            'Atividade em grupo para desenvolvimento\nde interação e comunicação.',
                        status: 'Inscrito',
                        icon: Icons.groups_2_outlined,
                        iconColor: Color(0xff000CDB),
                        iconBackground: Color(0xffE5E9FB),
                        statusBackground: Color(0xffEFF2FD),
                        statusColor: Color(0xff6176DA),
                        leftBorderColor: Color(0xff001FE4),
                      ),

                      SizedBox(height: 8 * scale),

                      const _AgendaEventCard(
                        time: '14:00-15:30',
                        title: 'Roda de Conversa com Pais',
                        description:
                            'Espaço de diálogo e troca de experiências\nentre pais e responsáveis.',
                        status: 'Inscrito',
                        icon: Icons.record_voice_over_outlined,
                        iconColor: Color(0xff01A621),
                        iconBackground: Color(0xffE3F5E3),
                        statusBackground: Color(0xffE3F5E3),
                        statusColor: Color(0xff61B872),
                        leftBorderColor: Color(0xff00A425),
                      ),

                      SizedBox(height: 8 * scale),

                      const _AgendaEventCard(
                        time: '16:00-17:30',
                        title: 'Terapia Ocupacional',
                        description:
                            'Sessão terapêutica focada na autonomia\ne coordenação motora.',
                        status: 'Pendente',
                        icon: Icons.volunteer_activism_outlined,
                        iconColor: Color(0xffFFA600),
                        iconBackground: Color(0xffFFF4E0),
                        statusBackground: Color(0xffFDF6E5),
                        statusColor: Color(0xffFDBA4A),
                        leftBorderColor: Color(0xffFFB102),
                      ),

                      SizedBox(height: 14 * scale),

                      const _AddCommitmentButton(),

                      SizedBox(height: 24 * scale),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: const BottomMenu(
          selectedIndex: 2,
        ),
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

class _AgendaHeader extends StatelessWidget {
  const _AgendaHeader();

  @override
  Widget build(BuildContext context) {
    final double scale = _Responsive.scale(context);
    final bool isSmallScreen = _Responsive.isSmallScreen(context);
    final bool isVerySmallScreen = _Responsive.isVerySmallScreen(context);

    final double topSafe = MediaQuery.of(context).padding.top;

    final double headerHeight = topSafe +
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
            child: NotificationBellButton(
              scale: scale,
            ),
          ),
        ],
      ),
    );
  }
}

class _TabsCard extends StatelessWidget {
  const _TabsCard();

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
            child: Container(
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.calendar_month_outlined,
                    color: const Color(0xff536AD3),
                    size: 14 * scale,
                  ),
                  SizedBox(width: 6 * scale),
                  Text(
                    'Eventos',
                    style: TextStyle(
                      color: const Color(0xff536AD3),
                      fontSize: 9.68 * scale,
                      fontWeight: FontWeight.w700,
                      height: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.person_outline,
                  color: const Color(0xff90939C),
                  size: 15 * scale,
                ),
                SizedBox(width: 7 * scale),
                Text(
                  'Meus compromissos',
                  style: TextStyle(
                    color: const Color(0xff90939C),
                    fontSize: 10.48 * scale,
                    fontWeight: FontWeight.w500,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CalendarCard extends StatelessWidget {
  const _CalendarCard();

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
        border: Border.all(
          color: const Color(0xffF9FBFD),
          width: 2.42 * scale,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.chevron_left,
                size: 18 * scale,
                color: const Color(0xffA7AAB3),
              ),

              const Spacer(),

              Text(
                'Maio 2024',
                style: TextStyle(
                  color: const Color(0xff5D72D9),
                  fontSize: 10 * scale,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const Spacer(),

              Icon(
                Icons.chevron_right,
                size: 18 * scale,
                color: const Color(0xffA7AAB3),
              ),
            ],
          ),

          SizedBox(height: 14 * scale),

          const _CalendarWeekDays(),

          SizedBox(height: 10 * scale),

          const _CalendarGrid(),
        ],
      ),
    );
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
                color:
                    weekend ? const Color(0xffFF5A5A) : const Color(0xff9EA2AD),
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
  const _CalendarGrid();

  @override
  Widget build(BuildContext context) {
    final List<int?> days = [
      null,
      null,
      null,
      1,
      2,
      3,
      4,
      5,
      6,
      7,
      8,
      9,
      10,
      11,
      12,
      13,
      14,
      15,
      16,
      17,
      18,
      19,
      20,
      21,
      22,
      23,
      24,
      25,
      26,
      27,
      28,
      29,
      30,
      31,
      null,
    ];

    return Column(
      children: List.generate(5, (row) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: row == 4 ? 0 : 10 * _Responsive.scale(context),
          ),
          child: Row(
            children: List.generate(7, (col) {
              final int index = row * 7 + col;
              final int? day = days[index];

              return Expanded(
                child: _CalendarDay(
                  day: day,
                  isSelected: day == 15,
                  hasBlueDot: day == 15 || day == 21,
                  hasGreenDot: day == 15 || day == 25,
                  hasOrangeDot: day == 15,
                  isWeekend: col == 0 || col == 6,
                  isMuted: day == null,
                ),
              );
            }),
          ),
        );
      }),
    );
  }
}

class _CalendarDay extends StatelessWidget {
  final int? day;
  final bool isSelected;
  final bool hasBlueDot;
  final bool hasGreenDot;
  final bool hasOrangeDot;
  final bool isWeekend;
  final bool isMuted;

  const _CalendarDay({
    required this.day,
    required this.isSelected,
    required this.hasBlueDot,
    required this.hasGreenDot,
    required this.hasOrangeDot,
    required this.isWeekend,
    required this.isMuted,
  });

  @override
  Widget build(BuildContext context) {
    final double scale = _Responsive.scale(context);

    if (isMuted || day == null) {
      return SizedBox(height: 30 * scale);
    }

    return SizedBox(
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

            if (hasBlueDot || hasGreenDot || hasOrangeDot)
              Positioned(
                bottom: -5 * scale,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (hasBlueDot)
                      Container(
                        width: 4 * scale,
                        height: 4 * scale,
                        decoration: const BoxDecoration(
                          color: Color(0xff0029E0),
                          shape: BoxShape.circle,
                        ),
                      ),

                    if (hasBlueDot && (hasGreenDot || hasOrangeDot))
                      SizedBox(width: 3 * scale),

                    if (hasGreenDot)
                      Container(
                        width: 4 * scale,
                        height: 4 * scale,
                        decoration: const BoxDecoration(
                          color: Color(0xff01A621),
                          shape: BoxShape.circle,
                        ),
                      ),

                    if (hasGreenDot && hasOrangeDot) SizedBox(width: 3 * scale),

                    if (hasOrangeDot)
                      Container(
                        width: 4 * scale,
                        height: 4 * scale,
                        decoration: const BoxDecoration(
                          color: Color(0xffFFA600),
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _EventsDayHeader extends StatelessWidget {
  const _EventsDayHeader();

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
          'Quarta-feira,15 de Maio',
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
          left: BorderSide(
            color: leftBorderColor,
            width: 4 * scale,
          ),
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
            child: Icon(
              icon,
              color: iconColor,
              size: 24 * scale,
            ),
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
                fontWeight:
                    status == 'Pendente' ? FontWeight.w400 : FontWeight.w700,
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

class _AddCommitmentButton extends StatelessWidget {
  const _AddCommitmentButton();

  @override
  Widget build(BuildContext context) {
    final double scale = _Responsive.scale(context);

    return SizedBox(
      height: 40 * scale,
      child: Center(
        child: Text(
          'Adicionar compromisso',
          style: TextStyle(
            color: const Color(0xffAABAEB),
            fontSize: 11.29 * scale,
            fontWeight: FontWeight.w700,
            height: 1,
          ),
        ),
      ),
    );
  }
}