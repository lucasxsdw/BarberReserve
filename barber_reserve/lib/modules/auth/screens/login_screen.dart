import 'package:flutter/material.dart';

import 'package:barber_reserve/modules/auth/screens/register_screen.dart';
import 'package:barber_reserve/core/api/api_service.dart';
import 'package:barber_reserve/core/auth/auth_service.dart';

// telas pós-login
import 'package:barber_reserve/modules/salao/screens/home_screen.dart';           // TelaInicial (cliente)
import 'package:barber_reserve/modules/salao/screens/salao_admin_screen.dart';   // Painel do salão

class LoginScreen extends StatefulWidget {
  final VoidCallback? onLogin;
  const LoginScreen({super.key, this.onLogin});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  bool isLoading = false;

  final _email = TextEditingController();
  final _password = TextEditingController();

  final api = ApiService();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  // ==========================================
  // FUNÇÃO DE LOGIN
  // ==========================================
  Future<void> _doLogin() async {
    final email = _email.text.trim();
    final password = _password.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showMessage("Preencha todos os campos.");
      return;
    }

    setState(() => isLoading = true);

    try {
      // 1) faz login e salva o token (AuthService já escreve no storage)
      final response = await AuthService.login(
        email: email,
        password: password,
      );

      final statusCode = response["statusCode"] as int;
      final body = response["body"];

      if (statusCode != 200 || body["access"] == null) {
        _showMessage(body["detail"]?.toString() ?? "Credenciais inválidas.");
        return;
      }

      _showMessage("Login realizado com sucesso!");

      // 2) busca o perfil do usuário pra descobrir o tipo_perfil
      final profileRes = await AuthService.getProfile();
      final profileStatus = profileRes["statusCode"] as int;
      final profileBody = profileRes["body"];

      print('PROFILE RES -> $profileRes');
      print('PROFILE BODY -> $profileBody');

      if (profileStatus != 200 || profileBody == null) {
        _showMessage("Não foi possível carregar o perfil do usuário.");
        return;
      }

      // aqui assumo que a API devolve algo como:
      // { "id": 1, "email": "...", "tipo_perfil": "salao" }
      final tipoPerfil = profileBody["tipo_perfil"]?.toString();

      // 3) decide a tela de acordo com o tipo_perfil
      if (tipoPerfil == "salao") {
        // 🔵 usuário SALÃO → painel administrativo
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const SalaoAdminScreen(),
          ),
        );
      } else if (tipoPerfil == "cliente") {
        // 🟢 usuário CLIENTE → tela inicial do cliente
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const TelaInicial(),
          ),
        );
      } else {
        _showMessage("Perfil desconhecido: $tipoPerfil");
      }
    } catch (e) {
      _showMessage("Erro ao conectar ao servidor.");
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  // ==========================================
  // SNACKBAR
  // ==========================================
  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

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

                // LOGO
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

                      // BOTÕES ENTRAR / CADASTRAR
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFD9D9D9),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Row(
                          children: [
                            // BOTÃO ENTRAR
                            Expanded(
                              child: GestureDetector(
                                child: Container(
                                  margin: const EdgeInsets.only(left: 6),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
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

                            // BOTÃO CADASTRAR
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const RegisterScreen(),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
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

                      // EMAIL FIELD
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'E-mail',
                          style: TextStyle(
                            color: Colors.grey[800],
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      TextField(
                        controller: _email,
                        decoration: InputDecoration(
                          hintText: 'seu@email.com',
                          filled: true,
                          fillColor: const Color(0xFFD9D9D9),
                          prefixIcon: const Icon(Icons.email_outlined,
                              color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // SENHA FIELD
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Senha',
                          style: TextStyle(
                            color: Colors.grey[800],
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      TextField(
                        controller: _password,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: '********',
                          filled: true,
                          fillColor: const Color(0xFFD9D9D9),
                          prefixIcon: const Icon(Icons.lock_outline,
                              color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // BOTÃO LOGIN
                      Container(
                        width: double.infinity,
                        height: 48,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF00B4DB), Color(0xFF7B61FF)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: isLoading ? null : _doLogin,
                          child: isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(
                                  'Entrar',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),

                      const SizedBox(height: 12),
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
}
