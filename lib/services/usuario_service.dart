import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/usuarios.dart';

class UsuarioService {
  final String baseUrl = 'http://localhost:3000';

  Future<List<Usuario>> getUsuarios() async {
    final response = await http.get(Uri.parse('$baseUrl/users'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => Usuario.fromJson(e)).toList();
    } else {
      throw Exception('Error al cargar usuarios');
    }
  }

  Future<bool> crearUsuario(Usuario usuario, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'firstName': usuario.nombre,
        'email': usuario.email,
        'password': password,
        'rol': usuario.rol,
        'profile_picture': usuario.imagen, // <-- Nuevo campo
      }),
    );
    return response.statusCode == 201;
  }

  Future<void> eliminarUsuario(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/users/$id'));
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Error al eliminar usuario');
    }
  }

  Future<bool> editarUsuario(Usuario usuario) async {
    final response = await http.put(
      Uri.parse('$baseUrl/users/${usuario.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'firstName': usuario.nombre,
        'email': usuario.email,
        'rol': usuario.rol,
        'profile_picture': usuario.imagen,
      }),
    );
    return response.statusCode == 200;
  }
}