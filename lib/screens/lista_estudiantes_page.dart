import 'package:flutter/material.dart';
import '../widgets/estudiantes_card.dart';
import '../models/estudiantes.dart';
import '../services/estudiante_service.dart';
import 'formulario_estudiante.dart';

class ListaEstudiantesPage extends StatefulWidget {
  const ListaEstudiantesPage({super.key});

  @override
  State<ListaEstudiantesPage> createState() => _ListaEstudiantesPageState();
}

class _ListaEstudiantesPageState extends State<ListaEstudiantesPage> {
  final EstudianteService _service = EstudianteService();

  Future<void> _mostrarFormularioAgregar() async {
    final nuevo = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const FormularioEstudiantePage(),
      ),
    );
    if (nuevo != null && nuevo is Estudiante) {
      setState(() {
        _service.agregarEstudiante(nuevo);
      });
    }
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
