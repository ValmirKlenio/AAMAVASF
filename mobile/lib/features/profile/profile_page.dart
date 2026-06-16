import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/widgets/bottom_menu.dart';
import '../../core/widgets/wave_header.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

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
        body: ScrollConfiguration(
          behavior: const _NoPullScrollBehavior(),
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              children: [
                const _ProfileTopSection(),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10 * scale),

                      const _SupportCard(),

                      SizedBox(height: 14 * scale),

                      const _SectionTitle(title: 'Meus dados'),

                      SizedBox(height: 8 * scale),

                      const _MenuCard(
                        title: 'Dados pessoais',
                        subtitle: 'Nome, contato e informações pessoais',
                        icon: Icons.person_outline,
                        iconColor: Color(0xff001BF3),
                        iconBackground: Color(0xffE5E9FF),
                      ),

                      SizedBox(height: 7 * scale),

                      const _MenuCard(
                        title: 'Dependentes',
                        subtitle: 'Pessoas vinculadas à sua conta',
                        icon: Icons.groups_2_outlined,
                        iconColor: Color(0xff02AA30),
                        iconBackground: Color(0xffEDF8EE),
                      ),

                      SizedBox(height: 7 * scale),

                      const _MenuCard(
                        title: 'Agendamentos',
                        subtitle: 'Consultas, eventos e atendimentos',
                        icon: Icons.calendar_month_outlined,
                        iconColor: Color(0xffFFB102),
                        iconBackground: Color(0xffFDF5E4),
                      ),

                      SizedBox(height: 7 * scale),

                      const _MenuCard(
                        title: 'Como ajudar',
                        subtitle: 'Apoio, doações e participação',
                        icon: Icons.favorite_border,
                        iconColor: Color(0xffFF3A04),
                        iconBackground: Color(0xffFBEDED),
                      ),

                      SizedBox(height: 18 * scale),

                      const _SectionTitle(title: 'Configurações'),

                      SizedBox(height: 8 * scale),

                      const _MenuCard(
                        title: 'Configurações do app',
                        subtitle: 'Notificações, privacidade e mais',
                        icon: Icons.settings_outlined,
                        iconColor: Color(0xff4739F7),
                        iconBackground: Color(0xffEBE9FF),
                      ),

                      SizedBox(height: 7 * scale),

                      const _MenuCard(
                        title: 'Ajuda e suporte',
                        subtitle: 'Dúvidas frequentes e contato',
                        icon: Icons.help_outline,
                        iconColor: Color(0xff196CFC),
                        iconBackground: Color(0xffF1F4FE),
                      ),

                      SizedBox(height: 10 * scale),

                      const _LogoutButton(),

                      SizedBox(height: 24 * scale),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: const BottomMenu(
          selectedIndex: 4,
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

class _ProfileTopSection extends StatelessWidget {
  const _ProfileTopSection();

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

    return SizedBox(
      height: headerHeight + (58 * scale),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          WaveHeader(
            height: headerHeight,
            backgroundColor: ProfilePage.primaryBlue,
            child: Stack(
              children: [
                Positioned(
                  top: topSafe + (100 * scale),
                  left: 24 * scale,
                  child: Text(
                    'Meu Perfil',
                    style: TextStyle(
                      color: const Color(0xffD8DFF3),
                      fontSize: 12 * scale,
                      fontWeight: FontWeight.w700,
                      height: 1,
                    ),
                  ),
                ),

                Positioned(
                  top: topSafe + (4 * scale),
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
          ),

          Positioned(
            left: _Responsive.horizontalPadding(context),
            right: _Responsive.horizontalPadding(context),
            bottom: 0,
            child: const _ProfileCard(),
          ),
        ],
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard();

  @override
  Widget build(BuildContext context) {
    final double scale = _Responsive.scale(context);

    return Container(
      height: 118 * scale,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xffFEFEFE),
        borderRadius: BorderRadius.circular(20 * scale),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10 * scale,
            offset: Offset(0, 4 * scale),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(width: 17 * scale),

          Container(
            width: 77 * scale,
            height: 77 * scale,
            decoration: const BoxDecoration(
              color: Color(0xffEBEFFC),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.person,
              color: const Color(0xff779FFF),
              size: 42 * scale,
            ),
          ),

          SizedBox(width: 15 * scale),

          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                top: 20 * scale,
                right: 8 * scale,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Maria Silva',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: const Color(0xff4F5769),
                      fontSize: 14.53 * scale,
                      fontWeight: FontWeight.w600,
                      height: 1,
                    ),
                  ),

                  SizedBox(height: 8 * scale),

                  const _ProfileInfoLine(
                    icon: Icons.person_outline,
                    text: 'Responsável',
                  ),

                  SizedBox(height: 7 * scale),

                  const _ProfileInfoLine(
                    icon: Icons.email_outlined,
                    text: 'maria.silva@email.com',
                  ),

                  SizedBox(height: 7 * scale),

                  const _ProfileInfoLine(
                    icon: Icons.phone_outlined,
                    text: '(87) 9 9999-9999',
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.only(right: 14 * scale),
            child: Icon(
              Icons.chevron_right,
              color: const Color(0xff7F8490),
              size: 18 * scale,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileInfoLine extends StatelessWidget {
  final IconData icon;
  final String text;

  const _ProfileInfoLine({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final double scale = _Responsive.scale(context);

    return Row(
      children: [
        Icon(
          icon,
          color: const Color(0xff7E8490),
          size: 11 * scale,
        ),

        SizedBox(width: 7 * scale),

        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: const Color(0xff8B8E96),
              fontSize: 8.88 * scale,
              fontWeight: FontWeight.w400,
              height: 1,
            ),
          ),
        ),
      ],
    );
  }
}

class _SupportCard extends StatelessWidget {
  const _SupportCard();

  @override
  Widget build(BuildContext context) {
    final double scale = _Responsive.scale(context);

    return Container(
      height: 49 * scale,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xffEDF3FD),
        borderRadius: BorderRadius.circular(5.65 * scale),
      ),
      child: Row(
        children: [
          SizedBox(width: 22 * scale),

          Icon(
            Icons.volunteer_activism_outlined,
            color: const Color(0xff011CCF),
            size: 26 * scale,
          ),

          SizedBox(width: 20 * scale),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Você faz a diferença!',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: const Color(0xff4E65C2),
                    fontSize: 11.3 * scale,
                    fontWeight: FontWeight.w600,
                    height: 1,
                  ),
                ),

                SizedBox(height: 7 * scale),

                Text(
                  'Seu apoio e participação transformam vidas.',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: const Color(0xff8B919F),
                    fontSize: 8.88 * scale,
                    fontWeight: FontWeight.w400,
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

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final double scale = _Responsive.scale(context);

    return Padding(
      padding: EdgeInsets.only(left: 6 * scale),
      child: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: const Color(0xff5B6172),
          fontSize: 10.49 * scale,
          fontWeight: FontWeight.w600,
          height: 1,
        ),
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final Color iconBackground;

  const _MenuCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
  });

  @override
  Widget build(BuildContext context) {
    final double scale = _Responsive.scale(context);

    return Container(
      height: 50 * scale,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xffFDFDFD),
        borderRadius: BorderRadius.circular(2 * scale),
      ),
      child: Row(
        children: [
          SizedBox(width: 9 * scale),

          Container(
            width: 33 * scale,
            height: 33 * scale,
            decoration: BoxDecoration(
              color: iconBackground,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 17 * scale,
            ),
          ),

          SizedBox(width: 13 * scale),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: const Color(0xff616779),
                    fontSize: 9.68 * scale,
                    fontWeight: FontWeight.w600,
                    height: 1,
                  ),
                ),

                SizedBox(height: 6 * scale),

                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: const Color(0xffACAFB7),
                    fontSize: 8.07 * scale,
                    fontWeight: FontWeight.w400,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.only(right: 13 * scale),
            child: Icon(
              Icons.chevron_right,
              color: const Color(0xff7F8490),
              size: 16 * scale,
            ),
          ),
        ],
      ),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  const _LogoutButton();

  @override
  Widget build(BuildContext context) {
    final double scale = _Responsive.scale(context);

    return Container(
      height: 40 * scale,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xffFEFEFD),
        borderRadius: BorderRadius.circular(4.84 * scale),
        border: Border.all(
          color: const Color(0xffF0F2F5),
          width: 0.81 * scale,
        ),
      ),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.logout,
              color: const Color(0xffFE0E05),
              size: 13 * scale,
            ),

            SizedBox(width: 8 * scale),

            Text(
              'Sair da conta',
              style: TextStyle(
                color: const Color(0xffE55E5C),
                fontSize: 9.68 * scale,
                fontWeight: FontWeight.w700,
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}