import '../models/estudiantes.dart';

class EstudianteService {
  final List<Estudiante> _estudiantes = [];

  List<Estudiante> getEstudiantes() => _estudiantes;

  void agregarEstudiante(Estudiante estudiante) {
    _estudiantes.add(estudiante);
  }

  void eliminarEstudiante(int index) {
    _estudiantes.removeAt(index);
  }

  void editarEstudiante(int index, Estudiante estudiante) {
    _estudiantes[index] = estudiante;
  }
}