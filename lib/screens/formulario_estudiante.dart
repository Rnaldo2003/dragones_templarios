import 'package:flutter/material.dart';
import '../models/estudiantes.dart';

class FormularioEstudiantePage extends StatefulWidget {
  final Estudiante? estudiante; // null si se va a crear

  const FormularioEstudiantePage({super.key, this.estudiante});

  @override
  State<FormularioEstudiantePage> createState() => _FormularioEstudiantePageState();
}

class _FormularioEstudiantePageState extends State<FormularioEstudiantePage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nombreCtrl;
  late TextEditingController rangoCtrl;
  late TextEditingController sangreCtrl;
  late TextEditingController telefonoCtrl;
  late TextEditingController emergenciaCtrl;
  late TextEditingController edadCtrl;
  late TextEditingController jornadaCtrl;
  late TextEditingController imagenCtrl;

  @override
  void initState() {
    super.initState();
    final e = widget.estudiante;
    nombreCtrl = TextEditingController(text: e?.nombre ?? '');
    rangoCtrl = TextEditingController(text: e?.rango ?? '');
    sangreCtrl = TextEditingController(text: e?.tipoSangre ?? '');
    telefonoCtrl = TextEditingController(text: e?.telefono ?? '');
    emergenciaCtrl = TextEditingController(text: e?.emergencia ?? '');
    edadCtrl = TextEditingController(text: e != null ? e.edad.toString() : '');
    jornadaCtrl = TextEditingController(text: e?.jornada ?? '');
    imagenCtrl = TextEditingController(text: e?.imagen ?? 'assets/default.png');
  }

  @override
  void dispose() {
    nombreCtrl.dispose();
    rangoCtrl.dispose();
    sangreCtrl.dispose();
    telefonoCtrl.dispose();
    emergenciaCtrl.dispose();
    edadCtrl.dispose();
    jornadaCtrl.dispose();
    imagenCtrl.dispose();
    super.dispose();
  }

  void _guardar() {
    if (_formKey.currentState!.validate()) {
      final nuevo = Estudiante(
        nombre: nombreCtrl.text,
        rango: rangoCtrl.text,
        tipoSangre: sangreCtrl.text,
        telefono: telefonoCtrl.text,
        emergencia: emergenciaCtrl.text,
        edad: int.tryParse(edadCtrl.text) ?? 0,
        jornada: jornadaCtrl.text,
        imagen: imagenCtrl.text,
      );

      Navigator.pop(context, nuevo); // Retorna el estudiante al llamador
    }
  }

  @override
  Widget build(BuildContext context) {
    final esEdicion = widget.estudiante != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(esEdicion ? 'Editar Estudiante' : 'Agregar Estudiante'),
        backgroundColor: Colors.red[800],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0000A3), Color(0xFF8B0000)],
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
                  _campo('Nombre', nombreCtrl),
                  _campo('Rango', rangoCtrl),
                  _campo('Tipo de Sangre', sangreCtrl),
                  _campo('Teléfono', telefonoCtrl),
                  _campo('Emergencia', emergenciaCtrl),
                  _campo('Edad', edadCtrl, tipo: TextInputType.number),
                  _campo('Jornada', jornadaCtrl),
                  _campo('Ruta Imagen', imagenCtrl),
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
