import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/usuarios.dart';
import '../services/usuario_service.dart';

class EditarUsuarioPage extends StatefulWidget {
  final Usuario usuario;
  const EditarUsuarioPage({super.key, required this.usuario});

  @override
  State<EditarUsuarioPage> createState() => _EditarUsuarioPageState();
}

class _EditarUsuarioPageState extends State<EditarUsuarioPage> {
  late TextEditingController nombreCtrl;
  late TextEditingController emailCtrl;
  String rol = 'estudiante';

  File? _imagenFile;
  Uint8List? _webImageBytes;
  String? urlImagen;
  bool _guardando = false;

  final _formKey = GlobalKey<FormState>();
  final UsuarioService _service = UsuarioService();

  @override
  void initState() {
    super.initState();
    nombreCtrl = TextEditingController(text: widget.usuario.nombre);
    emailCtrl = TextEditingController(text: widget.usuario.email);
    rol = widget.usuario.rol;
    urlImagen = widget.usuario.imagen;
  }

  @override
  void dispose() {
    nombreCtrl.dispose();
    emailCtrl.dispose();
    super.dispose();
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

  Future<void> _guardar() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _guardando = true);

      String imagenUrl = urlImagen ?? 'assets/default.png';
      if ((_imagenFile != null) || (_webImageBytes != null)) {
        final url = await _subirImagen();
        if (url != null) imagenUrl = url;
      }

      final usuarioEditado = Usuario(
        id: widget.usuario.id,
        nombre: nombreCtrl.text,
        email: emailCtrl.text,
        rol: rol,
        imagen: imagenUrl,
      );

      final ok = await _service.editarUsuario(usuarioEditado);

      setState(() => _guardando = false);

      if (ok) {
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al guardar cambios')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Usuario'),
        backgroundColor: const Color(0xFF0D1A36),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Center(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 45,
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
                          padding: EdgeInsets.all(10),
                          child: Icon(Icons.camera_alt, color: Colors.black87, size: 28),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: nombreCtrl,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v == null || v.isEmpty ? 'Ingrese el nombre' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: emailCtrl,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v == null || v.isEmpty ? 'Ingrese el email' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: rol,
                decoration: const InputDecoration(
                  labelText: 'Rol',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'admin', child: Text('Administrador')),
                  DropdownMenuItem(value: 'estudiante', child: Text('Estudiante')),
                ],
                onChanged: (v) => setState(() => rol = v ?? 'estudiante'),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: Text(_guardando ? 'Guardando...' : 'Guardar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0D1A36),
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(48),
                ),
                onPressed: _guardando ? null : _guardar,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
