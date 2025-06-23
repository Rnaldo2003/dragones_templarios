import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import '../models/usuarios.dart';
import '../services/usuario_service.dart';
import '../widgets/custom_app_bar.dart';
import 'home_page.dart';
import 'lista_estudiantes_page.dart'; // Ajusta el nombre/ruta si es diferente

File? _imagenFile;
Uint8List? _webImageBytes;
String? urlImagen;

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

      // Subir imagen si hay
      String imagenUrl = 'assets/default.png';
      if ((_imagenFile != null) || (_webImageBytes != null)) {
        final url = await _subirImagen();
        if (url != null) imagenUrl = url;
      }

      final usuario = Usuario(
        nombre: nombreCtrl.text,
        email: emailCtrl.text,
        rol: rol,
        imagen: imagenUrl, // <-- Nuevo campo
      );

      final response = await _service.crearUsuario(usuario, passCtrl.text);

      setState(() => _guardando = false);

      if (response) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuario creado exitosamente')),
        );
        Navigator.pop(context, true); // <-- Esto regresa a la pantalla anterior con AppBar y Drawer
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al crear usuario')),
        );
      }
    }
  }

  Future<void> _seleccionarImagen() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, maxWidth: 300, maxHeight: 300);
    if (pickedFile != null) {
      if (kIsWeb) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _webImageBytes = bytes;
          _imagenFile = null;
        });
      } else {
        setState(() {
          _imagenFile = File(pickedFile.path);
          _webImageBytes = null;
        });
      }
    }
  }

  Future<String?> _subirImagen() async {
    if (kIsWeb && _webImageBytes != null) {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://localhost:3000/upload'),
      );
      request.files.add(http.MultipartFile.fromBytes(
        'imagen',
        _webImageBytes!,
        filename: 'web_user.png',
      ));
      var response = await request.send();
      if (response.statusCode == 200) {
        final respStr = await response.stream.bytesToString();
        final url = jsonDecode(respStr)['url'];
        return url;
      }
      return null;
    } else if (_imagenFile != null) {
      // Reutiliza el método de tu service si lo tienes, o pon aquí el código de subida
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://localhost:3000/upload'),
      );
      request.files.add(await http.MultipartFile.fromPath('imagen', _imagenFile!.path));
      var response = await request.send();
      if (response.statusCode == 200) {
        final respStr = await response.stream.bytesToString();
        final url = jsonDecode(respStr)['url'];
        return url;
      }
      return null;
    }
    return null;
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
                      Center(
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.grey[200],
                              backgroundImage: _webImageBytes != null
                                  ? MemoryImage(_webImageBytes!)
                                  : _imagenFile != null
                                      ? FileImage(_imagenFile!)
                                      : (urlImagen != null && urlImagen!.startsWith('http'))
                                          ? NetworkImage(urlImagen!)
                                          : const AssetImage('assets/default.png') as ImageProvider,
                            ),
                            Material(
                              color: Colors.white,
                              shape: const CircleBorder(),
                              child: InkWell(
                                customBorder: const CircleBorder(),
                                onTap: _seleccionarImagen,
                                child: const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Icon(Icons.camera_alt, color: Colors.black87, size: 22),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
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
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[800], // Fondo rojo oscuro
                          foregroundColor: Colors.black,    // Letras negras
                          minimumSize: const Size.fromHeight(48),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: _guardando ? null : _registrar,
                        child: _guardando
                            ? const CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                              )
                            : const Text('Registrar', style: TextStyle(fontWeight: FontWeight.bold)),
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