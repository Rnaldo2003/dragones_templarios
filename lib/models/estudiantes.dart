class Estudiante {
  int? id; // <-- Nuevo campo
  String nombre;
  String rango;
  String tipoSangre;
  String telefono;
  String emergencia;
  int edad;
  String jornada;
  String imagen;

  Estudiante({
    this.id, // <-- Nuevo campo
    required this.nombre,
    required this.rango,
    required this.tipoSangre,
    required this.telefono,
    required this.emergencia,
    required this.edad,
    required this.jornada,
    required this.imagen,
  });

  factory Estudiante.fromJson(Map<String, dynamic> json) => Estudiante(
        id: json['id'], // <-- Nuevo campo
        nombre: json['firstName'] ?? '',
        rango: json['rango'] ?? '',
        tipoSangre: json['tipoSangre'] ?? '',
        telefono: json['telefono'] ?? '',
        emergencia: json['emergencia'] ?? '',
        edad: json['edad'] ?? 0,
        jornada: json['jornada'] ?? '',
        imagen: (json['profile_picture'] != null &&
                (json['profile_picture'] as String).isNotEmpty)
            ? json['profile_picture']
            : 'assets/default.png',
      );

  Map<String, dynamic> toJson() => {
        'id': id, // <-- Nuevo campo
        'firstName': nombre,
        'rango': rango,
        'tipoSangre': tipoSangre,
        'telefono': telefono,
        'emergencia': emergencia,
        'edad': edad,
        'jornada': jornada,
        'profile_picture': imagen,
      };
}