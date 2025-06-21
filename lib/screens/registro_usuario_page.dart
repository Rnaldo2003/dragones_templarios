import 'package:flutter/material.dart';
import '../models/usuarios.dart';
import '../services/usuario_service.dart';
import '../widgets/custom_app_bar.dart';

class RegistroUsuarioPage extends StatefulWidget {
  const RegistroUsuarioPage({super.key});

  @override
  State<RegistroUsuarioPage> createState() => _RegistroUsuarioPageState();
}

class _RegistroUsuarioPageState extends State<RegistroUsuarioPage> {
  final _formKey = GlobalKey<FormState>();
  final UsuarioService _service = UsuarioService();

  final TextEditingController nombreCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passCtrl = TextEditingController();
  String rol = 'estudiante';

  bool _guardando = false;

  Future<void> _registrar() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _guardando = true);

      final usuario = Usuario(
        nombre: nombreCtrl.text,
        email: emailCtrl.text,
        rol: rol,
      );

      final response = await _service.crearUsuario(usuario, passCtrl.text);

      setState(() => _guardando = false);

      if (response) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuario creado exitosamente')),
        );
        Navigator.pop(context, usuario);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al crear usuario')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Registrar Usuario', showBack: true),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0D1A36), Color(0xFF8B0000)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Crear nuevo usuario',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: nombreCtrl,
                        decoration: const InputDecoration(labelText: 'Nombre'),
                        validator: (value) => value == null || value.isEmpty ? 'Ingrese el nombre' : null,
                      ),
                      TextFormField(
                        controller: emailCtrl,
                        decoration: const InputDecoration(labelText: 'Email'),
                        validator: (value) => value == null || value.isEmpty ? 'Ingrese el email' : null,
                      ),
                      TextFormField(
                        controller: passCtrl,
                        decoration: const InputDecoration(labelText: 'Contraseña'),
                        obscureText: true,
                        validator: (value) => value == null || value.isEmpty ? 'Ingrese la contraseña' : null,
                      ),
                      DropdownButtonFormField<String>(
                        value: rol,
                        items: const [
                          DropdownMenuItem(value: 'estudiante', child: Text('Estudiante')),
                          DropdownMenuItem(value: 'admin', child: Text('Administrador')),
                        ],
                        onChanged: (value) => setState(() => rol = value ?? 'estudiante'),
                        decoration: const InputDecoration(labelText: 'Rol'),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _guardando ? null : _registrar,
                        child: _guardando
                            ? const CircularProgressIndicator()
                            : const Text('Registrar', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}