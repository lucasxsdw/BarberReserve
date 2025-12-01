// lib/screens/salon_register_screen.dart
import 'package:flutter/material.dart';
import 'package:barber_reserve/models/user_model.dart';
import 'package:barber_reserve/services/auth_service.dart';
import 'package:barber_reserve/services/api_service.dart';
import 'package:barber_reserve/screens/services_screen.dart';

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

  @override
void initState() {
  super.initState();

  _salonNameController = TextEditingController();

  _nameController = TextEditingController(
    text: widget.user.name,
  );

  _emailController = TextEditingController(
    text: widget.user.email,
  );

  _phoneController = TextEditingController(
    text: widget.user.phone ?? '',
  );
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Você precisa estar logado.')),
        );
        return;
      }

      final res = await ApiService.post(
        "salao",
        {"nome": nomeSalao},
        token: token,
      );

      if (!mounted) return;

      if (res["statusCode"] == 200 || res["statusCode"] == 201) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const ServicesScreen(),
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F7),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cadastre seu salão',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Preencha os dados para começar',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Nome do Salão',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _salonNameController,
                    decoration: const InputDecoration(
                      hintText: 'Nome do salão',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Nome completo',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _nameController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'E-mail',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _emailController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Telefone',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _phoneController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: ElevatedButton(
                onPressed: _saving ? null : _onNext,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                ),
                child: Text(_saving ? 'Salvando...' : 'Prosseguir →'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
