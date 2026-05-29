import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/routes/app_routes.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _loadingController;
  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();

    _loadingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();

    _navigationTimer = Timer(const Duration(seconds: 5), () {
      if (!mounted) return;

      Navigator.pushReplacementNamed(
        context,
        AppRoutes.login,
      );
    });
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    _loadingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const designWidth = 402.0;
    const designHeight = 874.0;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Color(0xff022DB6),
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xffFDFEFF),
        body: LayoutBuilder(
          builder: (context, constraints) {
            final sx = constraints.maxWidth / designWidth;
            final sy = constraints.maxHeight / designHeight;
            final sr = math.min(sx, sy);

            double w(double value) => value * sx;
            double h(double value) => value * sy;
            double r(double value) => value * sr;

            return Stack(
              children: [
                Positioned.fill(
                  child: Container(
                    color: const Color(0xffFDFEFF),
                  ),
                ),

                Positioned(
                  top: h(125),
                  left: 0,
                  right: 0,
                  child: Column(
                    children: [
                      SizedBox(
                        width: w(250),
                        height: h(112),
                        child: Image.asset(
                          'assets/images/logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),

                      SizedBox(height: h(2)),

                      SizedBox(
                        width: w(250),
                        height: h(42),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'AAMAVASF',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: r(40),
                              fontWeight: FontWeight.w900,
                              height: 1,
                              color: const Color(0xff1135BF),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: h(4)),

                      SizedBox(
                        width: w(250),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'ASSOCIAÇÃO DE AMIGOS DO AUTISTA',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: r(10.4),
                              fontWeight: FontWeight.w700,
                              height: 1,
                              color: const Color(0xff4957B0),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: h(3)),

                      SizedBox(
                        width: w(210),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'DO VALE DO SAO FRANCISCO',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: r(10.4),
                              fontWeight: FontWeight.w700,
                              height: 1,
                              color: const Color(0xff4957B0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Positioned(
                  top: h(532),
                  left: 0,
                  child: ClipPath(
                    clipper: _BlueWaveClipper(),
                    child: Container(
                      width: constraints.maxWidth,
                      height: h(368),
                      color: const Color(0xff022DB6),
                    ),
                  ),
                ),

                Positioned(
                  top: h(545),
                  left: w(165),
                  child: ClipPath(
                    clipper: _WaveShadowClipper(),
                    child: Container(
                      width: w(260),
                      height: h(58.64),
                      color: const Color(0xffE9EEFC),
                    ),
                  ),
                ),

                Positioned(
                  top: h(640),
                  left: 0,
                  right: 0,
                  child: Icon(
                    Icons.favorite_border_rounded,
                    size: r(36),
                    color: const Color(0xffFFFB00),
                  ),
                ),

                Positioned(
                  top: h(688),
                  left: 0,
                  right: 0,
                  child: Center(
                    child: SizedBox(
                      width: w(230),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'Acolher, incluir e amar',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: r(18.1),
                            fontWeight: FontWeight.w500,
                            height: 1,
                            color: const Color(0xffAFBBE8),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                Positioned(
                  top: h(713),
                  left: 0,
                  right: 0,
                  child: Center(
                    child: SizedBox(
                      width: w(255),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'para ',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: r(18.1),
                                  fontWeight: FontWeight.w400,
                                  height: 1,
                                  color: const Color(0xffB4BFE9),
                                ),
                              ),
                              TextSpan(
                                text: 'transformar vidas.',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: r(18.1),
                                  fontWeight: FontWeight.w700,
                                  height: 1,
                                  color: const Color(0xffBCB338),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                Positioned(
                  top: h(760),
                  left: 0,
                  right: 0,
                  child: Center(
                    child: AnimatedBuilder(
                      animation: _loadingController,
                      builder: (context, child) {
                        return Transform.rotate(
                          angle: _loadingController.value * 2 * math.pi,
                          child: CustomPaint(
                            size: Size(r(24), r(24)),
                            painter: _LoadingPainter(
                              strokeWidth: r(2),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _BlueWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.moveTo(0, 0);

    path.cubicTo(
      size.width * 0.16,
      -5,
      size.width * 0.26,
      18,
      size.width * 0.40,
      44,
    );

    path.cubicTo(
      size.width * 0.53,
      68,
      size.width * 0.63,
      76,
      size.width * 0.76,
      60,
    );

    path.cubicTo(
      size.width * 0.88,
      45,
      size.width * 0.96,
      34,
      size.width,
      43,
    );

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

class _WaveShadowClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final sx = size.width / 260;
    final sy = size.height / 59;

    double x(double value) => value * sx;
    double y(double value) => value * sy;

    final path = Path();

    path.moveTo(x(82.5), y(18.8582));

    path.cubicTo(
      x(51.3039),
      y(24.6314),
      x(33.2213),
      y(25.089),
      x(0),
      y(21.3582),
    );

    path.lineTo(x(14.5), y(33.3582));

    path.cubicTo(
      x(28.4679),
      y(45.1955),
      x(38.9658),
      y(49.9623),
      x(60),
      y(56.8582),
    );

    path.cubicTo(
      x(76.207),
      y(59.162),
      x(85.2928),
      y(59.3006),
      x(101.5),
      y(56.8582),
    );

    path.cubicTo(
      x(111.055),
      y(55.8097),
      x(138.356),
      y(45.3693),
      x(145),
      y(40.3575),
    );

    path.cubicTo(
      x(168.964),
      y(29.8735),
      x(168.828),
      y(28.8341),
      x(197.5),
      y(21.3582),
    );

    path.cubicTo(
      x(223.745),
      y(17.1795),
      x(237.653),
      y(17.5376),
      x(260),
      y(26.3582),
    );

    path.lineTo(x(260), y(14.8582));

    path.cubicTo(
      x(252.634),
      y(11.1931),
      x(248.245),
      y(9.20738),
      x(238),
      y(6.35818),
    );

    path.cubicTo(
      x(211.366),
      y(-0.061841),
      x(194.8),
      y(-1.02859),
      x(163),
      y(0.858178),
    );

    path.cubicTo(
      x(138.726),
      y(3.93318),
      x(118.431),
      y(9.6116),
      x(82.5),
      y(18.8582),
    );

    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

class _LoadingPainter extends CustomPainter {
  final double strokeWidth;

  _LoadingPainter({
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xff4A8CFF)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);

    canvas.drawArc(
      rect,
      -math.pi / 2,
      math.pi * 0.75,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _LoadingPainter oldDelegate) {
    return oldDelegate.strokeWidth != strokeWidth;
  }
}