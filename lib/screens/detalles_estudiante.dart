import 'package:flutter/material.dart';
import '../models/estudiantes.dart';

class DetallesEstudiantePage extends StatelessWidget {
  final Estudiante estudiante;

  const DetallesEstudiantePage({super.key, required this.estudiante});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(estudiante.nombre),
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
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage(estudiante.imagen),
                ),
                const SizedBox(height: 20),
                _buildDetail('Nombre', estudiante.nombre),
                _buildDetail('Rango', estudiante.rango),
                _buildDetail('Tipo de Sangre', estudiante.tipoSangre),
                _buildDetail('Teléfono', estudiante.telefono),
                _buildDetail('Emergencia', estudiante.emergencia),
                _buildDetail('Edad', estudiante.edad.toString()),
                _buildDetail('Jornada', estudiante.jornada),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
