import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:mobile/core/widgets/bottom_menu.dart';
import 'package:mobile/core/widgets/wave_header.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  static const Color primaryBlue = Color(0xff012A9F);
  static const Color iconBlue = Color(0xff002FD1);
  static const Color background = Color(0xffF6F8FC);

  static const String aboutIconAsset = 'assets/icons/heart_puzzle.svg';

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
              const _ContactHeader(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 14 * scale),
                    const _SectionTitle(
                      icon: Icons.support_agent_outlined,
                      title: 'Fale conosco',
                    ),
                    SizedBox(height: 8 * scale),
                    const _ContactCard(),
                    SizedBox(height: 18 * scale),
                    const _SectionTitle(
                      icon: Icons.location_on_outlined,
                      title: 'Onde estamos',
                    ),
                    SizedBox(height: 8 * scale),
                    const _LocationCard(),
                    SizedBox(height: 18 * scale),
                    const _SectionTitle(
                      icon: Icons.info_outline,
                      title: 'Sobre a AAMAVASF',
                    ),
                    SizedBox(height: 8 * scale),
                    const _AboutCard(),
                    SizedBox(height: 18 * scale),
                    const _SectionTitle(
                      icon: Icons.schedule_outlined,
                      title: 'Horário de atendimento',
                    ),
                    SizedBox(height: 8 * scale),
                    const _ScheduleCard(),
                    SizedBox(height: 18 * scale),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: const BottomMenu(
          selectedIndex: 3,
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

class _ContactHeader extends StatelessWidget {
  const _ContactHeader();

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
      backgroundColor: const Color(0xff012A9F),
      child: Stack(
        children: [
          Positioned(
            top: topSafe + (8 * scale),
            left: 0,
            right: 0,
            child: Column(
              children: [
                Text(
                  'Contatos e Informações',
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
                SizedBox(height: 12 * scale),
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

class _SectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SectionTitle({
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final double scale = _Responsive.scale(context);

    return Row(
      children: [
        Icon(
          icon,
          size: 14 * scale,
          color: const Color(0xff000047),
        ),
        SizedBox(width: 8 * scale),
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 11.38 * scale,
            fontWeight: FontWeight.w700,
            color: const Color(0xff525A79),
          ),
        ),
      ],
    );
  }
}

class _ContactCard extends StatelessWidget {
  const _ContactCard();

  @override
  Widget build(BuildContext context) {
    final double scale = _Responsive.scale(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 8 * scale),
      decoration: _cardDecoration(scale),
      child: const Column(
        children: [
          _ContactItem(
            icon: Icons.phone_outlined,
            title: 'Telefone',
            value: '(81) 3861-3088',
          ),
          _ContactItem(
            icon: FontAwesomeIcons.whatsapp,
            title: 'WhatsApp',
            value: '(81) 9 9999-9999',
            isFontAwesome: true,
          ),
          _ContactItem(
            icon: Icons.email_outlined,
            title: 'E-mail',
            value: 'contato@aamavasf.org.br',
          ),
          _ContactItem(
            icon: FontAwesomeIcons.instagram,
            title: 'Instagram',
            value: '@aamavasf',
            isFontAwesome: true,
          ),
          _ContactItem(
            icon: FontAwesomeIcons.facebookF,
            title: 'Facebook',
            value: '/aamavasf',
            isFontAwesome: true,
            showDivider: false,
          ),
        ],
      ),
    );
  }
}

class _ContactItem extends StatelessWidget {
  final dynamic icon;
  final String title;
  final String value;
  final bool isFontAwesome;
  final bool showDivider;

  const _ContactItem({
    required this.icon,
    required this.title,
    required this.value,
    this.isFontAwesome = false,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    final double scale = _Responsive.scale(context);

    return SizedBox(
      height: 45 * scale,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12 * scale),
        child: Row(
          children: [
            Container(
              width: 36 * scale,
              height: 36 * scale,
              decoration: const BoxDecoration(
                color: Color(0xffE7E9FD),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: isFontAwesome
                    ? FaIcon(
                        icon,
                        size: 18 * scale,
                        color: ContactPage.iconBlue,
                      )
                    : Icon(
                        icon as IconData,
                        size: 18 * scale,
                        color: ContactPage.iconBlue,
                      ),
              ),
            ),
            SizedBox(width: 14 * scale),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: showDivider
                      ? const Border(
                          bottom: BorderSide(
                            color: Color(0xffF0F2F7),
                            width: 1,
                          ),
                        )
                      : null,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 8.94 * scale,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xff50525B),
                      ),
                    ),
                    SizedBox(height: 4 * scale),
                    Text(
                      value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 8.94 * scale,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xff888C99),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LocationCard extends StatelessWidget {
  const _LocationCard();

  @override
  Widget build(BuildContext context) {
    final double scale = _Responsive.scale(context);
    final bool compact = _Responsive.isSmallScreen(context);

    final double mapWidth = compact ? 110 * scale : 131 * scale;
    final double mapHeight = compact ? 86 * scale : 90 * scale;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12 * scale),
      decoration: _cardDecoration(scale),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: mapWidth,
            height: mapHeight,
            decoration: BoxDecoration(
              color: const Color(0xffEFEFEF),
              borderRadius: BorderRadius.circular(4 * scale),
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: CustomPaint(
                    painter: _MapPainter(),
                  ),
                ),
                Center(
                  child: Icon(
                    Icons.location_on,
                    size: 28 * scale,
                    color: ContactPage.iconBlue,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 10 * scale),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sede AAMAVASF',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 10.56 * scale,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xff4D4F58),
                  ),
                ),
                SizedBox(height: 6 * scale),
                Text(
                  'Rua das Acácias, 123\nCentro – Petrolina/PE\nCEP: 56304-120',
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 9.75 * scale,
                    fontWeight: FontWeight.w400,
                    height: 1.31,
                    color: const Color(0xff8A8E9A),
                  ),
                ),
                SizedBox(height: 8 * scale),
                const _MapLink(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MapLink extends StatelessWidget {
  const _MapLink();

  @override
  Widget build(BuildContext context) {
    final double scale = _Responsive.scale(context);

    return Row(
      children: [
        Text(
          'Ver no mapa',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 8.94 * scale,
            fontWeight: FontWeight.w600,
            color: const Color(0xff6274DF),
          ),
        ),
        SizedBox(width: 5 * scale),
        Icon(
          Icons.open_in_new,
          size: 10 * scale,
          color: const Color(0xff0019E5),
        ),
      ],
    );
  }
}

class _AboutCard extends StatelessWidget {
  const _AboutCard();

  @override
  Widget build(BuildContext context) {
    final double scale = _Responsive.scale(context);
    final bool compact = _Responsive.isSmallScreen(context);

    final double iconSize = compact ? 38 * scale : 46 * scale;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        18 * scale,
        12 * scale,
        18 * scale,
        12 * scale,
      ),
      decoration: _cardDecoration(scale),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            ContactPage.aboutIconAsset,
            width: iconSize,
            height: iconSize,
            fit: BoxFit.contain,
          ),
          SizedBox(width: compact ? 14 * scale : 22 * scale),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'A AAMAVASF é uma associação sem fins lucrativos que atua na promoção da inclusão, apoio e qualidade de vida das pessoas com Transtorno do Espectro Autista e suas famílias.',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 9.75 * scale,
                    fontWeight: FontWeight.w400,
                    height: 1.36,
                    color: const Color(0xff7E8392),
                  ),
                ),
                SizedBox(height: 8 * scale),
                Row(
                  children: [
                    Text(
                      'Saiba mais sobre nós',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 8.94 * scale,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xff5D70E0),
                      ),
                    ),
                    SizedBox(width: 5 * scale),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 8 * scale,
                      color: const Color(0xff020AEE),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ScheduleCard extends StatelessWidget {
  const _ScheduleCard();

  @override
  Widget build(BuildContext context) {
    final double scale = _Responsive.scale(context);

    return Container(
      constraints: BoxConstraints(
        minHeight: 52 * scale,
      ),
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 14 * scale,
        vertical: 7 * scale,
      ),
      decoration: _cardDecoration(scale),
      child: Row(
        children: [
          Container(
            width: 37 * scale,
            height: 37 * scale,
            decoration: const BoxDecoration(
              color: Color(0xffE8EDFD),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.calendar_month_outlined,
              size: 18 * scale,
              color: ContactPage.iconBlue,
            ),
          ),
          SizedBox(width: 11 * scale),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Segunda a Sexta',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 8.94 * scale,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xff585A61),
                  ),
                ),
                SizedBox(height: 5 * scale),
                Text(
                  '07:30 às 12:00 | 13:30 às 17:30',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 9.75 * scale,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xff8E919C),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8 * scale),
          Container(
            width: 73 * scale,
            height: 21 * scale,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xffECF7EF),
              borderRadius: BorderRadius.circular(9 * scale),
              border: Border.all(
                color: const Color(0xffF5FAF6),
                width: 0.8,
              ),
            ),
            child: Text(
              'Aberto agora',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 8.13 * scale,
                fontWeight: FontWeight.w600,
                color: const Color(0xff63B46F),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final roadPaint = Paint()
      ..color = const Color(0xffD8D8D8)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final thinRoadPaint = Paint()
      ..color = const Color(0xffE5E5E5)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(0, size.height * 0.25),
      Offset(size.width, size.height * 0.05),
      thinRoadPaint,
    );

    canvas.drawLine(
      Offset(size.width * 0.12, size.height),
      Offset(size.width * 0.95, 0),
      roadPaint,
    );

    canvas.drawLine(
      Offset(0, size.height * 0.70),
      Offset(size.width, size.height * 0.45),
      thinRoadPaint,
    );

    canvas.drawLine(
      Offset(size.width * 0.25, 0),
      Offset(size.width * 0.55, size.height),
      thinRoadPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

BoxDecoration _cardDecoration(double scale) {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(4 * scale),
    border: Border.all(
      color: const Color(0xffF7F9FB),
      width: 1.2 * scale,
    ),
  );
}