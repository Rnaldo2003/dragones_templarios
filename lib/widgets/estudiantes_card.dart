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
      elevation: 10,
      margin: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.red[800]!, width: 2),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.red[50]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.red[800]!, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 36,
                backgroundColor: Colors.grey[200],
                backgroundImage: estudiante.imagen != null && estudiante.imagen.startsWith('http')
                    ? NetworkImage(estudiante.imagen)
                    : const AssetImage('assets/default.png') as ImageProvider,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              estudiante.nombre,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFFB71C1C),
                shadows: [
                  Shadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: Offset(1, 2),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            _buildInfoRow(Icons.military_tech, 'Rango', estudiante.rango),
            _buildInfoRow(Icons.bloodtype, 'Tipo de Sangre', estudiante.tipoSangre),
            _buildInfoRow(Icons.phone, 'Teléfono', estudiante.telefono),
            _buildInfoRow(Icons.warning, 'Emergencia', estudiante.emergencia),
            _buildInfoRow(Icons.cake, 'Edad', estudiante.edad.toString()),
            _buildInfoRow(Icons.schedule, 'Jornada', estudiante.jornada),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: onEditar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D1A36),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Editar', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                ElevatedButton(
                  onPressed: onEliminar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[800],
                    foregroundColor: Colors.black,
                  ),
                  child: const Text('Eliminar', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.red[800]),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
