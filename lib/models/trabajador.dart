import 'dart:convert';

class Trabajador {
  String id;
  String nombres;
  String apellidos;
  DateTime fechaNacimiento;
  double sueldo;

  Trabajador({
    required this.id,
    required this.nombres,
    required this.apellidos,
    required this.fechaNacimiento,
    required this.sueldo,
  });

  String get nombreCompleto => '$nombres $apellidos';

  // Convierte una instancia de Trabajador a un Map (similar a JSON).
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombres': nombres,
      'apellidos': apellidos,
      'fechaNacimiento': fechaNacimiento.toIso8601String(),
      'sueldo': sueldo,
    };
  }

  // Crea una instancia de Trabajador desde un Map.
  factory Trabajador.fromMap(Map<String, dynamic> map) {
    return Trabajador(
      id: map['id'] ?? '',
      nombres: map['nombres'] ?? '',
      apellidos: map['apellidos'] ?? '',
      fechaNacimiento: DateTime.parse(map['fechaNacimiento']),
      sueldo: map['sueldo']?.toDouble() ?? 0.0,
    );
  }

  // Métodos de conveniencia para JSON String.
  String toJson() => json.encode(toMap());

  factory Trabajador.fromJson(String source) =>
      Trabajador.fromMap(json.decode(source));
}
