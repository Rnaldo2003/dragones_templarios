class Usuario {
  int? id;
  String nombre;
  String email;
  String rol; // 'admin' o 'estudiante'

  Usuario({
    this.id,
    required this.nombre,
    required this.email,
    required this.rol,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
        id: json['id'],
        nombre: json['nombre'] ?? '',
        email: json['email'] ?? '',
        rol: json['rol'] ?? 'estudiante',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'nombre': nombre,
        'email': email,
        'rol': rol,
      };
}