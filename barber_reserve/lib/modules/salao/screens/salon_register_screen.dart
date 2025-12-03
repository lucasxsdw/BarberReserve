// lib/screens/salon_register_screen.dart
import 'package:flutter/material.dart';
import 'package:barber_reserve/modules/usuario/models/user_model.dart';
import 'package:barber_reserve/core/auth/auth_service.dart';
import 'package:barber_reserve/core/api/api_service.dart';
import 'package:barber_reserve/modules/profissional/screens/professionals_register.dart';

class SalonRegisterScreen extends StatefulWidget {
  final UserModel user;

  const SalonRegisterScreen({
    super.key,
    required this.user,
  });

  @override
  State<SalonRegisterScreen> createState() => _SalonRegisterScreenState();
}

class _SalonRegisterScreenState extends State<SalonRegisterScreen> {
  late final TextEditingController _salonNameController;
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;

  bool _saving = false;
  int _step = 0;

  @override
  void initState() {
    super.initState();

    _salonNameController = TextEditingController();
    _nameController = TextEditingController(text: widget.user.name);
    _emailController = TextEditingController(text: widget.user.email);
    _phoneController = TextEditingController(text: widget.user.phone ?? '');
  }

  @override
  void dispose() {
    _salonNameController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _onNext() async {
    if (_saving) return;

    final nomeSalao = _salonNameController.text.trim();
    if (nomeSalao.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Informe o nome do salão.')),
      );
      return;
    }

    setState(() => _saving = true);

    try {
      final token = await AuthService.getToken();
      if (token == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Você precisa estar logado.')),
          );
          setState(() => _saving = false);
        }
        return;
      }

      final res = await ApiService.post(
        "salao",
        {"nome": nomeSalao},
        token: token,
      );

      if (!mounted) return;

      if (res["statusCode"] == 200 || res["statusCode"] == 201) {
        // pega o ID e o nome do salão retornado pela API
        final body = res["body"];
        final salaoId = body["id"]; // se no backend for outro campo, ajusta aqui
        final salaoNome = body["nome"] ?? nomeSalao;

        if (salaoId == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content:
                  Text('Salão criado, mas não recebi o ID no retorno da API.'),
            ),
          );
          return;
        }

        // vai para a tela de cadastro de profissional
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => ProfessionalRegisterScreen(
              salonName: salaoNome,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Erro ao salvar salão: ${res["body"].toString()}',
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar salão: $e')),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  /// Clica 2x só pra animar os steps; no 3º clique chama `_onNext()`
  void _onPressButton() {
    if (_saving) return;

    if (_step < 2) {
      setState(() {
        _step++;
      });
    } else {
      _onNext();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F1F1),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 40),
              const Icon(
                Icons.all_inbox_outlined,
                size: 80,
                color: Colors.deepPurple,
              ),
              const SizedBox(height: 15),
              const Text(
                "Cadastre seu salão",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                "Preencha os dados para começar",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildStep(_step >= 0),
                  const SizedBox(width: 10),
                  _buildStep(_step >= 1),
                  const SizedBox(width: 10),
                  _buildStep(_step >= 2),
                ],
              ),
              const SizedBox(height: 30),
              Container(
                width: MediaQuery.of(context).size.width * 0.88,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel("Nome do Estabelecimento"),
                    _inputTextField(
                      controller: _salonNameController,
                      hint: "Nome do salão",
                    ),
                    const SizedBox(height: 20),
                    _buildLabel("Nome completo"),
                    _inputIconTextField(
                      controller: _nameController,
                      icon: Icons.person_outline,
                      enabled: false,
                    ),
                    const SizedBox(height: 20),
                    _buildLabel("E-mail"),
                    _inputIconTextField(
                      controller: _emailController,
                      icon: Icons.email_outlined,
                      enabled: false,
                    ),
                    const SizedBox(height: 20),
                    _buildLabel("Telefone"),
                    _inputIconTextField(
                      controller: _phoneController,
                      icon: Icons.phone_outlined,
                      enabled: false,
                    ),
                    const SizedBox(height: 30),
                    GestureDetector(
                      onTap: _saving ? null : _onPressButton,
                      child: Container(
                        height: 58,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF1FB6FF),
                              Color(0xFF5A3DB8),
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                        ),
                        child: Center(
                          child: _saving
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "Prosseguir",
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Icon(
                                      Icons.arrow_right_alt,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStep(bool active) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 40,
      height: 6,
      decoration: BoxDecoration(
        color: active ? Colors.deepPurple : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 15,
          color: Colors.black87,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _inputTextField({
    required TextEditingController controller,
    required String hint,
  }) {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.shade500),
        ),
      ),
    );
  }

  Widget _inputIconTextField({
    required TextEditingController controller,
    required IconData icon,
    bool enabled = true,
  }) {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              enabled: enabled,
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
