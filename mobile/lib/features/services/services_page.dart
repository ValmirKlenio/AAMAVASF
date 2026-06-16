import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/widgets/bottom_menu.dart';
import '../../core/widgets/wave_header.dart';

class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

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
        body: Column(
          children: [
            const _ServicesHeader(),

            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Column(
                  children: [
                    SizedBox(height: 14 * scale),

                    const _CategoryRow(),

                    SizedBox(height: 18 * scale),

                    const _ServiceCard(
                      title: 'Terapia Ocupacional',
                      description:
                          'Atividades que estimulam a autonomia,\ncoordenação motora e habilidades\npara o dia a dia.',
                      footer: 'Atendimento com agendamento',
                      icon: Icons.psychology_alt_outlined,
                      iconColor: Color(0xff001FE4),
                      iconBackground: Color(0xffE7EEFE),
                    ),

                    SizedBox(height: 10 * scale),

                    const _ServiceCard(
                      title: 'Jurídico',
                      description:
                          'Assistência jurídica completa e gratuita\npara você',
                      footer: 'Atendimento com agendamento',
                      icon: Icons.balance_outlined,
                      iconColor: Color(0xff00A425),
                      iconBackground: Color(0xffE6FBEA),
                    ),

                    SizedBox(height: 10 * scale),

                    const _ServiceCard(
                      title: 'Psicologia',
                      description:
                          'Apoio emocional e comportamental\npara o desenvolvimento e bem-estar',
                      footer: 'Atendimento com agendamento',
                      icon: Icons.extension_outlined,
                      iconColor: Color(0xffFFB000),
                      iconBackground: Color(0xffFFF5DF),
                    ),

                    SizedBox(height: 10 * scale),

                    const _ServiceCard(
                      title: 'Palestras',
                      description:
                          'Palestras para entendimento e\ndesenvolvimento',
                      footer: 'Vagas limitadas',
                      icon: Icons.menu_book_outlined,
                      iconColor: Color(0xffFF1A0F),
                      iconBackground: Color(0xffFDEAE9),
                    ),

                    const Spacer(),

                    const _InfoBox(),

                    SizedBox(height: 24 * scale),
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: const BottomMenu(
          selectedIndex: 1,
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

class _ServicesHeader extends StatelessWidget {
  const _ServicesHeader();

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
      backgroundColor: ServicesPage.primaryBlue,
      child: Stack(
        children: [
          Positioned(
            top: topSafe + (8 * scale),
            left: 0,
            right: 0,
            child: Text(
              'Serviços',
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: const Color(0xffD8DFF3),
                fontSize: 17 * scale,
                fontWeight: FontWeight.w700,
                height: 1,
              ),
            ),
          ),

          Positioned(
            top: topSafe + (32 * scale),
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
            top: topSafe + (13 * scale),
            right: 24 * scale,
            child: Icon(
              Icons.notifications_none,
              color: Colors.white,
              size: 24 * scale,
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

class _CategoryRow extends StatelessWidget {
  const _CategoryRow();

  @override
  Widget build(BuildContext context) {
    final double scale = _Responsive.scale(context);
    final double gap = 6 * scale;

    return Row(
      children: [
        const Expanded(
          child: _CategoryCard(
            title: 'Todos',
            icon: Icons.grid_view_rounded,
            iconColor: Color(0xff0021D3),
            selected: true,
          ),
        ),

        SizedBox(width: gap),

        const Expanded(
          child: _CategoryCard(
            title: 'Terapias',
            icon: Icons.person_outline,
            iconColor: Color(0xff01AF17),
          ),
        ),

        SizedBox(width: gap),

        const Expanded(
          child: _CategoryCard(
            title: 'Apoio familiar',
            icon: Icons.groups_2_outlined,
            iconColor: Color(0xffFFB500),
          ),
        ),

        SizedBox(width: gap),

        const Expanded(
          child: _CategoryCard(
            title: 'Atividades',
            icon: Icons.school_outlined,
            iconColor: Color(0xff6B36F8),
          ),
        ),

        SizedBox(width: gap),

        const Expanded(
          child: _CategoryCard(
            title: 'Inclusão',
            icon: Icons.volunteer_activism_outlined,
            iconColor: Color(0xffFF2001),
          ),
        ),
      ],
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final bool selected;

  const _CategoryCard({
    required this.title,
    required this.icon,
    required this.iconColor,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    final double scale = _Responsive.scale(context);

    return Container(
      height: 54 * scale,
      decoration: BoxDecoration(
        color: const Color(0xffFDFDFD),
        borderRadius: BorderRadius.circular(7 * scale),
        border: Border.all(
          color: const Color(0xffF8F9FB),
          width: selected ? 3 * scale : 2 * scale,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.025),
            blurRadius: 4 * scale,
            offset: Offset(0, 2 * scale),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: iconColor,
            size: selected ? 19 * scale : 18 * scale,
          ),

          SizedBox(height: 5 * scale),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 2 * scale),
            child: Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: selected
                    ? const Color(0xff5B6DD8)
                    : const Color(0xff676B74),
                fontSize: 8.08 * scale,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                height: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final String title;
  final String description;
  final String footer;
  final IconData icon;
  final Color iconColor;
  final Color iconBackground;

  const _ServiceCard({
    required this.title,
    required this.description,
    required this.footer,
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
  });

  @override
  Widget build(BuildContext context) {
    final double scale = _Responsive.scale(context);

    return Container(
      height: 82 * scale,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xffFDFEFD),
        borderRadius: BorderRadius.circular(2 * scale),
        border: Border.all(
          color: const Color(0xffF4F5F8),
          width: 0.8 * scale,
        ),
      ),
      child: Row(
        children: [
          SizedBox(width: 16 * scale),

          Container(
            width: 61 * scale,
            height: 63 * scale,
            decoration: BoxDecoration(
              color: iconBackground,
              borderRadius: BorderRadius.circular(4 * scale),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 30 * scale,
            ),
          ),

          SizedBox(width: 14 * scale),

          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8 * scale),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: const Color(0xff4F545F),
                      fontSize: 11.31 * scale,
                      fontWeight: FontWeight.w600,
                      height: 1,
                    ),
                  ),

                  SizedBox(height: 6 * scale),

                  Expanded(
                    child: Text(
                      description,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: const Color(0xff8C8F97),
                        fontSize: 8.08 * scale,
                        fontWeight: FontWeight.w400,
                        height: 1.28,
                      ),
                    ),
                  ),

                  SizedBox(height: 4 * scale),

                  Row(
                    children: [
                      Icon(
                        Icons.schedule,
                        color: const Color(0xff063DF2),
                        size: 10 * scale,
                      ),

                      SizedBox(width: 5 * scale),

                      Flexible(
                        child: Text(
                          footer,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: const Color(0xff6E83DF),
                            fontSize: 7.27 * scale,
                            fontWeight: FontWeight.w400,
                            height: 1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.only(right: 16 * scale),
            child: Icon(
              Icons.chevron_right,
              color: const Color(0xff70747D),
              size: 18 * scale,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoBox extends StatelessWidget {
  const _InfoBox();

  @override
  Widget build(BuildContext context) {
    final double scale = _Responsive.scale(context);

    return Container(
      height: 56 * scale,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xffFDFEFD),
        borderRadius: BorderRadius.circular(6 * scale),
      ),
      child: Row(
        children: [
          SizedBox(width: 17 * scale),

          Container(
            width: 21 * scale,
            height: 21 * scale,
            decoration: const BoxDecoration(
              color: Color(0xff0034C2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.info,
              color: Colors.white,
              size: 14 * scale,
            ),
          ),

          SizedBox(width: 11 * scale),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Atendimento humanizado e inclusivo',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: const Color(0xff576BD5),
                    fontSize: 9.69 * scale,
                    fontWeight: FontWeight.w700,
                    height: 1,
                  ),
                ),

                SizedBox(height: 6 * scale),

                Text(
                  'Cada pessoa é única. Aqui, o respeito e o amor transformam vidas.',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: const Color(0xff868C96),
                    fontSize: 7.27 * scale,
                    fontWeight: FontWeight.w400,
                    height: 1.2,
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