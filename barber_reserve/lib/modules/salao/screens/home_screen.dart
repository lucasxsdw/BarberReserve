import 'package:flutter/material.dart';
import 'package:barber_reserve/modules/salao/screens/salon_list.dart';
import '../../usuario/screens/profile_screen.dart';

class TelaInicial extends StatefulWidget {
  const TelaInicial({super.key});

  @override
  State<TelaInicial> createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> {
  int _index = 0;

  final pages = [
    const AgendaTab(),
    const HomeSalonsScreen(),
    const PerfilScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: pages[_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.event_note),
            label: 'Agenda',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage("assets/images/location.png"),
            ),
            label: 'Salões',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}


class AgendaTab extends StatelessWidget {
  const AgendaTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                  Text('Minha Agenda', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 6),
                  Text('Gerencie seus agendamentos', style: TextStyle(color: Colors.white70)),
                ],
              ),
            ),

            const SizedBox(height: 12),


            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
              ),
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  Column(
                    children: [
                      Icon(Icons.calendar_month_outlined, size: 48, color: Colors.grey[400]),
                      const SizedBox(height: 12),
                      const Text('Nenhum agendamento para este dia', style: TextStyle(color: Colors.black54)),
                      const SizedBox(height: 12),
                      ElevatedButton(onPressed: () {}, child: const Text('Agende horário')),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dateChip(String label, String day, {bool selected = false}) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: selected ? const Color(0xFF3AB0FF) : Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: selected ? [BoxShadow(color: Colors.black12, blurRadius: 6)] : null,
            ),
            child: Column(
              children: [
                Text(label, style: TextStyle(color: selected ? Colors.white : Colors.black54)),
                Text(day, style: TextStyle(color: selected ? Colors.white : Colors.black, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}