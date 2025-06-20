import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/estudiantes.dart';

class EstudianteService {
  final String baseUrl = 'http://localhost:3000';

  Future<List<Estudiante>> getEstudiantes() async {
    final response = await http.get(Uri.parse('$baseUrl/estudiantes'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => Estudiante.fromJson(e)).toList();
    } else {
      throw Exception('Error al cargar estudiantes');
    }
  }

  Future<void> eliminarEstudiante(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/estudiantes/$id'));
    if (response.statusCode != 200) {
      throw Exception('Error al eliminar estudiante');
    }
  }

  Future<void> agregarEstudiante(Estudiante estudiante) async {
    final response = await http.post(
      Uri.parse('$baseUrl/estudiantes'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(estudiante.toJson()),
    );
    if (response.statusCode != 201) {
      throw Exception('Error al agregar estudiante');
    }
  }

  Future<void> editarEstudiante(Estudiante estudiante) async {
    if (estudiante.id == null) throw Exception('Estudiante sin ID');
    final response = await http.put(
      Uri.parse('$baseUrl/estudiantes/${estudiante.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(estudiante.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Error al editar estudiante');
    }
  }
}