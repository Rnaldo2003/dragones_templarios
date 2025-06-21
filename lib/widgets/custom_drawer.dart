import 'package:flutter/material.dart';
import '../models/usuarios.dart';

class CustomDrawer extends StatelessWidget {
  final Usuario usuario;
  final VoidCallback onLogout;
  final VoidCallback onEstudiantes;
  final VoidCallback onUsuarios;
  final VoidCallback onFormularioEstudiantes;
  final VoidCallback onFormularioUsuarios;

  const CustomDrawer({
    super.key,
    required this.usuario,
    required this.onLogout,
    required this.onEstudiantes,
    required this.onUsuarios,
    required this.onFormularioEstudiantes,
    required this.onFormularioUsuarios,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(usuario.nombre),
            accountEmail: Text(usuario.rol),
            currentAccountPicture: const CircleAvatar(
              backgroundImage: AssetImage('assets/default.png'), // O usa NetworkImage si tienes URL
            ),
          ),
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text('Estudiantes'),
            onTap: onEstudiantes,
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Usuarios'),
            onTap: onUsuarios,
          ),
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text('Agregar Estudiante'),
            onTap: onFormularioEstudiantes,
          ),
          ListTile(
            leading: const Icon(Icons.person_add),
            title: const Text('Agregar Usuario'),
            onTap: onFormularioUsuarios,
          ),
          const Spacer(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Cerrar sesión'),
            onTap: onLogout,
          ),
        ],
      ),
    );
  }
}