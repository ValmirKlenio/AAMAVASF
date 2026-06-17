import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile/features/auth/login/widgets/social_login_widget.dart';

import '../../../auth_service.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/wave_header.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/primary_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  static const Color background = Color(0xffF5F5F5);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService _authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_isLoading) {
      return;
    }

    final email = _emailController.text.trim();
    final senha = _senhaController.text;

    if (email.isEmpty || senha.isEmpty) {
      _showMessage('Informe e-mail e senha para continuar.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _authService.login(email, senha);

      if (!mounted) {
        return;
      }

      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } on AuthException catch (error) {
      if (mounted) {
        _showMessage(error.message);
      }
    } on Object {
      if (mounted) {
        _showMessage('Não foi possível fazer login. Tente novamente.');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
        systemStatusBarContrastEnforced: false,
        systemNavigationBarContrastEnforced: false,
      ),
      child: Scaffold(
        backgroundColor: LoginPage.background,
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

                    const Text('Bem-vindo(a)!', style: AppTextStyles.title),

                    const SizedBox(height: 8),

                    const Text(
                      'Faça login para continuar',
                      style: AppTextStyles.subtitle,
                    ),

                    const SizedBox(height: 28),

                    CustomTextField(
                      hintText: 'E-mail',
                      icon: Icons.person_outline,
                      controller: _emailController,
                      enabled: !_isLoading,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                    ),

                    const SizedBox(height: 14),

                    CustomTextField(
                      hintText: 'Senha',
                      icon: Icons.lock_outline,
                      isPassword: true,
                      controller: _senhaController,
                      enabled: !_isLoading,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => _login(),
                    ),

                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: _isLoading
                            ? null
                            : () {
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.forgotPassword,
                                );
                              },
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
                      text: _isLoading ? 'Entrando...' : 'Entrar',
                      onPressed: _login,
                    ),

                    const SizedBox(height: 30),

                    const SocialLoginWidget(),

                    const SizedBox(height: 30),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Ainda não tem uma conta?',
                          style: TextStyle(color: Color(0xff9DA0A6)),
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

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
