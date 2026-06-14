import 'package:flutter/material.dart';

import '../../features/auth/login/login_page.dart';
import '../../features/auth/register/register_page.dart';
import '../../features/contact/contact_page.dart';
import '../../features/home/home_page.dart';
import '../../features/splash/splash_page.dart';
import 'app_routes.dart';

class AppPages {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    late final Widget page;

    switch (settings.name) {
      case AppRoutes.splash:
        page = const SplashPage();
        break;

      case AppRoutes.login:
        page = const LoginPage();
        break;

      case AppRoutes.register:
        page = const RegisterPage();
        break;

      case AppRoutes.home:
        page = const HomePage();
        break;

      case AppRoutes.contact:
        page = const ContactPage();
        break;

      default:
        page = const SplashPage();
    }

    return PageRouteBuilder(
      settings: settings,
      transitionDuration: const Duration(milliseconds: 420),
      reverseTransitionDuration: const Duration(milliseconds: 320),
      pageBuilder: (context, animation, secondaryAnimation) {
        return page;
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        );

        final fadeAnimation = Tween<double>(
          begin: 0,
          end: 1,
        ).animate(curvedAnimation);

        final slideAnimation = Tween<Offset>(
          begin: const Offset(0.08, 0),
          end: Offset.zero,
        ).animate(curvedAnimation);

        final scaleAnimation = Tween<double>(
          begin: 0.98,
          end: 1,
        ).animate(curvedAnimation);

        return FadeTransition(
          opacity: fadeAnimation,
          child: SlideTransition(
            position: slideAnimation,
            child: ScaleTransition(
              scale: scaleAnimation,
              child: child,
            ),
          ),
        );
      },
    );
  }
}