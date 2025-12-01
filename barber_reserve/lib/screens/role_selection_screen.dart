import 'package:flutter/material.dart';
import 'package:barber_reserve/services/user_service.dart';
import 'package:barber_reserve/screens/salon_register_screen.dart';
import 'package:barber_reserve/screens/services_screen.dart';

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
      // 👉 CLIENTE -> vai pra tela de serviços (quando você fizer)
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
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F7),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 48),
            Text(
              'Quem é você?',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Escolha como quer usar o app',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  _RoleButton(
                    label: 'CLIENTE',
                    onTap: _loading ? null : () => _selectRole('CLIENTE'),
                  ),
                  const SizedBox(height: 16),
                  _RoleButton(
                    label: 'PROFISSIONAL / SALÃO',
                    onTap: _loading ? null : () => _selectRole('SALAO'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            if (_loading) const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

class _RoleButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;

  const _RoleButton({
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final disabled = onTap == null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: disabled
              ? null
              : const LinearGradient(
                  colors: [
                    Color(0xFF4C6FFF),
                    Color(0xFF7F5CFF),
                  ],
                ),
          color: disabled ? Colors.grey[400] : null,
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
