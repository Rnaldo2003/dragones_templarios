import 'package:flutter/material.dart';
import '../widgets/estudiantes_card.dart';
import '../models/estudiantes.dart';
import '../services/estudiante_service.dart';

class ListaEstudiantesPage extends StatefulWidget {
  const ListaEstudiantesPage({super.key});

  @override
  State<ListaEstudiantesPage> createState() => _ListaEstudiantesPageState();
}

class _ListaEstudiantesPageState extends State<ListaEstudiantesPage> {
  final EstudianteService _service = EstudianteService();

  void _mostrarFormularioAgregar() {
    final nombreCtrl = TextEditingController();
    final rangoCtrl = TextEditingController();
    final sangreCtrl = TextEditingController();
    final telefonoCtrl = TextEditingController();
    final emergenciaCtrl = TextEditingController();
    final edadCtrl = TextEditingController();
    final jornadaCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Agregar Estudiante'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(controller: nombreCtrl, decoration: const InputDecoration(labelText: 'Nombre')),
                TextField(controller: rangoCtrl, decoration: const InputDecoration(labelText: 'Rango')),
                TextField(controller: sangreCtrl, decoration: const InputDecoration(labelText: 'Tipo de Sangre')),
                TextField(controller: telefonoCtrl, decoration: const InputDecoration(labelText: 'Teléfono')),
                TextField(controller: emergenciaCtrl, decoration: const InputDecoration(labelText: 'Emergencia')),
                TextField(controller: edadCtrl, decoration: const InputDecoration(labelText: 'Edad'), keyboardType: TextInputType.number),
                TextField(controller: jornadaCtrl, decoration: const InputDecoration(labelText: 'Jornada')),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _service.agregarEstudiante(
                    Estudiante(
                      nombre: nombreCtrl.text,
                      rango: rangoCtrl.text,
                      tipoSangre: sangreCtrl.text,
                      telefono: telefonoCtrl.text,
                      emergencia: emergenciaCtrl.text,
                      edad: int.tryParse(edadCtrl.text) ?? 0,
                      jornada: jornadaCtrl.text,
                      imagen: 'assets/logo.png',
                    ),
                  );
                });
                Navigator.pop(context);
              },
              child: const Text('Agregar'),
            ),
          ],
        );
      },
    );
  }

  void _eliminarEstudiante(int index) {
    setState(() {
      _service.eliminarEstudiante(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final estudiantes = _service.getEstudiantes();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Listado de Estudiantes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _mostrarFormularioAgregar,
            tooltip: 'Agregar estudiante',
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0000A3), Color(0xFF8B0000)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: estudiantes.length,
                  itemBuilder: (context, index) {
                    return Dismissible(
                      key: UniqueKey(),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (direction) {
                        _eliminarEstudiante(index);
                      },
                      child: EstudiantesCard(estudiante: estudiantes[index]),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
