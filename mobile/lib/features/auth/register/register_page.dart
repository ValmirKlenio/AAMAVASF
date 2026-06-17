import 'package:flutter/material.dart';

import '../../../auth_service.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/widgets/wave_header.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/primary_button.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final AuthService _authService = AuthService();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _confirmarSenhaController =
      TextEditingController();
  final TextEditingController _nomeDependenteController =
      TextEditingController();
  final TextEditingController _dataNascDepController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _cpfController.dispose();
    _telefoneController.dispose();
    _senhaController.dispose();
    _confirmarSenhaController.dispose();
    _nomeDependenteController.dispose();
    _dataNascDepController.dispose();
    super.dispose();
  }

  Future<void> _registrar() async {
    if (_isLoading) {
      return;
    }

    final nome = _nomeController.text.trim();
    final email = _emailController.text.trim();
    final cpf = _cpfController.text.trim();
    final telefone = _telefoneController.text.trim();
    final senha = _senhaController.text;
    final confirmarSenha = _confirmarSenhaController.text;
    final nomeDependente = _nomeDependenteController.text.trim();
    final dataNascDep = _normalizarData(_dataNascDepController.text.trim());

    final validationMessage = _validarCampos(
      nome: nome,
      email: email,
      cpf: cpf,
      telefone: telefone,
      senha: senha,
      confirmarSenha: confirmarSenha,
      nomeDependente: nomeDependente,
      dataNascDep: dataNascDep,
    );

    if (validationMessage != null) {
      _showMessage(validationMessage);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final hasToken = await _authService.registrar(
        nome: nome,
        email: email,
        senha: senha,
        cpf: cpf,
        telefone: telefone,
        nomeDependente: nomeDependente,
        dataNascDep: dataNascDep,
      );

      if (!mounted) {
        return;
      }

      _showMessage('Cadastro realizado com sucesso.');

      await Future<void>.delayed(const Duration(milliseconds: 700));

      if (!mounted) {
        return;
      }

      Navigator.pushReplacementNamed(
        context,
        hasToken ? AppRoutes.home : AppRoutes.login,
      );
    } on AuthException catch (error) {
      if (mounted) {
        _showMessage(error.message);
      }
    } on Object {
      if (mounted) {
        _showMessage('Não foi possível concluir o cadastro. Tente novamente.');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String? _validarCampos({
    required String nome,
    required String email,
    required String cpf,
    required String telefone,
    required String senha,
    required String confirmarSenha,
    required String nomeDependente,
    required String dataNascDep,
  }) {
    if (nome.isEmpty) {
      return 'Informe seu nome.';
    }

    if (email.isEmpty) {
      return 'Informe seu e-mail.';
    }

    if (!_emailValido(email)) {
      return 'Informe um e-mail válido.';
    }

    if (cpf.isEmpty) {
      return 'Informe seu CPF.';
    }

    if (telefone.isEmpty) {
      return 'Informe seu telefone.';
    }

    if (senha.isEmpty) {
      return 'Informe uma senha.';
    }

    if (confirmarSenha.isEmpty) {
      return 'Confirme sua senha.';
    }

    if (senha != confirmarSenha) {
      return 'As senhas não conferem.';
    }

    if (nomeDependente.isEmpty) {
      return 'Informe o nome do dependente.';
    }

    if (dataNascDep.isEmpty) {
      return 'Informe a data de nascimento do dependente.';
    }

    if (!_dataValida(dataNascDep)) {
      return 'Informe a data no formato YYYY-MM-DD.';
    }

    return null;
  }

  bool _emailValido(String email) {
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);
  }

  String _normalizarData(String value) {
    if (RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(value)) {
      return value;
    }

    final match = RegExp(r'^(\d{2})/(\d{2})/(\d{4})$').firstMatch(value);

    if (match == null) {
      return value;
    }

    return '${match.group(3)}-${match.group(2)}-${match.group(1)}';
  }

  bool _dataValida(String value) {
    final match = RegExp(r'^(\d{4})-(\d{2})-(\d{2})$').firstMatch(value);

    if (match == null) {
      return false;
    }

    final year = int.tryParse(match.group(1)!);
    final month = int.tryParse(match.group(2)!);
    final day = int.tryParse(match.group(3)!);

    if (year == null || month == null || day == null) {
      return false;
    }

    final date = DateTime.tryParse(value);

    return date != null &&
        date.year == year &&
        date.month == month &&
        date.day == day;
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
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

                      CustomTextField(
                        hintText: 'Nome completo',
                        icon: Icons.person_outline,
                        controller: _nomeController,
                        enabled: !_isLoading,
                        textInputAction: TextInputAction.next,
                      ),

                      const SizedBox(height: 8),

                      CustomTextField(
                        hintText: 'E-mail',
                        icon: Icons.email_outlined,
                        controller: _emailController,
                        enabled: !_isLoading,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                      ),

                      const SizedBox(height: 8),

                      CustomTextField(
                        hintText: 'CPF',
                        icon: Icons.badge_outlined,
                        controller: _cpfController,
                        enabled: !_isLoading,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                      ),

                      const SizedBox(height: 8),

                      CustomTextField(
                        hintText: 'Telefone',
                        icon: Icons.phone_outlined,
                        controller: _telefoneController,
                        enabled: !_isLoading,
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                      ),

                      const SizedBox(height: 8),

                      CustomTextField(
                        hintText: 'Senha',
                        icon: Icons.lock_outline,
                        isPassword: true,
                        controller: _senhaController,
                        enabled: !_isLoading,
                        textInputAction: TextInputAction.next,
                      ),

                      const SizedBox(height: 8),

                      CustomTextField(
                        hintText: 'Confirme sua senha',
                        icon: Icons.lock_outline,
                        isPassword: true,
                        controller: _confirmarSenhaController,
                        enabled: !_isLoading,
                        textInputAction: TextInputAction.next,
                      ),

                      const SizedBox(height: 8),

                      CustomTextField(
                        hintText: 'Nome do dependente',
                        icon: Icons.child_care_outlined,
                        controller: _nomeDependenteController,
                        enabled: !_isLoading,
                        textInputAction: TextInputAction.next,
                      ),

                      const SizedBox(height: 8),

                      CustomTextField(
                        hintText: 'Nascimento do dependente (YYYY-MM-DD)',
                        icon: Icons.calendar_today_outlined,
                        controller: _dataNascDepController,
                        enabled: !_isLoading,
                        keyboardType: TextInputType.datetime,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => _registrar(),
                      ),

                      const SizedBox(height: 34),

                      PrimaryButton(
                        text: _isLoading ? 'Cadastrando...' : 'Cadastrar',
                        onPressed: _registrar,
                      ),

                      const SizedBox(height: 20),
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
                    : () => Navigator.pushReplacementNamed(
                        context,
                        AppRoutes.login,
                      ),
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
