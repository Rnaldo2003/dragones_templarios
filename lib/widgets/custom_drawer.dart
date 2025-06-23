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
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0D1A36), Color(0xFFB71C1C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Drawer(
        backgroundColor: Colors.transparent,
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: Colors.transparent),
              accountName: Text(
                usuario.nombre,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
              ),
              accountEmail: Text(
                usuario.rol.toUpperCase(),
                style: const TextStyle(color: Colors.white70, fontSize: 15),
              ),
              currentAccountPicture: CircleAvatar(
                radius: 38,
                backgroundColor: Colors.white,
                child: usuario.imagen != null && usuario.imagen.startsWith('http')
                    ? CircleAvatar(
                        radius: 35,
                        backgroundImage: NetworkImage(usuario.imagen),
                      )
                    : const CircleAvatar(
                        radius: 35,
                        backgroundImage: AssetImage('assets/default.png'),
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Text(
                '¡Bienvenido, ${usuario.nombre.split(' ').first}!',
                style: const TextStyle(color: Colors.white, fontSize: 16, fontStyle: FontStyle.italic),
              ),
            ),
            const Divider(color: Colors.white24, thickness: 1, indent: 16, endIndent: 16),
            ListTile(
              leading: const Icon(Icons.people, color: Colors.white),
              title: const Text('Estudiantes', style: TextStyle(color: Colors.white)),
              onTap: onEstudiantes,
            ),
            ListTile(
              leading: const Icon(Icons.person, color: Colors.white),
              title: const Text('Usuarios', style: TextStyle(color: Colors.white)),
              onTap: onUsuarios,
            ),
            ListTile(
              leading: const Icon(Icons.add, color: Colors.white),
              title: const Text('Agregar Estudiante', style: TextStyle(color: Colors.white)),
              onTap: onFormularioEstudiantes,
            ),
            ListTile(
              leading: const Icon(Icons.person_add, color: Colors.white),
              title: const Text('Agregar Usuario', style: TextStyle(color: Colors.white)),
              onTap: onFormularioUsuarios,
            ),
            const Spacer(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.redAccent),
              title: const Text('Cerrar sesión', style: TextStyle(color: Colors.redAccent)),
              onTap: onLogout,
            ),
          ],
        ),
      ),
    );
  }
}