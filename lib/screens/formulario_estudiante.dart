import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../models/estudiantes.dart';
import '../widgets/custom_app_bar.dart';

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

  final List<String> tiposSangre = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];
  final List<String> rangosCinturon = [
    'Blanco', 'Blanco-Amarillo', 'Amarillo', 'Amarillo-Verde', 'Verde',
    'Verde-Azul', 'Azul', 'Azul-Rojo', 'Rojo', 'Rojo-Negro', 'Negro'
  ];
  final List<String> jornadasNino = ['Mañana', 'Tarde'];
  final List<String> jornadasAdulto = ['Mañana', 'Tarde', 'Noche'];

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
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, maxWidth: 300, maxHeight: 300);
    if (pickedFile != null) {
      setState(() {
        _imagenFile = File(pickedFile.path);
        imagenCtrl.text = pickedFile.path; // Simula guardado en assets
      });
    }
  }

  void _guardar() {
    if (_formKey.currentState!.validate()) {
      final nuevo = Estudiante(
        id: widget.estudiante?.id, // <-- Mantén el id si es edición
        nombre: nombreCtrl.text,
        rango: rango,
        tipoSangre: tipoSangre,
        telefono: telefonoCtrl.text,
        emergencia: emergenciaCtrl.text,
        edad: int.tryParse(edadCtrl.text) ?? 0,
        jornada: jornada,
        imagen: imagenCtrl.text,
      );
      Navigator.pop(context, nuevo); // Retorna el estudiante al llamador
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
                          backgroundImage: _imagenFile != null
                              ? FileImage(_imagenFile!)
                              : AssetImage(imagenCtrl.text) as ImageProvider,
                        ),
                        IconButton(
                          icon: const Icon(Icons.camera_alt, color: Colors.black87),
                          onPressed: _seleccionarImagen,
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
                    child: Text(esEdicion ? 'Actualizar' : 'Guardar'),
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
}
