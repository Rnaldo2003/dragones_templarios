import 'package:flutter/material.dart';
import '../models/estudiantes.dart';
import '../widgets/custom_app_bar.dart';

class DetallesEstudiantePage extends StatelessWidget {
  final Estudiante estudiante;

  const DetallesEstudiantePage({super.key, required this.estudiante});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Detalles del Estudiante', showBack: true),
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage(estudiante.imagen),
                  radius: 50,
                ),
                const SizedBox(height: 20),
                _buildDetail('Jornada', estudiante.jornada),
                _buildDetail('Edad', estudiante.edad.toString()),
                _buildDetail('Teléfono', estudiante.telefono),
                _buildDetail('Emergencia', estudiante.emergencia),
                _buildDetail('Tipo de Sangre', estudiante.tipoSangre),
                _buildDetail('Cinturón', estudiante.rango),
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
