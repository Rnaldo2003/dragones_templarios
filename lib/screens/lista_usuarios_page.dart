import 'package:flutter/material.dart';
import '../models/usuarios.dart';
import '../services/usuario_service.dart';
import 'editar_usuario_page.dart';
import 'registro_usuario_page.dart';

class ListaUsuariosPage extends StatefulWidget {
  const ListaUsuariosPage({super.key});

  @override
  State<ListaUsuariosPage> createState() => _ListaUsuariosPageState();
}

class _ListaUsuariosPageState extends State<ListaUsuariosPage> {
  final UsuarioService _service = UsuarioService();
  late Future<List<Usuario>> _futureUsuarios;

  @override
  void initState() {
    super.initState();
    _futureUsuarios = _service.getUsuarios();
  }

  Future<void> _eliminarUsuario(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar usuario'),
        content: const Text('¿Estás seguro de eliminar este usuario?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await _service.eliminarUsuario(id);
      setState(() {
        _futureUsuarios = _service.getUsuarios();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0D1A36), Color(0xFF23395d)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Usuarios'),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: FutureBuilder<List<Usuario>>(
          future: _futureUsuarios,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No hay usuarios'));
            }
            final usuarios = snapshot.data!;
            return ListView.separated(
              itemCount: usuarios.length,
              separatorBuilder: (context, index) => const Divider(height: 1, thickness: 1, indent: 72, endIndent: 16),
              itemBuilder: (context, index) {
                final usuario = usuarios[index];
                return ListTile(
                  leading: usuario.imagen != null && usuario.imagen.startsWith('http')
                      ? CircleAvatar(
                          backgroundImage: NetworkImage(usuario.imagen),
                          radius: 28,
                        )
                      : const CircleAvatar(
                          backgroundImage: AssetImage('assets/default.png'),
                          radius: 28,
                        ),
                  title: Text(
                    usuario.nombre,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                  subtitle: Text(usuario.email, style: const TextStyle(fontSize: 15)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: usuario.rol == 'admin' ? Colors.blue[100] : Colors.red[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          usuario.rol.toUpperCase(),
                          style: TextStyle(
                            color: usuario.rol == 'admin' ? Colors.blue[900] : Colors.red[900],
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        tooltip: 'Eliminar usuario',
                        onPressed: () => _eliminarUsuario(usuario.id!),
                      ),
                    ],
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  onTap: () async {
                    final actualizado = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditarUsuarioPage(usuario: usuario),
                      ),
                    );
                    if (actualizado == true) {
                      setState(() {
                        _futureUsuarios = _service.getUsuarios();
                      });
                    }
                  },
                );
              },
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const RegistroUsuarioPage()),
            );
          },
          child: const Icon(Icons.add),
          backgroundColor: Colors.blue,
        ),
      ),
    );
  }
}