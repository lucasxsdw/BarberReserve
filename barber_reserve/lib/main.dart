import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/login_screen.dart';
import 'screens/root_screen.dart';

void main() {
  runApp(const BarberReserveApp());
}

class BarberReserveApp extends StatelessWidget {
  const BarberReserveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Barber Reserve',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        textTheme: GoogleFonts.interTextTheme(),
      ),
      home: const RootScreen(),
      routes: {
        '/login': (_) => const LoginScreen(),
      },
    );
  }
}
