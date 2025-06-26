import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:gestor_trabajadores/models/trabajador.dart';
import 'package:gestor_trabajadores/providers/trabajador_provider.dart';

class AgregarTrabajadorScreen extends StatefulWidget {
  const AgregarTrabajadorScreen({super.key});

  @override
  State<AgregarTrabajadorScreen> createState() =>
      _AgregarTrabajadorScreenState();
}

class _AgregarTrabajadorScreenState extends State<AgregarTrabajadorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombresController = TextEditingController();
  final _apellidosController = TextEditingController();
  final _sueldoController = TextEditingController();
  DateTime _fechaNacimiento = DateTime.now();

  @override
  void dispose() {
    _nombresController.dispose();
    _apellidosController.dispose();
    _sueldoController.dispose();
    super.dispose();
  }

  void _guardarTrabajador() {
    // Valida que los campos no estén vacíos.
    if (_nombresController.text.isEmpty ||
        _apellidosController.text.isEmpty ||
        _sueldoController.text.isEmpty) {
      _mostrarAlerta(
        'Campos incompletos',
        'Por favor, llena todos los campos.',
      );
      return;
    }

    final sueldo = double.tryParse(_sueldoController.text);
    if (sueldo == null) {
      _mostrarAlerta('Dato inválido', 'El sueldo debe ser un número.');
      return;
    }

    final nuevoTrabajador = Trabajador(
      id: DateTime.now().toIso8601String(), // ID único basado en el tiempo.
      nombres: _nombresController.text,
      apellidos: _apellidosController.text,
      fechaNacimiento: _fechaNacimiento,
      sueldo: sueldo,
    );

    // Usa el provider para agregar el trabajador y persistir los datos.
    Provider.of<TrabajadorProvider>(
      context,
      listen: false,
    ).agregarTrabajador(nuevoTrabajador);

    // Regresa a la pantalla anterior.
    Navigator.of(context).pop();
  }

  void _mostrarSelectorFecha() {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 250,
        color: const Color.fromARGB(255, 255, 255, 255),
        child: Column(
          children: [
            SizedBox(
              height: 180,
              child: CupertinoDatePicker(
                initialDateTime: _fechaNacimiento,
                mode: CupertinoDatePickerMode.date,
                onDateTimeChanged: (val) {
                  setState(() {
                    _fechaNacimiento = val;
                  });
                },
              ),
            ),
            CupertinoButton(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }

  void _mostrarAlerta(String titulo, String contenido) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(titulo),
        content: Text(contenido),
        actions: [
          CupertinoDialogAction(
            child: const Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Agregar Trabajador'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: _guardarTrabajador,
          child: const Text('Guardar'),
        ),
      ),
      child: SafeArea(
        child: Form(
          key: _formKey,
          child: CupertinoFormSection.insetGrouped(
            header: const Text('Datos del Trabajador'),
            children: [
              CupertinoTextFormFieldRow(
                controller: _nombresController,
                placeholder: 'Ej: Juan',
                prefix: const Text('Nombres'),
                textCapitalization: TextCapitalization.words,
              ),
              CupertinoTextFormFieldRow(
                controller: _apellidosController,
                placeholder: 'Ej: Pérez',
                prefix: const Text('Apellidos'),
                textCapitalization: TextCapitalization.words,
              ),
              CupertinoFormRow(
                prefix: const Text('Fec. Nacim.'),
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: _mostrarSelectorFecha,
                  child: Text(
                    DateFormat('dd/MM/yyyy').format(_fechaNacimiento),
                    style: const TextStyle(
                      color: CupertinoColors.label,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              CupertinoTextFormFieldRow(
                controller: _sueldoController,
                placeholder: 'Ej: 1500.00',
                prefix: const Text('Sueldo (S/)'),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
