import 'package:flutter/material.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/widgets/wave_header.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/primary_button.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const AuthHeader(),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 16),

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

                  const SizedBox(height: 18),

                  const CustomTextField(
                    hintText: 'E-mail',
                    icon: Icons.email_outlined,
                  ),

                  const SizedBox(height: 8),

                  const CustomTextField(
                    hintText: 'CPF',
                    icon: Icons.badge_outlined,
                  ),

                  const SizedBox(height: 8),

                  const CustomTextField(
                    hintText: 'Senha',
                    icon: Icons.lock_outline,
                    isPassword: true,
                  ),

                  const SizedBox(height: 8),

                  const CustomTextField(
                    hintText: 'Confirme sua senha',
                    icon: Icons.lock_outline,
                    isPassword: true,
                  ),

                  const SizedBox(height: 34),

                  PrimaryButton(
                    text: 'Cadastrar',
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.login);
                    },
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