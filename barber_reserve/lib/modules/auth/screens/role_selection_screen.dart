import 'package:flutter/material.dart';
import 'package:barber_reserve/modules/usuario/services/user_service.dart';
import 'package:barber_reserve/modules/salao/screens/salon_register_screen.dart';
import 'package:barber_reserve/modules/servico/screens/services_screen.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  bool _loading = false;

  Future<void> _selectRole(String role) async {
    if (_loading) return;
    setState(() => _loading = true);

    try {
      // Atualiza tipo_perfil no backend (CLIENTE ou SALAO)
      final user = await UserService.updateTipoPerfil(role);

      if (!mounted) return;

      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao atualizar tipo de perfil.')),
        );
        return;
      }

      if (role == 'CLIENTE') {
        // 👉 CLIENTE -> vai pra tela de serviços
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const ServicesScreen(),
          ),
        );
      } else {
        // 👉 SALAO -> vai pra tela de cadastro de salão, passando o USER
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => SalonRegisterScreen(user: user),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao selecionar perfil: $e')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F1F1),
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.content_cut,
                    color: Color(0xFF5A3DB8),
                    size: 70,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "DegraDart",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF5A3DB8),
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    "Sua barbearia na palma da mão",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    "Quem é você?",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 25),
                  Container(
                    padding: const EdgeInsets.all(20),
                    width: MediaQuery.of(context).size.width * 0.85,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        _buildGradientButton(
                          text: "CLIENTE",
                          enabled: !_loading,
                          onTap: () => _selectRole('CLIENTE'),
                        ),
                        const SizedBox(height: 20),
                        _buildGradientButton(
                          text: "PROFISSIONAL/ SALÃO",
                          enabled: !_loading,
                          onTap: () => _selectRole('SALAO'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (_loading)
              Container(
                color: Colors.black.withOpacity(0.1),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildGradientButton({
    required String text,
    required VoidCallback onTap,
    required bool enabled,
  }) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        height: 65,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: enabled
              ? const LinearGradient(
                  colors: [
                    Color(0xFF1FB6FF),
                    Color(0xFF5A3DB8),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                )
              : null,
          color: enabled ? null : Colors.grey[400],
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
