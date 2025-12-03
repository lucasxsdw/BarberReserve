import 'package:flutter/material.dart';
import 'package:barber_reserve/modules/profissional/models/newprofessional_model.dart';
import 'package:barber_reserve/modules/profissional/services/professional_service.dart';
import 'package:barber_reserve/modules/servico/services/service_service.dart';
import 'package:barber_reserve/modules/servico/screens/services_screen.dart';

class ServiceRegisterScreen extends StatefulWidget {
  const ServiceRegisterScreen({super.key});

  @override
  State<ServiceRegisterScreen> createState() => _ServiceRegisterScreenState();
}

class _ServiceRegisterScreenState extends State<ServiceRegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  bool _loadingProfessionals = true;
  bool _saving = false;
  String? _error;

  List<ProfessionalModel> _professionals = [];

  // lista dinâmica de cards de serviço
  final List<_ServiceFormData> _serviceForms = [
    _ServiceFormData(),
  ];

  @override
  void initState() {
    super.initState();
    _loadProfessionals();
  }

  @override
  void dispose() {
    for (final f in _serviceForms) {
      f.dispose();
    }
    super.dispose();
  }

  Future<void> _loadProfessionals() async {
    try {
      final list = await ProfessionalService.getProfessionals();
      setState(() {
        _professionals = list;
        _loadingProfessionals = false;
      });
    } on ApiException catch (e) {
      setState(() {
        _error = 'Erro ${e.statusCode}: ${e.message}';
        _loadingProfessionals = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Erro ao carregar profissionais';
        _loadingProfessionals = false;
      });
    }
  }

  void _addServiceCard() {
    setState(() {
      _serviceForms.add(_ServiceFormData());
    });
  }

  void _removeServiceCard(int index) {
    if (_serviceForms.length == 1) return; // deixa pelo menos 1
    setState(() {
      _serviceForms[index].dispose();
      _serviceForms.removeAt(index);
    });
  }

  /// Envia TODOS os cards para o backend.
  /// Depois navega para a ServicesScreen.
  Future<void> _submitAll() async {
    if (!_formKey.currentState!.validate()) return;

    // Checa se pelo menos um card tem nome preenchido
    final temAlgumPreenchido = _serviceForms.any(
      (f) => f.nomeController.text.trim().isNotEmpty,
    );
    if (!temAlgumPreenchido) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha pelo menos um corte/serviço.')),
      );
      return;
    }

    setState(() {
      _saving = true;
      _error = null;
    });

    try {
      for (final form in _serviceForms) {
        final nome = form.nomeController.text.trim();
        if (nome.isEmpty) {
          // pula cards vazios
          continue;
        }

        final descricao = form.descricaoController.text.trim();
        final precoStr = form.precoController.text.trim();
        final preco = precoStr.replaceAll(',', '.');
        final duracao =
            int.tryParse(form.duracaoController.text.trim()) ?? 30;

        if (precoStr.isEmpty) {
          continue; // por segurança, mas o validator já cobriu
        }
        if (form.selectedProfessionalIds.isEmpty) {
          continue; // idem
        }

        await ServiceService.createService(
          nome: nome,
          descricao: descricao.isEmpty ? '' : descricao,
          preco: preco,
          duracaoMinutos: duracao,
          profissionaisIds: form.selectedProfessionalIds.toList(),
        );
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Serviços cadastrados com sucesso!')),
      );

      // depois de salvar, levar para a tela de serviços
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ServicesScreen()),
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _error = 'Erro ${e.statusCode}: ${e.message}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar serviços: ${e.message}')),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar serviços: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  Widget _buildStep(bool active) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: 24,
      height: 6,
      decoration: BoxDecoration(
        color: active ? const Color(0xFF5A3DB8) : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF1F1F1),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFF1F1F1),
        foregroundColor: Colors.black87,
        title: const Text(
          'Cadastrar Corte/Serviço',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (_error != null) ...[
                      Text(
                        _error!,
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 8),
                    ],

                    // Ícone topo
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: const Color(0xFF5A3DB8).withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.widgets_outlined,
                        size: 36,
                        color: Color(0xFF5A3DB8),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Cadastre o Corte/Serviço",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Preencha os dados para começar",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Steps
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildStep(true),
                        const SizedBox(width: 8),
                        _buildStep(true),
                        const SizedBox(width: 8),
                        _buildStep(true),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // FORM
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // Vários cards de serviço
                          ..._serviceForms.asMap().entries.map(
                            (entry) {
                              final index = entry.key;
                              final form = entry.value;
                              return Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 16.0),
                                child: _buildServiceCard(
                                  context,
                                  theme,
                                  form,
                                  index,
                                ),
                              );
                            },
                          ),

                          const SizedBox(height: 8),

                          // Botão + Adicionar outro corte
                          GestureDetector(
                            onTap: _saving ? null : _addServiceCard,
                            child: Container(
                              height: 70,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                  color: Colors.grey.shade400,
                                  style: BorderStyle.solid,
                                ),
                                color: Colors.grey.shade100,
                              ),
                              child: const Center(
                                child: Text(
                                  '+ Adicionar outro corte',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Botões Voltar / Concluir
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed:
                                      _saving ? null : () => Navigator.pop(context),
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                  child: const Text(
                                    "Voltar",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: SizedBox(
                                  height: 52,
                                  child: ElevatedButton(
                                    onPressed:
                                        _saving ? null : _submitAll,
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(14),
                                      ),
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                    ),
                                    child: Ink(
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color(0xFF1FB6FF),
                                            Color(0xFF5A3DB8),
                                          ],
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(14),
                                      ),
                                      child: Center(
                                        child: _saving
                                            ? const SizedBox(
                                                height: 22,
                                                width: 22,
                                                child:
                                                    CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  color: Colors.white,
                                                ),
                                              )
                                            : const Text(
                                                "Concluir",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight:
                                                      FontWeight.w600,
                                                ),
                                              ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildServiceCard(
    BuildContext context,
    ThemeData theme,
    _ServiceFormData form,
    int index,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header com número + botão remover
          Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor:
                    const Color(0xFF5A3DB8).withOpacity(0.1),
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(
                    color: Color(0xFF5A3DB8),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                "Corte/Serviço",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              if (_serviceForms.length > 1)
                IconButton(
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.redAccent,
                    size: 20,
                  ),
                  onPressed: () => _removeServiceCard(index),
                ),
            ],
          ),
          const SizedBox(height: 16),

          // Nome
          const Text(
            "Nome do Corte/Serviço",
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: form.nomeController,
            decoration: InputDecoration(
              hintText: 'Ex: Corte Degradê',
              prefixIcon: const Icon(Icons.cut_outlined),
              filled: true,
              fillColor: Colors.grey.shade50,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                  color: Colors.grey.shade300,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                  color: Colors.grey.shade300,
                ),
              ),
            ),
            validator: (value) {
              // só exige se o usuário começou a preencher algo no card
              final algumCampoPreenchido =
                  form.nomeController.text.trim().isNotEmpty ||
                      form.precoController.text.trim().isNotEmpty ||
                      form.descricaoController.text.trim().isNotEmpty;
              if (!algumCampoPreenchido) return null;

              if (value == null || value.trim().isEmpty) {
                return 'Informe o nome do serviço';
              }
              return null;
            },
          ),

          const SizedBox(height: 20),

          // Descrição
          const Text(
            "Descrição (opcional)",
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: form.descricaoController,
            maxLines: 2,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey.shade50,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                  color: Colors.grey.shade300,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                  color: Colors.grey.shade300,
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Preço + duração
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Preço (R\$)",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: form.precoController,
                      keyboardType:
                          const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: InputDecoration(
                        prefixText: 'R\$ ',
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                          ),
                        ),
                      ),
                      validator: (value) {
                        final algumCampoPreenchido =
                            form.nomeController.text.trim().isNotEmpty ||
                                form.precoController.text
                                    .trim()
                                    .isNotEmpty ||
                                form.descricaoController.text
                                    .trim()
                                    .isNotEmpty;
                        if (!algumCampoPreenchido) return null;

                        if (value == null || value.trim().isEmpty) {
                          return 'Informe o preço';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Duração (minutos)",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: form.duracaoController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                          ),
                        ),
                      ),
                      validator: (value) {
                        final algumCampoPreenchido =
                            form.nomeController.text.trim().isNotEmpty ||
                                form.precoController.text
                                    .trim()
                                    .isNotEmpty ||
                                form.descricaoController.text
                                    .trim()
                                    .isNotEmpty;
                        if (!algumCampoPreenchido) return null;

                        final v = int.tryParse(value ?? '');
                        if (v == null || v <= 0) {
                          return 'Duração inválida';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Profissionais
          Row(
            children: [
              const Icon(
                Icons.person_outline,
                size: 18,
              ),
              const SizedBox(width: 6),
              Text(
                'Profissionais que realizam esse serviço',
                style: theme.textTheme.bodySmall!.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          if (_loadingProfessionals)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(),
              ),
            )
          else if (_professionals.isEmpty)
            const Text(
              'Nenhum profissional cadastrado para este salão.',
            )
          else
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF6FAFF),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: _professionals
                    .map(
                      (p) => CheckboxListTile(
                        value: form.selectedProfessionalIds
                            .contains(p.id),
                        onChanged: (checked) {
                          setState(() {
                            if (checked == true) {
                              form.selectedProfessionalIds.add(p.id!);
                            } else {
                              form.selectedProfessionalIds.remove(p.id);
                            }
                          });
                        },
                        title: Text(p.name ?? ''),
                        dense: true,
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 0),
                      ),
                    )
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }
}

/// Representa um card de serviço na tela (controllers + profissionais selecionados)
class _ServiceFormData {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController descricaoController = TextEditingController();
  final TextEditingController precoController = TextEditingController();
  final TextEditingController duracaoController =
      TextEditingController(text: '30');

  final Set<int> selectedProfessionalIds = {};

  void dispose() {
    nomeController.dispose();
    descricaoController.dispose();
    precoController.dispose();
    duracaoController.dispose();
  }
}
