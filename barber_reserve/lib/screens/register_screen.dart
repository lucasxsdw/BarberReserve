import 'package:barber_reserve/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:barber_reserve/services/api_service.dart';

class RegisterScreen extends StatefulWidget {
  
  const RegisterScreen({super.key});
  

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}


class _RegisterScreenState extends State<RegisterScreen> {

  int selectedTab = 1;  
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

    final body = response["body"]; 

    if (response["statusCode"] == 200 && body["id"] != null) {
      _showMessage("Conta criada com sucesso!");

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    } else {
      _showMessage("Erro ao criar conta: ${body.toString()}");
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
                        'Bem-vindo!',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Entre na sua conta ou crie uma nova',
                        style: TextStyle(fontSize: 12, color: Colors.black87),
                      ),
                      const SizedBox(height: 16),


                  //BOTÕES ENTRAR / CADASTRAR
                  Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFD9D9D9),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Row(
                        children: [
                          // ENTRAR
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() => selectedTab = 0);
                                Navigator.pop(context); // volta para login
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                margin: const EdgeInsets.only(left: 6),
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(
                                  color: selectedTab == 0 ? Colors.white : Colors.transparent,
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                alignment: Alignment.center,
                                child: const Text(
                                  'Entrar',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // CADASTRAR
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() => selectedTab = 1);
                                // já estou na tela de Cadastro, então não navego para lugar nenhum
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                margin: const EdgeInsets.only(top: 3, bottom: 3, right: 6),

                                decoration: BoxDecoration(
                                  color: selectedTab == 1 ? const Color.fromARGB(255, 255, 255, 255) : Colors.transparent,
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                alignment: Alignment.center,
                                child: const Text(
                                  'Cadastrar',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                      

                      const SizedBox(height: 24),

                      _label("Nome completo"),
                      _inputField(controller: _name, icon: Icons.person_outline, hintText: "....",),

                      const SizedBox(height: 12),

                      _label("E-mail"),
                      _inputField(controller: _email, icon: Icons.email_outlined, hintText: "seu@email.com"),

                      const SizedBox(height: 12),

                      _label("Telefone"),
                      _inputField(controller: _phone, icon: Icons.phone_outlined, hintText: "(00) 00000-0000",),

                      const SizedBox(height: 12),

                      _label("Senha"),
                      _inputField(controller: _password, icon: Icons.lock_outline, isPassword: true, hintText: "**********",),

                      const SizedBox(height: 12),

                      _label("Confirmar senha"),
                      _inputField(controller: _confirmPassword, icon: Icons.lock_outline, isPassword: true, hintText: "**********",),

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
    String? hintText,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        hintText: hintText,
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
