import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/appointment_model.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  final api = ApiService();
  List<AppointmentModel> history = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final list = await api.fetchAppointments();
    setState(() => history = list);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF6DD3FF), Color(0xFF6C4BFF)]),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('João Cliente', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 6),
                  Text('joao@email.com', style: TextStyle(color: Colors.white70)),
                ],
              ),
            ),

            const SizedBox(height: 12),
            Row(children: [
              Expanded(child: _infoCard('1', 'Serviços realizados')),
              const SizedBox(width: 8),
              Expanded(child: _infoCard('R\$ 25', 'Total gasto')),
            ]),

            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Informações Pessoais', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  ListTile(leading: const Icon(Icons.email), title: const Text('E-mail'), subtitle: const Text('joao@email.com')),
                  ListTile(leading: const Icon(Icons.phone), title: const Text('Telefone'), subtitle: const Text('(11) 99999-9999')),
                ],
              ),
            ),

            const SizedBox(height: 12),
            Align(alignment: Alignment.centerLeft, child: Text('Histórico de agendamentos', style: TextStyle(fontWeight: FontWeight.bold))),
            const SizedBox(height: 8),
            Column(
              children: history.map((a) => Card(
                child: ListTile(
                  title: Text(a.serviceTitle),
                  subtitle: Text('${a.dateTime.day}/${a.dateTime.month}/${a.dateTime.year} às ${a.dateTime.hour}:${a.dateTime.minute.toString().padLeft(2,'0')}'),
                  trailing: Text('R\$ ${a.price.toStringAsFixed(0)}'),
                ),
              )).toList(),
            ),

            const SizedBox(height: 12),
            TextButton(onPressed: () {}, child: const Text('Sair da conta', style: TextStyle(color: Colors.red))),
          ],
        ),
      ),
    );
  }

  Widget _infoCard(String v, String label) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
    child: Column(children: [Text(v, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)), const SizedBox(height: 6), Text(label, style: const TextStyle(color: Colors.black54))]),
  );
}
