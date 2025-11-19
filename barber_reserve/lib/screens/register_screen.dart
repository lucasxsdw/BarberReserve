import 'package:flutter/material.dart';
import 'package:barber_reserve/services/api_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();

  bool isLoading = false;

  final ApiService api = ApiService();

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  // ========================================================
  // FUNÇÃO DE REGISTRO
  // ========================================================
  Future<void> _doRegister() async {
    final name = _name.text.trim();
    final email = _email.text.trim();
    final phone = _phone.text.trim();
    final password = _password.text.trim();
    final confirm = _confirmPassword.text.trim();

    if (name.isEmpty || email.isEmpty || phone.isEmpty || password.isEmpty || confirm.isEmpty) {
      _showMessage("Preencha todos os campos.");
      return;
    }

    if (password != confirm) {
      _showMessage("As senhas não coincidem.");
      return;
    }

    setState(() => isLoading = true);

    try {
      final response = await api.register(name, email, password, phone);

      if (response["id"] != null) {
        _showMessage("Conta criada com sucesso!");
        Navigator.pop(context);
      } else {
        _showMessage("Erro ao criar conta: ${response.toString()}");
      }
    } catch (e) {
      _showMessage("Erro ao conectar ao servidor.");
    }

    setState(() => isLoading = false);
  }

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  // ========================================================
  // UI
  // ========================================================
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Column(
              children: [
                const SizedBox(height: 24),
                Column(
                  children: const [
                    Icon(Icons.content_cut, size: 64, color: Color(0xFF7B61FF)),
                    SizedBox(height: 8),
                    Text(
                      'DegraDart',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF7B61FF),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Sua barbearia na palma da mão',
                  style: TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 24),

                // CARD
                Container(
                  width: w * 0.95,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Criar conta',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 24),

                      _label("Nome completo"),
                      _inputField(controller: _name, icon: Icons.person_outline),

                      const SizedBox(height: 12),

                      _label("E-mail"),
                      _inputField(controller: _email, icon: Icons.email_outlined),

                      const SizedBox(height: 12),

                      _label("Telefone"),
                      _inputField(controller: _phone, icon: Icons.phone_outlined),

                      const SizedBox(height: 12),

                      _label("Senha"),
                      _inputField(controller: _password, icon: Icons.lock_outline, isPassword: true),

                      const SizedBox(height: 12),

                      _label("Confirmar senha"),
                      _inputField(controller: _confirmPassword, icon: Icons.lock_outline, isPassword: true),

                      const SizedBox(height: 24),

                      // BOTÃO
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF7B61FF),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: isLoading ? null : _doRegister,
                          child: isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text(
                                  'Cadastrar',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ========================================================
  // Widgets auxiliares
  // ========================================================
  Widget _label(String text) => Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      );

  Widget _inputField({
    required TextEditingController controller,
    required IconData icon,
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFD9D9D9),
        prefixIcon: Icon(icon, color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
