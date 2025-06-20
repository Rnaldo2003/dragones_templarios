import 'package:flutter/material.dart';
import '../widgets/estudiantes_card.dart';
import '../models/estudiantes.dart';
import '../services/estudiante_service.dart';
import 'formulario_estudiante.dart';
import '../widgets/custom_app_bar.dart';

class ListaEstudiantesPage extends StatefulWidget {
  const ListaEstudiantesPage({super.key});

  @override
  State<ListaEstudiantesPage> createState() => _ListaEstudiantesPageState();
}

class _ListaEstudiantesPageState extends State<ListaEstudiantesPage> {
  final EstudianteService _service = EstudianteService();
  String _busqueda = '';
  late Future<List<Estudiante>> _futureEstudiantes;

  @override
  void initState() {
    super.initState();
    _futureEstudiantes = _service.getEstudiantes();
  }

  Future<void> _mostrarFormularioAgregar() async {
    final nuevo = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const FormularioEstudiantePage(),
      ),
    );
    if (nuevo != null && nuevo is Estudiante) {
      await _service.agregarEstudiante(nuevo);
      setState(() {
        _futureEstudiantes = _service.getEstudiantes();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Listado de Estudiantes',
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
            colors: [Color(0xFF0D1A36), Color(0xFF8B0000)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Buscar por nombre, sangre o cinturón',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.9),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _busqueda = value;
                    });
                  },
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: FutureBuilder<List<Estudiante>>(
                  future: _futureEstudiantes,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text(
                          'No se encontraron estudiantes.',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      );
                    }
                    final estudiantes = snapshot.data!;
                    final estudiantesFiltrados = estudiantes.where((e) {
                      final query = _busqueda.toLowerCase();
                      return e.nombre.toLowerCase().contains(query) ||
                          e.tipoSangre.toLowerCase().contains(query) ||
                          e.rango.toLowerCase().contains(query);
                    }).toList();

                    return estudiantesFiltrados.isEmpty
                        ? const Center(
                            child: Text(
                              'No se encontraron estudiantes.',
                              style: TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: estudiantesFiltrados.length,
                            itemBuilder: (context, index) {
                              final estudiante = estudiantesFiltrados[index];
                              return EstudiantesCard(
                                estudiante: estudiante,
                                onEliminar: () async {
                                  if (estudiante.id != null) {
                                    await _service.eliminarEstudiante(estudiante.id!);
                                    setState(() {
                                      _futureEstudiantes = _service.getEstudiantes();
                                    });
                                  }
                                },
                                onEditar: () async {
                                  final actualizado = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => FormularioEstudiantePage(estudiante: estudiante),
                                    ),
                                  );
                                  if (actualizado != null && actualizado is Estudiante) {
                                    await _service.editarEstudiante(actualizado);
                                    setState(() {
                                      _futureEstudiantes = _service.getEstudiantes();
                                    });
                                  }
                                },
                              );
                            },
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