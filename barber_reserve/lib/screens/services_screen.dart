import 'package:flutter/material.dart';
import '../models/service_model.dart';

class ServicosScreen extends StatefulWidget {
  const ServicosScreen({super.key});

  @override
  State<ServicosScreen> createState() => _ServicosScreenState();
}

class _ServicosScreenState extends State<ServicosScreen> {
  final List<ServiceModel> services = [
    ServiceModel(id: 1, title: 'Cabelo', description: 'Corte moderno e estiloso', durationMinutes: 30, price: 30),
    ServiceModel(id: 2, title: 'Sobrancelha', description: 'Design de sobrancelhas', durationMinutes: 25, price: 15),
  ];

  void _openSchedule(ServiceModel s) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Agendar: ${s.title}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(leading: const Icon(Icons.content_cut), title: Text(s.title), subtitle: Text(s.description)),
            const SizedBox(height: 8),
            ElevatedButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Escolher Data e Horário')),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
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
              child: const Text('Nossos Serviços', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            ),

            const SizedBox(height: 12),
            Expanded(
              child: ListView.separated(
                itemCount: services.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, i) {
                  final s = services[i];
                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(children: [const Icon(Icons.content_cut), const SizedBox(width: 8), Text(s.title, style: const TextStyle(fontWeight: FontWeight.bold))]),
                              Text('R\$ ${s.price.toStringAsFixed(0)}'),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(s.description),
                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton(onPressed: () => _openSchedule(s), child: const Text('Agendar Serviço')),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
