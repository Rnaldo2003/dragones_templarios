import 'package:flutter/material.dart';
import '../models/estudiantes.dart';

class EstudiantesCard extends StatelessWidget {
  final Estudiante estudiante;
  final VoidCallback? onEliminar;
  final VoidCallback? onEditar; // <-- Nuevo parámetro

  const EstudiantesCard({
    super.key,
    required this.estudiante,
    this.onEliminar,
    this.onEditar, // <-- Nuevo
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage(estudiante.imagen),
            ),
            const SizedBox(height: 10),
            Text(
              estudiante.nombre,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            _buildInfoRow('Rango', estudiante.rango),
            _buildInfoRow('Tipo de Sangre', estudiante.tipoSangre),
            _buildInfoRow('Teléfono', estudiante.telefono),
            _buildInfoRow('Emergencia', estudiante.emergencia),
            _buildInfoRow('Edad', estudiante.edad.toString()),
            _buildInfoRow('Jornada', estudiante.jornada),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: onEditar, // <-- Usa el callback aquí
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text('Editar'),
                ),
                ElevatedButton(
                  onPressed: onEliminar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: const Text('Eliminar'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      children: [
        Text(
          '$label: ',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Expanded(child: Text(value)),
      ],
    );
  }
}
