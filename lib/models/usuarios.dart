class Usuario {
  int? id;
  String nombre;
  String email;
  String rol;
  String imagen; // <-- Nuevo campo

  Usuario({
    this.id,
    required this.nombre,
    required this.email,
    required this.rol,
    required this.imagen, // <-- Nuevo campo
  });

  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
        id: json['id'],
        nombre: json['nombre'] ?? '',
        email: json['email'] ?? '',
        rol: json['rol'] ?? 'estudiante',
        imagen: json['profile_picture'] ?? 'assets/default.png', // <-- Nuevo campo
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'nombre': nombre,
        'email': email,
        'rol': rol,
        'profile_picture': imagen, // <-- Nuevo campo
      };
}