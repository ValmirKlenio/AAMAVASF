import 'package:flutter/material.dart';
import 'package:mobile/features/auth/login/widgets/social_login_widget.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/wave_header.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/primary_button.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const WaveHeader(),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 40),

                  Image.asset(
                    'assets/images/logo.png',
                    width: 260,
                    height: 110,
                    fit: BoxFit.contain,
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'AAMAVASF',
                    style: TextStyle(
                      fontSize: 39.44,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff1634C1),
                      height: 1,
                    ),
                  ),

                  const SizedBox(height: 4),

                  const Text(
                    'ASSOCIACAO DE AMIGOS DO AUTISTA',
                    style: TextStyle(
                      fontSize: 12.27,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff5D68CB),
                      height: 1,
                    ),
                  ),

                  const SizedBox(height: 2),

                  const Text(
                    'DO VALE DO SAO FRANCISCO',
                    style: TextStyle(
                      fontSize: 12.27,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff5764CC),
                      height: 1,
                    ),
                  ),

                  const SizedBox(height: 24),

                  const Text(
                    'Bem-vindo(a)!',
                    style: AppTextStyles.title,
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Faça login para continuar',
                    style: AppTextStyles.subtitle,
                  ),

                  const SizedBox(height: 28),

                  const CustomTextField(
                    hintText: 'E-mail ou CPF',
                    icon: Icons.person_outline,
                  ),

                  const SizedBox(height: 14),

                  const CustomTextField(
                    hintText: 'Senha',
                    icon: Icons.lock_outline,
                    isPassword: true,
                  ),

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Esqueceu sua senha?',
                        style: TextStyle(
                          color: Color(0xff667CDE),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  PrimaryButton(
                    text: 'Entrar',
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.home);
                    },
                  ),

                  const SizedBox(height: 30),

                  const SocialLoginWidget(),

                  const SizedBox(height: 30),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Ainda não tem uma conta?',
                        style: TextStyle(
                          color: Color(0xff9DA0A6),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, AppRoutes.register);
                        },
                        child: const Text(
                          'Cadastre-se',
                          style: TextStyle(
                            color: Color(0xff5E74DD),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}