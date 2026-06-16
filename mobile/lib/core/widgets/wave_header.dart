import 'package:flutter/material.dart';

class WaveHeader extends StatelessWidget {
  final double height;
  final Color backgroundColor;
  final Widget? child;

  const WaveHeader({
    super.key,
    this.height = 188,
    this.backgroundColor = const Color(0xff012A9F),
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: const _WaveHeaderClipper(),
      child: Container(
        width: double.infinity,
        height: height,
        color: backgroundColor,
        child: child,
      ),
    );
  }
}

class _WaveHeaderClipper extends CustomClipper<Path> {
  const _WaveHeaderClipper();

  @override
  Path getClip(Size size) {
    final sx = size.width / 401;
    final sy = size.height / 172;

    double x(double value) => value * sx;
    double y(double value) => value * sy;

    final path = Path();

    path.moveTo(x(52.3739), y(160.634));

    path.cubicTo(
      x(32.1083),
      y(163.336),
      x(20.4911),
      y(163.886),
      x(0),
      y(164.294),
    );

    path.lineTo(x(0), y(0));
    path.lineTo(x(401), y(0));
    path.lineTo(x(401), y(164.294));

    path.cubicTo(
      x(392.066),
      y(165.111),
      x(387.129),
      y(164.978),
      x(377.412),
      y(166.327),
    );

    path.cubicTo(
      x(358.675),
      y(169.177),
      x(347.781),
      y(168.960),
      x(325.837),
      y(169.987),
    );

    path.cubicTo(
      x(303.209),
      y(172.503),
      x(290.514),
      y(172.352),
      x(267.866),
      y(171.207),
    );

    path.cubicTo(
      x(247.189),
      y(170.454),
      x(235.715),
      y(169.286),
      x(215.493),
      y(165.514),
    );

    path.cubicTo(
      x(200.070),
      y(163.466),
      x(191.479),
      y(162.041),
      x(176.312),
      y(158.601),
    );

    path.cubicTo(
      x(165.093),
      y(156.555),
      x(158.587),
      y(155.703),
      x(146.727),
      y(154.534),
    );

    path.cubicTo(
      x(125.179),
      y(153.498),
      x(113.101),
      y(153.488),
      x(91.5543),
      y(155.347),
    );

    path.cubicTo(
      x(79.2309),
      y(157.627),
      x(72.0663),
      y(158.127),
      x(52.3739),
      y(160.634),
    );

    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}