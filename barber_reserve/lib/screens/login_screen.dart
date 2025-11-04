import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback? onLogin;
  const LoginScreen({super.key, this.onLogin});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  bool isRegister = false;
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
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
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 24),
                SizedBox(
                  height: 88,
                  child: Column(
                    children: const [
                      Icon(Icons.content_cut, size: 48, color: Colors.deepPurple),
                      SizedBox(height: 8),
                      Text('DegraDart', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),

                const SizedBox(height: 8),
                Text('Sua barbearia na palma da mão', style: TextStyle(color: Colors.grey[700])),

                const SizedBox(height: 18),
                Container(
                  width: w * 0.95,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0,4))],
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: !isRegister ? Colors.deepPurple : Colors.grey[200],
                                foregroundColor: !isRegister ? Colors.white : Colors.black,
                              ),
                              onPressed: () => setState(() => isRegister = false),
                              child: const Text(
                                'Entrar',
                                style: TextStyle(
                                    color: Colors.white
                                ),
                                ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: isRegister ? Colors.deepPurple : Colors.grey[200],
                                foregroundColor: isRegister ? Colors.white : Colors.black,
                              ),
                              onPressed: () => setState(() => isRegister = true),
                              child: const Text('Cadastrar'),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      if (isRegister)
                        TextField(decoration: const InputDecoration(prefixIcon: Icon(Icons.person), hintText: 'Nome completo')),

                      const SizedBox(height: 8),

                      TextField(controller: _email, decoration: const InputDecoration(prefixIcon: Icon(Icons.email), hintText: 'E-mail')),
                      const SizedBox(height: 8),
                      TextField(controller: _password, obscureText: true, decoration: const InputDecoration(prefixIcon: Icon(Icons.lock), hintText: 'Senha')),

                      if (isRegister) ...[
                        const SizedBox(height: 8),
                        TextField(obscureText: true, decoration: const InputDecoration(prefixIcon: Icon(Icons.lock_outline), hintText: 'Confirmar senha')),
                      ],

                      const SizedBox(height: 16),

                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          backgroundColor: Colors.deepPurple,
                        ),
                        onPressed: () {
                          widget.onLogin?.call();
                        },
                        child: const SizedBox(width: double.infinity, child: Center(child: Text('Entrar'))),
                      ),

                      TextButton(onPressed: () {}, child: const Text('Esqueci minha senha')),
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
