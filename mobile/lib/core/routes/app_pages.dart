import 'package:flutter/material.dart';

import '../../features/splash/splash_page.dart';
import '../../features/auth/login/login_page.dart';
import '../../features/auth/register/register_page.dart';
import '../../features/home/home_page.dart';
import 'app_routes.dart';

class AppPages {
  static Map<String, WidgetBuilder> routes = {
    AppRoutes.splash: (context) => const SplashPage(),
    AppRoutes.login: (context) => const LoginPage(),

    AppRoutes.register: (context) => const RegisterPage(),
    
    AppRoutes.home: (context) => const HomePage(),
  };
}