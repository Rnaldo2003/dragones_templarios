import 'package:flutter/material.dart';
import 'screens/login_page.dart';
import 'screens/home_page.dart';
import 'screens/registro_usuario_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dragones Templarios',
      theme: ThemeData(
        primaryColor: const Color(0xFF8B0000),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color(0xFF8B0000),
          secondary: const Color(0xFF0D1A36),
        ),
        fontFamily: 'Roboto',
      ),
      home: const LoginPage(),
      routes: {
        '/home': (context) => const HomePage(),
        '/registro': (context) => const RegistroUsuarioPage(),
      },
    );
  }
}
