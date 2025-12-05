import 'package:barber_reserve/modules/salao/screens/salon_list.dart';
import 'package:flutter/material.dart';
import 'package:barber_reserve/modules/auth/screens/login_screen.dart';
import 'package:barber_reserve/modules/salao/screens/salao_admin_screen.dart';
import 'package:barber_reserve/modules/servico/screens/services_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      initialRoute: '/login',

      routes: {
        '/login': (context) => const LoginScreen(),

        // rota que o SALÃO usa
        '/painel-salao': (context) => const SalaoAdminScreen(),

        // rota que o CLIENTE usa (troca pela tela que vc quiser)
        '/cliente-home': (context) => const HomeSalonsScreen(),
      },
    );
  }
}
