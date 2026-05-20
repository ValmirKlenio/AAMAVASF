import 'package:flutter/material.dart';

import '../../features/auth/login/login_page.dart';
import '../../features/auth/register/register_page.dart';

import 'app_routes.dart';

class AppPages {
  static Map<String, WidgetBuilder> routes = {
    AppRoutes.login: (context) => const LoginPage(),

    AppRoutes.register: (context) => const RegisterPage(),
  };
}