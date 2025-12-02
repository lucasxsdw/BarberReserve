import 'package:flutter/material.dart';
import 'package:barber_reserve/services/auth_service.dart';
import 'package:barber_reserve/services/api_service.dart';
import 'package:barber_reserve/screens/services_screen.dart';

class ProfessionalsRegisterScreen extends StatefulWidget {
  final int salaoId;      // id do salão no backend
  final String salaoNome; // nome do salão para exibir na UI

  const ProfessionalsRegisterScreen({
    super.key,
    required this.salaoId,
    required this.salaoNome,
  });

  @override
  State<ProfessionalsRegisterScreen> createState() =>
      _ProfessionalsRegisterScreenState();
}

class _ProfessionalsRegisterScreenState
    extends State<ProfessionalsRegisterScreen> {
  final List<TextEditingController> _controllers = [];
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    // 👉 agora começa com APENAS 1 profissional
    _addProfessionalField();
  }

  void _addProfessionalField() {
    setState(() {
      _controllers.add(TextEditingController());
    });
  }

  void _removeProfessionalField(int index) {
    if (_controllers.length == 1) {
      // garante que sempre tenha pelo menos 1 campo
      _controllers[index].clear();
      setState(() {});
      return;
    }

    setState(() {
      _controllers.removeAt(index);
    });
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _onSubmit() async {
    if (_saving) return;

    // Validação: pelo menos um nome preenchido
    final nomes = _controllers
        .map((c) => c.text.trim())
        .where((nome) => nome.isNotEmpty)
        .toList();

    if (nomes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Informe ao menos um profissional.'),
        ),
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

      // Chama a API para cada profissional
      for (final nome in nomes) {
        final body = {
          // ajuste os nomes dos campos conforme sua API
          "nome": nome,
          "salao": widget.salaoId,
        };

        final res = await ApiService.post(
          "profissional", // ajuste o endpoint se for diferente
          body,
          token: token,
        );

        final status = res["statusCode"] as int?;
        if (status == null || (status != 200 && status != 201)) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Erro ao salvar profissional "$nome": ${res["body"].toString()}',
              ),
            ),
          );
          return; // para no primeiro erro
        }
      }

      if (!mounted) return;

      // Sucesso: vai pra tela de serviços (ou outra que você quiser)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const ServicesScreen(),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar profissionais: $e')),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const currentStep = 2; // etapa 2/3 (profissional) – só visual
    return Scaffold(
      backgroundColor: const Color(0xFFF1F1F1),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 24),
              const Icon(
                Icons.all_inbox_outlined,
                size: 72,
                color: Colors.deepPurple,
              ),
              const SizedBox(height: 12),
              const Text(
                "Cadastre o profissional",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Você está cadastrando profissionais para o seu salão",
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 12),

              // Steps (3 barrinhas, a do meio ativa)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildStep(currentStep >= 1),
                  const SizedBox(width: 8),
                  _buildStep(currentStep >= 2),
                  const SizedBox(width: 8),
                  _buildStep(currentStep >= 3),
                ],
              ),

              const SizedBox(height: 24),

              // "Nome do salão" mais explicativo
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                margin: const EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.deepPurple.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.storefront_outlined,
                      color: Colors.deepPurple,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Salão selecionado",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            widget.salaoNome,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Cards de profissionais
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    for (int i = 0; i < _controllers.length; i++)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _ProfessionalCard(
                          index: i + 1,
                          controller: _controllers[i],
                          canRemove: _controllers.length > 1,
                          onRemove: () => _removeProfessionalField(i),
                        ),
                      ),
                  ],
                ),
              ),

              // Botão "Adicionar outro profissional" (mantive, caso queira mais de 1)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: GestureDetector(
                  onTap: _saving ? null : _addProfessionalField,
                  child: Container(
                    height: 52,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade400),
                      color: Colors.grey.shade100,
                    ),
                    child: const Center(
                      child: Text(
                        "+ Adicionar outro profissional",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Botões Voltar / Prosseguir
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _saving
                            ? null
                            : () {
                                Navigator.pop(context);
                              },
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(48),
                          side: BorderSide(color: Colors.grey.shade400),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          "← Voltar",
                          style: TextStyle(color: Colors.black87),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: _saving ? null : _onSubmit,
                        child: Container(
                          height: 48,
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
                                : const Text(
                                    "Prosseguir →",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStep(bool active) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: active ? Colors.deepPurple : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}

class _ProfessionalCard extends StatelessWidget {
  final int index;
  final TextEditingController controller;
  final bool canRemove;
  final VoidCallback onRemove;

  const _ProfessionalCard({
    required this.index,
    required this.controller,
    required this.canRemove,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // linha com numero + botão remover
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: Colors.deepPurple.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    "$index",
                    style: const TextStyle(
                      color: Colors.deepPurple,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              if (canRemove)
                IconButton(
                  onPressed: onRemove,
                  icon: const Icon(
                    Icons.delete_outline,
                    size: 20,
                    color: Colors.redAccent,
                  ),
                  tooltip: "Remover profissional",
                ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            "Nome do Profissional",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            height: 52,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade300),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                const Icon(Icons.person_outline, color: Colors.grey),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Nome completo",
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
