import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import '../models/estudiantes.dart';
import '../widgets/custom_app_bar.dart';
import '../services/estudiante_service.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class FormularioEstudiantePage extends StatefulWidget {
  final Estudiante? estudiante; // null si se va a crear

  const FormularioEstudiantePage({super.key, this.estudiante});

  @override
  State<FormularioEstudiantePage> createState() => _FormularioEstudiantePageState();
}

class _FormularioEstudiantePageState extends State<FormularioEstudiantePage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nombreCtrl;
  late TextEditingController telefonoCtrl;
  late TextEditingController emergenciaCtrl;
  late TextEditingController edadCtrl;
  late TextEditingController imagenCtrl;

  String tipoSangre = 'A+';
  String rango = 'Blanco';
  String tipoPersona = 'Niño';
  String jornada = 'Mañana';

  File? _imagenFile;
  String? urlImagen;
  bool subiendoImagen = false;
  Uint8List? _webImageBytes;

  final List<String> tiposSangre = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];
  final List<String> rangosCinturon = [
    'Blanco', 'Blanco-Amarillo', 'Amarillo', 'Amarillo-Verde', 'Verde',
    'Verde-Azul', 'Azul', 'Azul-Rojo', 'Rojo', 'Rojo-Negro', 'Negro'
  ];
  final List<String> jornadasNino = ['Mañana', 'Tarde'];
  final List<String> jornadasAdulto = ['Mañana', 'Tarde', 'Noche'];

  final EstudianteService _service = EstudianteService();

  @override
  void initState() {
    super.initState();
    final e = widget.estudiante;
    nombreCtrl = TextEditingController(text: e?.nombre ?? '');
    telefonoCtrl = TextEditingController(text: e?.telefono ?? '');
    emergenciaCtrl = TextEditingController(text: e?.emergencia ?? '');
    edadCtrl = TextEditingController(text: e != null ? e.edad.toString() : '');
    imagenCtrl = TextEditingController(text: e?.imagen ?? 'assets/default.png');
    tipoSangre = e?.tipoSangre ?? 'A+';
    rango = e?.rango ?? 'Blanco';
    tipoPersona = (e?.jornada == 'Noche' || e?.jornada == 'Tarde' || e?.jornada == 'Mañana') ? 'Adulto' : 'Niño';
    jornada = e?.jornada ?? 'Mañana';
  }

  @override
  void dispose() {
    nombreCtrl.dispose();
    telefonoCtrl.dispose();
    emergenciaCtrl.dispose();
    edadCtrl.dispose();
    imagenCtrl.dispose();
    super.dispose();
  }

  Future<void> _seleccionarImagen() async {
    print('Botón de imagen presionado');
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, maxWidth: 300, maxHeight: 300);
    print('Resultado de ImagePicker: $pickedFile');
    if (pickedFile != null) {
      if (kIsWeb) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _webImageBytes = bytes;
          _imagenFile = null;
          imagenCtrl.text = '';
        });
        print('Imagen seleccionada en web');
      } else {
        setState(() {
          _imagenFile = File(pickedFile.path);
          _webImageBytes = null;
          imagenCtrl.text = pickedFile.path;
        });
        print('Imagen seleccionada en móvil');
      }
    }
  }

  void _guardar() async {
    if (_formKey.currentState!.validate()) {
      String imagenUrl = imagenCtrl.text;

      // Si hay una imagen nueva seleccionada, súbela
      if ((_imagenFile != null) || (_webImageBytes != null)) {
        final url = await _subirImagen();
        if (url != null) {
          imagenUrl = url;
          imagenCtrl.text = url; // <-- ¡Actualiza el controlador!
        }
      }

      final nuevo = Estudiante(
        id: widget.estudiante?.id,
        nombre: nombreCtrl.text,
        rango: rango,
        tipoSangre: tipoSangre,
        telefono: telefonoCtrl.text,
        emergencia: emergenciaCtrl.text,
        edad: int.tryParse(edadCtrl.text) ?? 0,
        jornada: jornada,
        imagen: imagenUrl,
      );
      Navigator.pop(context, nuevo);
    }
  }

  @override
  Widget build(BuildContext context) {
    final esEdicion = widget.estudiante != null;

    return Scaffold(
      appBar: CustomAppBar(
        title: esEdicion ? 'Editar Estudiante' : 'Agregar Estudiante',
        showBack: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0D1A36), Color(0xFF8B0000)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 8,
          child: Padding(
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
                          radius: 50,
                          backgroundColor: Colors.grey[200], // Asegura fondo para web
                          backgroundImage: _webImageBytes != null
                              ? MemoryImage(_webImageBytes!)
                              : _imagenFile != null
                                  ? FileImage(_imagenFile!)
                                  : (imagenCtrl.text.startsWith('http')
                                      ? NetworkImage(imagenCtrl.text)
                                      : AssetImage('assets/default.png')) as ImageProvider,
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
                  const SizedBox(height: 16),
                  _campo('Nombre', nombreCtrl),
                  DropdownButtonFormField<String>(
                    value: rango,
                    decoration: const InputDecoration(labelText: 'Cinturón'),
                    items: rangosCinturon.map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
                    onChanged: (v) => setState(() => rango = v!),
                  ),
                  DropdownButtonFormField<String>(
                    value: tipoSangre,
                    decoration: const InputDecoration(labelText: 'Tipo de Sangre'),
                    items: tiposSangre.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                    onChanged: (v) => setState(() => tipoSangre = v!),
                  ),
                  _campo('Teléfono', telefonoCtrl),
                  _campo('Emergencia', emergenciaCtrl),
                  _campo('Edad', edadCtrl, tipo: TextInputType.number),
                  DropdownButtonFormField<String>(
                    value: tipoPersona,
                    decoration: const InputDecoration(labelText: 'Tipo'),
                    items: ['Niño', 'Adulto'].map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                    onChanged: (v) {
                      setState(() {
                        tipoPersona = v!;
                        jornada = tipoPersona == 'Niño' ? jornadasNino[0] : jornadasAdulto[0];
                      });
                    },
                  ),
                  DropdownButtonFormField<String>(
                    value: jornada,
                    decoration: const InputDecoration(labelText: 'Jornada'),
                    items: (tipoPersona == 'Niño' ? jornadasNino : jornadasAdulto)
                        .map((j) => DropdownMenuItem(value: j, child: Text(j))).toList(),
                    onChanged: (v) => setState(() => jornada = v!),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _guardar,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[800], // Rojo oscuro
                      foregroundColor: Colors.black,    // Letras negras
                      minimumSize: const Size.fromHeight(48),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(
                      esEdicion ? 'Actualizar' : 'Guardar',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _campo(String label, TextEditingController ctrl, {TextInputType tipo = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: ctrl,
        keyboardType: tipo,
        decoration: InputDecoration(labelText: label),
        validator: (value) => value == null || value.isEmpty ? 'Campo requerido' : null,
      ),
    );
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
        filename: 'web_image.png',
      ));
      var response = await request.send();
      if (response.statusCode == 200) {
        final respStr = await response.stream.bytesToString();
        final url = jsonDecode(respStr)['url'];
        return url;
      }
      return null;
    } else if (_imagenFile != null) {
      return await _service.subirImagen(_imagenFile!);
    }
    return null;
  }
}

