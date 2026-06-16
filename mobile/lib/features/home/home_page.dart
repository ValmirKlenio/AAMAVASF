import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:mobile/core/widgets/bottom_menu.dart';
import 'package:mobile/core/widgets/notification_card.dart';
import 'package:mobile/core/widgets/wave_header.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
        systemNavigationBarColor: Colors.white,
        systemStatusBarContrastEnforced: false,
      ),
      child: Scaffold(
        backgroundColor: background,
        body: SingleChildScrollView(
          child: Column(
            children: [
              const _HomeHeader(),

              SizedBox(height: 14 * scale),

              const _InfoBanner(),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8 * scale),

                    const _SectionTitle(
                      title: 'Acesso rápido',
                    ),

                    SizedBox(height: 10 * scale),

                    const _QuickAccessGrid(),

                    SizedBox(height: 18 * scale),

                    const _EventsHeader(),

                    SizedBox(height: 10 * scale),

                    const _EventCard(
                      date: '25 MAI',
                      title: 'Oficina de Habilidades Sociais',
                      time: '09:00-11:00',
                      status: 'Inscrever-se',
                      iconColor: Color(0xff0047FF),
                    ),

                    const _EventCard(
                      date: '02 JUN',
                      title: 'Roda de Pais e Responsáveis',
                      time: '19:00-20:30',
                      status: 'Inscrever-se',
                      iconColor: Color(0xff00C853),
                    ),

                    const _EventCard(
                      date: '10 JUN',
                      title: 'Palestra de conscientização',
                      time: '10:00-11:30',
                      status: 'Inscrever-se',
                      iconColor: Color(0xff00C853),
                    ),

                    const _EventCard(
                      date: '15 JUN',
                      title: 'Oficina de Habilidades Sociais',
                      time: '17:00-19:00',
                      status: 'Inscrever-se',
                      iconColor: Color(0xff0047FF),
                    ),

                    SizedBox(height: 6 * scale),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: const BottomMenu(
          selectedIndex: 0,
        ),
      ),
    );
  }
}

class _Responsive {
  static const double baseWidth = 402;

  static double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
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

  static double eventCardHeight(BuildContext context) {
    final height = screenHeight(context);

    return (height * 0.08).clamp(60.0, 68.0).toDouble();
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader();

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
                : 184 * scale);

    return WaveHeader(
      height: headerHeight,
      backgroundColor: HomePage.primaryBlue,
      child: Stack(
        children: [
          Positioned(
            top: topSafe + (8 * scale),
            left: 0,
            right: 0,
            child: Column(
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  width: 105 * scale,
                  height: 45 * scale,
                  fit: BoxFit.contain,
                ),

                Text(
                  'AAMAVASF',
                  style: TextStyle(
                    color: const Color(0xffD6DCF0),
                    fontSize: 13.5 * scale,
                    fontWeight: FontWeight.w700,
                    height: 1,
                  ),
                ),

                Text(
                  'ASSOCIACAO DE AMIGOS DO AUTISTA\nDO VALE DO SAO FRANCISCO',
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: const Color(0xff8699DA),
                    fontSize: 5.3 * scale,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            top: topSafe + (100 * scale),
            left: 18 * scale,
            child: Text(
              'Olá, Maria! 👋',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: const Color(0xffD8DFF3),
                fontSize: 17 * scale,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          Positioned(
            top: topSafe + (124 * scale),
            left: 18 * scale,
            child: Text(
              'Que bom ter você aqui!',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: const Color(0xff98AAE2),
                fontSize: 10.2 * scale,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          Positioned(
            top: topSafe + (13 * scale),
            right: 24 * scale,
            child: NotificationBellButton(
              scale: scale,
            ),
          ),

          Positioned(
            right: -35 * scale,
            top: topSafe + (68 * scale),
            child: Icon(
              Icons.extension,
              size: 108 * scale,
              color: Colors.white.withValues(alpha: 0.08),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoBanner extends StatelessWidget {
  const _InfoBanner();

  @override
  Widget build(BuildContext context) {
    final double scale = _Responsive.scale(context);
    final bool isSmallScreen = _Responsive.isSmallScreen(context);
    final bool isVerySmallScreen = _Responsive.isVerySmallScreen(context);

    final double bannerHeight = isVerySmallScreen
        ? 136 * scale
        : isSmallScreen
            ? 142 * scale
            : 148 * scale;

    return FractionallySizedBox(
      widthFactor: isVerySmallScreen ? 0.94 : 0.93,
      child: Container(
        height: bannerHeight,
        decoration: BoxDecoration(
          color: const Color(0xffEDEFF1),
          borderRadius: BorderRadius.circular(11 * scale),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 12 * scale,
              offset: Offset(0, 4 * scale),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(11 * scale),
          child: Row(
            children: [
              Expanded(
                flex: isVerySmallScreen
                    ? 58
                    : isSmallScreen
                        ? 56
                        : 54,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: isVerySmallScreen ? 15 * scale : 20 * scale,
                    top: isVerySmallScreen ? 14 * scale : 17 * scale,
                    right: 6 * scale,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Apoio, inclusao\ne amor transformam.',
                            style: TextStyle(
                              color: const Color(0xff415ABE),
                              fontSize: isVerySmallScreen
                                  ? 12.4 * scale
                                  : isSmallScreen
                                      ? 13.1 * scale
                                      : 14.2 * scale,
                              fontWeight: FontWeight.w700,
                              height: 1.15,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(
                        height: isVerySmallScreen ? 7 * scale : 9 * scale,
                      ),

                      Text(
                        'Juntos por uma sociedade\nmais acolhedora para todos.',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: const Color(0xff686D78),
                          fontSize: isVerySmallScreen
                              ? 8.4 * scale
                              : isSmallScreen
                                  ? 8.8 * scale
                                  : 9.3 * scale,
                          fontWeight: FontWeight.w500,
                          height: 1.35,
                        ),
                      ),

                      const Spacer(),

                      SizedBox(
                        width: 74 * scale,
                        height: 24 * scale,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff053FD8),
                            padding: EdgeInsets.zero,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5 * scale),
                            ),
                          ),
                          child: Text(
                            'Saiba mais',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: const Color(0xffD8DFF3),
                              fontSize: 8.8 * scale,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 6 * scale),
                    ],
                  ),
                ),
              ),

              Expanded(
                flex: isVerySmallScreen
                    ? 42
                    : isSmallScreen
                        ? 44
                        : 46,
                child: Image.asset(
                  'assets/images/banner_hands.png',
                  height: double.infinity,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final double scale = _Responsive.scale(context);

    return Text(
      title,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: const Color(0xff454647),
        fontSize: 12.75 * scale,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _QuickAccessGrid extends StatelessWidget {
  const _QuickAccessGrid();

  @override
  Widget build(BuildContext context) {
    final double scale = _Responsive.scale(context);
    final bool isVerySmallScreen = _Responsive.isVerySmallScreen(context);

    final double gap = 8 * scale;

    if (isVerySmallScreen) {
      return Column(
        children: [
          Row(
            children: [
              const Expanded(
                child: _QuickAccessCard(
                  title: 'Agenda',
                  icon: Icons.calendar_month_outlined,
                  iconColor: Color(0xff002CCB),
                ),
              ),
              SizedBox(width: gap),
              const Expanded(
                child: _QuickAccessCard(
                  title: 'Atendimentos',
                  icon: Icons.groups_2_outlined,
                  iconColor: Color(0xffFFB500),
                ),
              ),
            ],
          ),

          SizedBox(height: gap),

          Row(
            children: [
              const Expanded(
                child: _QuickAccessCard(
                  title: 'Serviços',
                  svgIcon: 'assets/icons/services.svg',
                  iconColor: Color(0xff00A029),
                ),
              ),
              SizedBox(width: gap),
              const Expanded(
                child: _QuickAccessCard(
                  title: 'Como ajudar',
                  icon: Icons.volunteer_activism_outlined,
                  iconColor: Color(0xffFF2001),
                ),
              ),
            ],
          ),
        ],
      );
    }

    return Row(
      children: [
        const Expanded(
          child: _QuickAccessCard(
            title: 'Agenda',
            icon: Icons.calendar_month_outlined,
            iconColor: Color(0xff002CCB),
          ),
        ),

        SizedBox(width: gap),

        const Expanded(
          child: _QuickAccessCard(
            title: 'Atendimentos',
            icon: Icons.groups_2_outlined,
            iconColor: Color(0xffFFB500),
          ),
        ),

        SizedBox(width: gap),

        const Expanded(
          child: _QuickAccessCard(
            title: 'Serviços',
            svgIcon: 'assets/icons/services.svg',
            iconColor: Color(0xff00A029),
          ),
        ),

        SizedBox(width: gap),

        const Expanded(
          child: _QuickAccessCard(
            title: 'Como ajudar',
            icon: Icons.volunteer_activism_outlined,
            iconColor: Color(0xffFF2001),
          ),
        ),
      ],
    );
  }
}

class _QuickAccessCard extends StatelessWidget {
  final String title;
  final IconData? icon;
  final String? svgIcon;
  final Color iconColor;

  const _QuickAccessCard({
    required this.title,
    this.icon,
    this.svgIcon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final double scale = _Responsive.scale(context);
    final bool isVerySmallScreen = _Responsive.isVerySmallScreen(context);

    return Container(
      height: isVerySmallScreen ? 68 * scale : 72 * scale,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10 * scale),
        border: Border.all(
          color: const Color(0xffEFF2F7),
          width: 1.2 * scale,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 34 * scale,
            height: 34 * scale,
            decoration: const BoxDecoration(
              color: Color(0xffF3F8FF),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: svgIcon != null
                  ? SvgPicture.asset(
                      svgIcon!,
                      width: 22 * scale,
                      height: 22 * scale,
                    )
                  : Icon(
                      icon,
                      color: iconColor,
                      size: 22 * scale,
                    ),
            ),
          ),

          SizedBox(height: 6 * scale),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4 * scale),
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xff686C76),
                fontSize: 9 * scale,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EventsHeader extends StatelessWidget {
  const _EventsHeader();

  @override
  Widget build(BuildContext context) {
    final double scale = _Responsive.scale(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Proximos eventos',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: const Color(0xff434445),
            fontSize: 12.75 * scale,
            fontWeight: FontWeight.w700,
          ),
        ),

        Text(
          'Ver todos',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: const Color(0xff5368D0),
            fontSize: 9.57 * scale,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _EventCard extends StatelessWidget {
  final String date;
  final String title;
  final String time;
  final String status;
  final Color iconColor;

  const _EventCard({
    required this.date,
    required this.title,
    required this.time,
    required this.status,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final double scale = _Responsive.scale(context);
    final bool isCalendar = iconColor == const Color(0xff0047FF);

    return Container(
      height: _Responsive.eventCardHeight(context),
      margin: EdgeInsets.only(bottom: 8 * scale),
      padding: EdgeInsets.symmetric(horizontal: 9 * scale),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(2 * scale),
      ),
      child: Row(
        children: [
          Container(
            width: 45 * scale,
            height: 45 * scale,
            decoration: BoxDecoration(
              color: isCalendar
                  ? const Color(0xffF0F5FF)
                  : const Color(0xffE9FFE9),
              borderRadius: BorderRadius.circular(4 * scale),
            ),
            child: Icon(
              isCalendar ? Icons.calendar_month_outlined : Icons.favorite_border,
              color: iconColor,
              size: 23 * scale,
            ),
          ),

          SizedBox(width: 12 * scale),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  date,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: const Color(0xff5368D0),
                    fontSize: 9.4 * scale,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                SizedBox(height: 2 * scale),

                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: const Color(0xff41444B),
                    fontSize: 10.3 * scale,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                SizedBox(height: 2 * scale),

                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      color: const Color(0xff686D78),
                      size: 10.5 * scale,
                    ),

                    SizedBox(width: 3 * scale),

                    Flexible(
                      child: Text(
                        time,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: const Color(0xff686D78),
                          fontSize: 9.4 * scale,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(width: 8 * scale),

          SizedBox(
            width: 84 * scale,
            height: 24 * scale,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xffF0F5FF),
                borderRadius: BorderRadius.circular(20 * scale),
              ),
              child: Center(
                child: Text(
                  status,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: const Color(0xff5368D0),
                    fontSize: 8.7 * scale,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}