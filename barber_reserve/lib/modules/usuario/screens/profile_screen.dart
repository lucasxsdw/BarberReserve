import 'package:flutter/material.dart';
import 'package:barber_reserve/core/auth/auth_service.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  late Future<Map<String, dynamic>> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = AuthService.getProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Perfil',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _profileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('Erro ao carregar perfil'));
          }

          final data = snapshot.data!;
          final statusCode = data["statusCode"] as int? ?? 0;
          final body = data["body"] ?? {};

          if (statusCode != 200 || body == null) {
            return const Center(child: Text('Erro ao carregar perfil'));
          }

          // backend pode devolver first_name OU nome (garantimos os dois)
          final String nome =
              body["first_name"] ?? body["nome"] ?? "Usuário";
          final String email = body["email"] ?? "";
          final String telefone = body["telefone"] ?? "";

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Topo com gradiente e perfil
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF4A00E0), Color(0xFF8E2DE2)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 30,
                        backgroundImage:
                            AssetImage('assets/images/profile.jpg'),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            nome,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            email,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Estatísticas (mock)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _infoCard('1', 'Serviços realizados'),
                    _infoCard('R\$ 25', 'Total gasto'),
                  ],
                ),
                const SizedBox(height: 16),

                // Informações pessoais
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.person_outline,
                              color: Colors.black54),
                          const SizedBox(width: 8),
                          const Text(
                            'Informações Pessoais',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Spacer(),
                          OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 0,
                              ),
                              side:
                                  const BorderSide(color: Colors.black54),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              // TODO: abrir modal/tela pra editar nome/telefone
                              // e depois enviar PATCH para /api/usuario/me/
                            },
                            icon: const Icon(Icons.edit_outlined, size: 16),
                            label: const Text(
                              'Editar',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Row(
                        children: [
                          Icon(Icons.email_outlined,
                              color: Colors.black54, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'E-mail',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 28, top: 4),
                        child: Text(email),
                      ),
                      const SizedBox(height: 12),
                      const Row(
                        children: [
                          Icon(Icons.phone_outlined,
                              color: Colors.black54, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Telefone',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 28, top: 4),
                        child: Text(
                          telefone.isEmpty
                              ? '(sem telefone cadastrado)'
                              : telefone,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Histórico de agendamentos (mock)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.history, color: Colors.black54),
                          SizedBox(width: 8),
                          Text(
                            'Histórico de agendamentos',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _agendamentoItem(
                        nomeServico: 'Sobrancelha',
                        preco: 'R\$ 15',
                        data: '20/12/2024 às 14:00',
                        profissional: 'Ana Silva',
                        avatar: null,
                      ),
                      const SizedBox(height: 8),
                      _agendamentoItem(
                        nomeServico: 'Corte feminino',
                        preco: 'R\$ 25',
                        data: '20/12/2024 às 14:00',
                        profissional: 'Carlos Santos',
                        avatar: 'assets/images/barber.jpg',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Sair da conta
                TextButton.icon(
                  onPressed: () async {
                    await AuthService.logout();
                    
                    // Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
                  },
                  icon: const Icon(Icons.logout, color: Colors.red),
                  label: const Text(
                    'Sair da conta',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Widgets auxiliares
  Widget _infoCard(String value, String label) {
    return Expanded(
      child: Container(
        height: 80,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              style: const TextStyle(
                color: Color(0xFF4A00E0),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _agendamentoItem({
    required String nomeServico,
    required String preco,
    required String data,
    required String profissional,
    String? avatar,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black26),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: Colors.grey[300],
            backgroundImage:
                avatar != null ? AssetImage(avatar) : null,
            child: avatar == null
                ? const Text(
                    'A',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nomeServico,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$data\n$profissional',
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 12,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          Text(
            preco,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
