import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gestor_trabajadores/models/trabajador.dart';

class TrabajadorProvider extends ChangeNotifier {
  final List<Trabajador> _trabajadores = [];
  static const _storageKey = 'trabajadores_lista';

  List<Trabajador> get trabajadores => _trabajadores;

  TrabajadorProvider() {
    cargarTrabajadores();
  }

  Future<void> cargarTrabajadores() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(_storageKey);

    if (data != null) {
      _trabajadores.clear();
      _trabajadores.addAll(
        data.map((trabajadorJson) => Trabajador.fromJson(trabajadorJson)),
      );
    }
    notifyListeners();
  }

  Future<void> _guardarTrabajadores() async {
    final prefs = await SharedPreferences.getInstance();
    final data = _trabajadores
        .map((trabajador) => trabajador.toJson())
        .toList();
    await prefs.setStringList(_storageKey, data);
  }

  Future<void> agregarTrabajador(Trabajador trabajador) async {
    _trabajadores.add(trabajador);
    await _guardarTrabajadores();
    notifyListeners();
  }

  // --- NUEVO MÉTODO ---
  // Actualiza un trabajador existente en la lista.
  Future<void> actualizarTrabajador(Trabajador trabajadorActualizado) async {
    // Busca el índice del trabajador a actualizar usando su ID único.
    final index = _trabajadores.indexWhere(
      (trabajador) => trabajador.id == trabajadorActualizado.id,
    );

    if (index != -1) {
      // Si se encuentra, lo reemplaza en esa posición.
      _trabajadores[index] = trabajadorActualizado;
      await _guardarTrabajadores();
      notifyListeners();
    }
  }
  // --- FIN NUEVO MÉTODO ---

  Future<void> eliminarTrabajador(String id) async {
    _trabajadores.removeWhere((trabajador) => trabajador.id == id);
    await _guardarTrabajadores();
    notifyListeners();
  }
}
