// lib/modules/agendamento/screens/appointment_admin_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:barber_reserve/modules/salao/screens/salao_admin_screen.dart';
import 'package:barber_reserve/modules/salao/widgets/admin_bottom_nav.dart';
import 'package:barber_reserve/modules/profissional/screens/professional_profile_screen.dart';

import 'package:barber_reserve/modules/agendamento/models/appointment_model.dart';
import 'package:barber_reserve/modules/agendamento/services/appointment_service.dart';

class AppointmentAdminScreen extends StatefulWidget {
  const AppointmentAdminScreen({super.key});

  @override
  State<AppointmentAdminScreen> createState() =>
      _AppointmentAdminScreenState();
}

class _AppointmentAdminScreenState extends State<AppointmentAdminScreen> {
  bool _loading = true;
  List<Appointment> _agendamentos = [];

  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }

  Future<void> _loadAppointments() async {
    setState(() => _loading = true);
    try {
      final lista = await AppointmentService.getAppointments();
      setState(() => _agendamentos = lista);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar agendamentos: $e')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _deleteAppointment(Appointment a) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Cancelar agendamento'),
        content: const Text(
            'Deseja realmente cancelar este agendamento? Essa ação não pode ser desfeita.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Não'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Sim, cancelar'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await AppointmentService.deleteAppointment(a.id!);
      await _loadAppointments();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao cancelar agendamento: $e')),
      );
    }
  }

  void _openAppointmentDetails(Appointment a) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    final hora = '${a.horaInicio} - ${a.horaFim}';

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Detalhes do agendamento'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _detailRow('Serviço', a.servico.titulo),
            const SizedBox(height: 8),
            _detailRow('Profissional', a.profissional.nome),
            const SizedBox(height: 8),
            _detailRow('Data', dateFormat.format(a.data)),
            const SizedBox(height: 8),
            _detailRow('Horário', hora),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
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
          style: const TextStyle(fontSize: 14),
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
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const UserProfileScreen(),
            ),
          );
        },
      ),

      body: SafeArea(
        child: Column(
          children: [
            // topo com título + botão Novo (depois podemos ligar em um form)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Text(
                    "Agendamentos",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton.icon(
                    onPressed: () {
                      // TODO: criar agendamento manual pelo painel
                      // pode abrir um dialog ou navegar pra outra tela
                    },
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
                    : _agendamentos.isEmpty
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
            Icons.calendar_today_outlined,
            size: 48,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 12),
          Text(
            "Nenhum agendamento encontrado",
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              // TODO: mesmo comportamento do botão Novo lá de cima
            },
            icon: const Icon(Icons.add, size: 18),
            label: const Text("Adicionar Agendamento"),
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
    final dateFormat = DateFormat('dd/MM/yyyy');

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: ListView.separated(
        itemCount: _agendamentos.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final a = _agendamentos[index];
          final dataStr = dateFormat.format(a.data);
          final horaStr = '${a.horaInicio} - ${a.horaFim}';

          return ListTile(
            leading: CircleAvatar(
              backgroundColor: const Color(0xFFE8F4FF),
              child: const Icon(Icons.calendar_today_outlined,
                  color: Color(0xFF2EA7FF)),
            ),
            title: Text(a.servico.titulo),
            subtitle: Text(
              '${a.profissional.nome} • $dataStr • $horaStr',
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon:
                      const Icon(Icons.visibility_outlined, size: 20),
                  tooltip: 'Ver detalhes',
                  onPressed: () => _openAppointmentDetails(a),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.delete,
                    size: 20,
                    color: Colors.red,
                  ),
                  tooltip: 'Cancelar',
                  onPressed: () => _deleteAppointment(a),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
