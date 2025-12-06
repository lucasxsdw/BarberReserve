import 'package:flutter/material.dart';
import 'package:barber_reserve/modules/salao/screens/salon_list.dart';
import '../../agendamento/screens/appointment_screen.dart';
import '../../usuario/screens/profile_screen.dart';

class TelaInicial extends StatefulWidget {
  const TelaInicial({super.key});

  @override
  State<TelaInicial> createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> {
  int _index = 0;

  final pages = [
    const AppointmentsScreen(),
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
