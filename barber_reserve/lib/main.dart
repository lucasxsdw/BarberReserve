import 'package:flutter/material.dart';
import 'package:barber_reserve/screens/professionals_register.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProfessionalsRegisterScreen(
        salaoId: 1,         // VALOR FICTÍCIO PARA TESTE
        salaoNome: "Barbearia Teste",
      ),
    );
  }
}
