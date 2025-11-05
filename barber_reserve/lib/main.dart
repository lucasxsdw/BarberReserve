import 'package:barber_reserve/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'screens/register_screen.dart'; // ajuste o nome conforme o arquivo real

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RegisterScreen(), // 👈 muda de LoginScreen() para RegisterScreen()
    );
  }
}
