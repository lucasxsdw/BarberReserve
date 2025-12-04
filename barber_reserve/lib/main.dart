import 'package:barber_reserve/modules/salao/screens/salon_list.dart';
import 'package:flutter/material.dart';
// import 'package:barber_reserve/screens/professionals_register.dart';
//import 'package:barber_reserve/screens/services_screen.dart';
//import 'package:barber_reserve/screens/service_register.dart';
import 'package:barber_reserve/modules/auth/screens/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen( // apenas isso é necessário
      ),
    );
  }
}
