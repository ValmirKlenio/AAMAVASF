import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _WaveClipper(),
      child: Container(
        height: 100,
        color: AppColors.primary,
      ),
    );
  }
}

class _WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.lineTo(0, size.height * 0.8);

    path.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.45,
      size.width * 0.5,
      size.height * 0.7,
    );

    path.quadraticBezierTo(
      size.width * 0.75,
      size.height,
      size.width,
      size.height * 0.4,
    );

    path.lineTo(size.width, 0);

    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}