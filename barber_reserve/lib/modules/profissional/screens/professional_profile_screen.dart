import 'package:flutter/material.dart';

import 'package:barber_reserve/modules/usuario/models/user_model.dart';
import 'package:barber_reserve/modules/usuario/services/user_service.dart';

// bottom nav reutilizado
import 'package:barber_reserve/modules/salao/widgets/admin_bottom_nav.dart';
// tela de painel do cliente (mude aqui se for outra)
import 'package:barber_reserve/modules/servico/screens/services_screen.dart';
import 'package:barber_reserve/modules/salao/screens/salao_admin_screen.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  UserModel? _user;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    setState(() => _loading = true);

    final user = await UserService.getMe();

    setState(() {
      _user = user;
      _loading = false;
    });
  }

  

  Future<void> _openEditDialog() async {
    final nomeCtrl = TextEditingController(text: _user?.name ?? "");
    final emailCtrl = TextEditingController(text: _user?.email ?? "");
    final phoneCtrl = TextEditingController(text: _user?.phone ?? "");

    bool saving = false;

    await showDialog(
      context: context,
      barrierDismissible: !saving,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Text(
                "Editar informações",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nomeCtrl,
                    decoration: const InputDecoration(
                      labelText: "Nome",
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: emailCtrl,
                    decoration: const InputDecoration(
                      labelText: "Email",
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: phoneCtrl,
                    decoration: const InputDecoration(
                      labelText: "Telefone",
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: saving ? null : () => Navigator.pop(context),
                  child: const Text("Cancelar"),
                ),
                ElevatedButton(
                  onPressed: saving
                      ? null
                      : () async {
                          setStateDialog(() => saving = true);

                          try {
                            final updated = await UserService.updateUser(
                              firstName: nomeCtrl.text.trim(),
                              email: emailCtrl.text.trim(),
                              telefone: phoneCtrl.text.trim(),
                            );

                            if (updated != null) {
                              if (mounted) {
                                Navigator.pop(context);
                                await _loadUser();
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      "Erro ao atualizar informações"),
                                ),
                              );
                            }
                          } finally {
                            setStateDialog(() => saving = false);
                          }
                        },
                  child: saving
                      ? const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text("Salvar"),
                ),
              ],
            );
          },
        );
      },
    );
  }

 

  Widget _infoTile(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.grey.shade700,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 15),
        ),
      ],
    );
  }

 
  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_user == null) {
      return const Scaffold(
        body: Center(child: Text("Erro ao carregar usuário")),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),

      // ====== BOTTOM NAV: PAINEL / PERFIL ======
      bottomNavigationBar: AdminBottomNav(
        currentTab: AdminTab.perfil, // estamos na aba Perfil
        onPainelTap: () {
          // vai para o "painel" do cliente (serviços para agendar)
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const SalaoAdminScreen()),
          );
        },
        onPerfilTap: () {
          // já está na tela de perfil -> não faz nada
        },
      ),
      // =========================================

      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // HEADER COM NOME + EMAIL
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4A90E2), Color(0xFF6A5AE0)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _user!.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _user!.email,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // CARD DE INFORMAÇÕES
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // título + botão editar
                  Row(
                    children: [
                      const Text(
                        "Informações pessoais",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: _openEditDialog,
                        icon: const Icon(Icons.edit_outlined),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  _infoTile("Nome", _user!.name),
                  const SizedBox(height: 12),

                  _infoTile("Email", _user!.email),
                  const SizedBox(height: 12),

                  _infoTile("Telefone", _user!.phone ?? "Não informado"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
