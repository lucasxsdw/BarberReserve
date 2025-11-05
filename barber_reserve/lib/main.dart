import 'package:barber_reserve/screens/login_screen.dart';
import 'package:barber_reserve/screens/register_screen.dart';
import 'package:barber_reserve/screens/services_screen.dart';
import 'package:flutter/material.dart';
import 'screens/services_screen.dart'; void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ServicosScreen(), 
    );
  }
}
