import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../auth_service.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/widgets/wave_header.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  static const Color background = Color(0xffF5F5F5);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final AuthService _authService = AuthService();
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _novaSenhaController = TextEditingController();
  final TextEditingController _confirmarSenhaController =
      TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _cpfController.dispose();
    _novaSenhaController.dispose();
    _confirmarSenhaController.dispose();
    super.dispose();
  }

  Future<void> _redefinirSenha() async {
    if (_isLoading) {
      return;
    }

    final cpf = _cpfController.text.trim();
    final novaSenha = _novaSenhaController.text;
    final confirmarSenha = _confirmarSenhaController.text;
    final validationMessage = _validateForm(
      cpf: cpf,
      novaSenha: novaSenha,
      confirmarSenha: confirmarSenha,
    );

    if (validationMessage != null) {
      _showMessage(validationMessage);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _authService.redefinirSenha(
        cpf: _onlyDigits(cpf),
        novaSenha: novaSenha,
      );

      if (!mounted) {
        return;
      }

      _showMessage('Senha alterada com sucesso. Faça login novamente.');
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    } on AuthException catch (error) {
      if (mounted) {
        _showMessage(error.message);
      }
    } on Object {
      if (mounted) {
        _showMessage('Não foi possível alterar a senha. Tente novamente.');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String? _validateForm({
    required String cpf,
    required String novaSenha,
    required String confirmarSenha,
  }) {
    final cpfDigits = _onlyDigits(cpf);

    if (cpfDigits.isEmpty) {
      return 'Informe seu CPF.';
    }

    if (cpfDigits.length != 11) {
      return 'Informe um CPF válido.';
    }

    if (novaSenha.isEmpty) {
      return 'Informe a nova senha.';
    }

    if (novaSenha.length < 6) {
      return 'A nova senha deve ter pelo menos 6 caracteres.';
    }

    if (confirmarSenha.isEmpty) {
      return 'Confirme a nova senha.';
    }

    if (novaSenha != confirmarSenha) {
      return 'As senhas não conferem.';
    }

    return null;
  }

  String _onlyDigits(String value) {
    return value.replaceAll(RegExp(r'\D'), '');
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
        backgroundColor: ForgotPasswordPage.background,
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  const WaveHeader(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        const SizedBox(height: 32),
                        Image.asset(
                          'assets/images/logo.png',
                          width: 220,
                          height: 94,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'AAMAVASF',
                          style: TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.w700,
                            color: Color(0xff1634C1),
                            height: 1,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'ASSOCIACAO DE AMIGOS DO AUTISTA',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Color(0xff5D68CB),
                            height: 1,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'DO VALE DO SAO FRANCISCO',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Color(0xff5764CC),
                            height: 1,
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Redefinir senha',
                          style: AppTextStyles.title,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Informe seu CPF e cadastre uma nova senha.',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.subtitle,
                        ),
                        const SizedBox(height: 26),
                        CustomTextField(
                          hintText: 'CPF',
                          icon: Icons.badge_outlined,
                          controller: _cpfController,
                          enabled: !_isLoading,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: 14),
                        CustomTextField(
                          hintText: 'Nova senha',
                          icon: Icons.lock_outline,
                          isPassword: true,
                          controller: _novaSenhaController,
                          enabled: !_isLoading,
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: 14),
                        CustomTextField(
                          hintText: 'Confirmar nova senha',
                          icon: Icons.lock_reset_outlined,
                          isPassword: true,
                          controller: _confirmarSenhaController,
                          enabled: !_isLoading,
                          textInputAction: TextInputAction.done,
                          onSubmitted: (_) => _redefinirSenha(),
                        ),
                        const SizedBox(height: 18),
                        PrimaryButton(
                          text: _isLoading ? 'Alterando...' : 'Alterar senha',
                          onPressed: _redefinirSenha,
                        ),
                        const SizedBox(height: 18),
                        TextButton(
                          onPressed: _isLoading
                              ? null
                              : () {
                                  Navigator.pop(context);
                                },
                          child: const Text(
                            'Voltar para o login',
                            style: TextStyle(
                              color: Color(0xff5E74DD),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(left: 12, top: 8),
                child: IconButton(
                  onPressed: _isLoading
                      ? null
                      : () {
                          Navigator.pop(context);
                        },
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
