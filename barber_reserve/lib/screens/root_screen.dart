import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'home_screen.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  bool loggedIn = false;

  void _onLogin() {
    setState(() => loggedIn = true);
  }

  @override
  Widget build(BuildContext context) {
    if (!loggedIn) {
      return LoginScreen(onLogin: _onLogin);
    }

    return const TelaInicial();
  }
}
