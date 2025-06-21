import 'package:flutter/material.dart';
import '../models/usuarios.dart';
import '../widgets/custom_drawer.dart';
import 'lista_estudiantes_page.dart';
import 'lista_usuarios_page.dart';
import 'formulario_estudiante.dart';
import 'registro_usuario_page.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  final Usuario usuario;
  const HomePage({super.key, required this.usuario});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Widget _currentScreen = const ListaEstudiantesPage();

  void _goToEstudiantes() {
    setState(() {
      _currentScreen = const ListaEstudiantesPage();
    });
    Navigator.pop(context);
  }

  void _goToUsuarios() async {
    if (widget.usuario.rol != 'admin') {
      final pass = await showDialog<String>(
        context: context,
        builder: (context) {
          String input = '';
          return AlertDialog(
            title: const Text('Contraseña de administrador'),
            content: TextField(
              obscureText: true,
              onChanged: (value) => input = value,
              decoration: const InputDecoration(labelText: 'Contraseña'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, null),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, input),
                child: const Text('Aceptar'),
              ),
            ],
          );
        },
      );
      if (pass != 'admin123') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Contraseña incorrecta')),
        );
        return;
      }
    }
    setState(() {
      _currentScreen = const ListaUsuariosPage();
    });
    Navigator.pop(context);
  }

  void _goToFormularioEstudiantes() {
    setState(() {
      _currentScreen = const FormularioEstudiantePage();
    });
    Navigator.pop(context);
  }

  void _goToFormularioUsuarios() {
    setState(() {
      _currentScreen = const RegistroUsuarioPage();
    });
    Navigator.pop(context);
  }

  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(
        usuario: widget.usuario,
        onLogout: _logout,
        onEstudiantes: _goToEstudiantes,
        onUsuarios: _goToUsuarios,
        onFormularioEstudiantes: _goToFormularioEstudiantes,
        onFormularioUsuarios: _goToFormularioUsuarios,
      ),
      appBar: AppBar(title: const Text('App Taekwondo')),
      body: _currentScreen,
    );
  }
}
