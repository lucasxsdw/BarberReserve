// lib/modules/servico/screens/service_admin_screen.dart
import 'package:flutter/material.dart';

import 'package:barber_reserve/modules/salao/screens/salao_admin_screen.dart';
import 'package:barber_reserve/modules/salao/widgets/admin_bottom_nav.dart';

import 'package:barber_reserve/modules/servico/models/service_model.dart';
import 'package:barber_reserve/modules/servico/services/service_service.dart';

import 'package:barber_reserve/modules/profissional/models/newprofessional_model.dart';
import 'package:barber_reserve/modules/profissional/services/professional_service.dart';

class ServiceAdminScreen extends StatefulWidget {
  const ServiceAdminScreen({super.key});

  @override
  State<ServiceAdminScreen> createState() => _ServiceAdminScreenState();
}

class _ServiceAdminScreenState extends State<ServiceAdminScreen> {
  bool _loading = true;
  bool _saving = false;
  List<ServiceModel> _servicos = [];

  @override
  void initState() {
    super.initState();
    _loadServicos();
  }

  Future<void> _loadServicos() async {
    setState(() => _loading = true);
    try {
      final lista = await ServiceService.getServicos();
      setState(() => _servicos = lista);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar serviços: $e')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _openServiceForm({ServiceModel? servico}) async {
    final bool isEdit = servico != null;

    // valores iniciais dos campos
    String initialNome = '';
    String initialDescricao = '';
    String initialPreco = '';
    String initialDuracao = '30';

    if (isEdit) {
      initialNome = servico!.titulo;
      initialDescricao = servico.descricao ?? '';
      initialPreco = servico.preco.toStringAsFixed(2);
      initialDuracao = servico.duracaoMinutos.toString();
    }

    // 1) Carrega TODOS os profissionais do salão
    List<ProfessionalModel> profissionais = [];
    try {
      profissionais = await ProfessionalService.getProfessionals();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar profissionais: $e')),
        );
      }
    }

    // 2) IDs selecionados (começa com os que já fazem o serviço, se for edição)
    // 2) IDs selecionados (começa com os que já fazem o serviço, se for edição)
    final Set<int> selectedProfIds = {
      if (isEdit)
        ...servico!.profissionais
            .map((p) => p.id)      // pega o id de cada profissional do serviço
            .whereType<int>(),     // remove null e garante tipo int
    };


    final nomeController = TextEditingController(text: initialNome);
    final descricaoController = TextEditingController(text: initialDescricao);
    final precoController = TextEditingController(text: initialPreco);
    final duracaoController = TextEditingController(text: initialDuracao);

    final formKey = GlobalKey<FormState>();

    await showDialog(
      context: context,
      barrierDismissible: !_saving,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            Future<void> salvar() async {
              if (!formKey.currentState!.validate()) return;

              if (selectedProfIds.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Selecione ao menos um profissional.'),
                  ),
                );
                return;
              }

              final nome = nomeController.text.trim();
              final descricao = descricaoController.text.trim();
              final preco = precoController.text.trim();
              final duracao = int.tryParse(duracaoController.text) ?? 30;

              setStateDialog(() => _saving = true);
              try {
                if (isEdit) {
                  await ServiceService.updateService(
                    id: servico!.id,
                    nome: nome,
                    descricao: descricao,
                    preco: preco,
                    duracaoMinutos: duracao,
                    profissionaisIds: selectedProfIds.toList(),
                  );
                } else {
                  await ServiceService.createService(
                    nome: nome,
                    descricao: descricao,
                    preco: preco,
                    duracaoMinutos: duracao,
                    profissionaisIds: selectedProfIds.toList(),
                  );
                }

                if (mounted) {
                  Navigator.pop(context); // fecha o dialog
                  await _loadServicos();  // recarrega lista
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erro ao salvar serviço: $e')),
                  );
                }
              } finally {
                setStateDialog(() => _saving = false);
              }
            }

            return AlertDialog(
              title: Text(isEdit ? 'Editar Serviço' : 'Novo Serviço'),
              content: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: nomeController,
                        decoration: const InputDecoration(
                          labelText: 'Nome do serviço',
                        ),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return 'Informe o nome';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: descricaoController,
                        decoration: const InputDecoration(
                          labelText: 'Descrição',
                        ),
                        maxLines: 2,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: precoController,
                        decoration: const InputDecoration(
                          labelText: 'Preço (R\$)',
                        ),
                        keyboardType:
                            const TextInputType.numberWithOptions(decimal: true),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return 'Informe o preço';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: duracaoController,
                        decoration: const InputDecoration(
                          labelText: 'Duração (minutos)',
                        ),
                        keyboardType: TextInputType.number,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return 'Informe a duração';
                          }
                          if (int.tryParse(v) == null) {
                            return 'Duração inválida';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Profissionais que realizam esse serviço',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (profissionais.isEmpty)
                        const Text(
                          'Nenhum profissional cadastrado.',
                          style: TextStyle(color: Colors.grey),
                        )
                      else
                        Column(
                          children: profissionais.map((p) {
                            final id = p.id;
                            final selected =
                                id != null && selectedProfIds.contains(id);
                            return CheckboxListTile(
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                              title: Text(p.name),
                              value: selected,
                              onChanged: id == null
                                  ? null
                                  : (value) {
                                      setStateDialog(() {
                                        if (value == true) {
                                          selectedProfIds.add(id);
                                        } else {
                                          selectedProfIds.remove(id);
                                        }
                                      });
                                    },
                            );
                          }).toList(),
                        ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: _saving ? null : () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: _saving ? null : salvar,
                  child: Text(isEdit ? 'Salvar' : 'Criar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _deleteServico(ServiceModel servico) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Excluir serviço'),
        content: Text('Deseja realmente excluir "${servico.titulo}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await ServiceService.deleteService(servico.id);
      await _loadServicos();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao excluir serviço: $e')),
      );
    }
  }

  void _openServiceDetails(ServiceModel servico) {
  showDialog(
    context: context,
    builder: (_) {
      final profissionaisTexto = servico.profissionais.isEmpty
          ? 'Nenhum profissional associado'
          : servico.profissionais.map((p) => p.nome).join(', ');

      return AlertDialog(
        title: const Text('Detalhes do Serviço'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _detailRow('Nome do serviço', servico.titulo),
            const SizedBox(height: 8),
            _detailRow('Descrição', servico.descricao?.trim().isEmpty == true
                ? '-'
                : servico.descricao!),
            const SizedBox(height: 8),
            _detailRow(
              'Preço',
              'R\$ ${servico.preco.toStringAsFixed(2)}',
            ),
            const SizedBox(height: 8),
            _detailRow(
              'Duração',
              '${servico.duracaoMinutos} min',
            ),
            const SizedBox(height: 12),
            const Text(
              'Profissionais que realizam esse serviço',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              profissionaisTexto,
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      );
    },
  );
}

Widget _detailRow(String label, String value) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 13,
          color: Colors.grey[700],
        ),
      ),
      const SizedBox(height: 2),
      Text(
        value,
        style: const TextStyle(
          fontSize: 14,
        ),
      ),
    ],
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),

      bottomNavigationBar: AdminBottomNav(
        currentTab: AdminTab.painel,
        onPainelTap: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const SalaoAdminScreen()),
            (route) => false,
          );
        },
        onPerfilTap: () {
          // TODO: ir pra tela de perfil quando existir
        },
      ),

      body: SafeArea(
        child: Column(
          children: [
            // topo com título + botão Novo
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Text(
                    "Serviços",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton.icon(
                    onPressed: () => _openServiceForm(),
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text("Novo"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2F80ED),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: _loading
                    ? const Center(child: CircularProgressIndicator())
                    : _servicos.isEmpty
                        ? _buildEmptyState()
                        : _buildList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.cut,
            size: 48,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 12),
          Text(
            "Nenhum serviço cadastrado",
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => _openServiceForm(),
            icon: const Icon(Icons.add, size: 18),
            label: const Text("Adicionar Serviço"),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2F80ED),
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: ListView.separated(
        itemCount: _servicos.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final s = _servicos[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: const Color(0xFFE8F4FF),
              child: const Icon(Icons.cut, color: Color(0xFF2EA7FF)),
            ),
            title: Text(s.titulo),
            subtitle: Text(
              'R\$ ${s.preco.toStringAsFixed(2)} • ${s.duracaoMinutos} min',
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.visibility_outlined, size: 20),
                  tooltip: 'Ver detalhes',
                  onPressed: () => _openServiceDetails(s),
                ),
                IconButton(
                  icon: const Icon(Icons.edit, size: 20),
                  tooltip: 'Editar',
                  onPressed: () => _openServiceForm(servico: s),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                  tooltip: 'Excluir',
                  onPressed: () => _deleteServico(s),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
