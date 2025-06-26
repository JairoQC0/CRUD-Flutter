import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:gestor_trabajadores/models/trabajador.dart';
import 'package:gestor_trabajadores/providers/trabajador_provider.dart';

class EditarTrabajadorScreen extends StatefulWidget {
  final Trabajador trabajador;

  // Recibe el trabajador a editar a través del constructor.
  const EditarTrabajadorScreen({super.key, required this.trabajador});

  @override
  State<EditarTrabajadorScreen> createState() => _EditarTrabajadorScreenState();
}

class _EditarTrabajadorScreenState extends State<EditarTrabajadorScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nombresController;
  late TextEditingController _apellidosController;
  late TextEditingController _sueldoController;
  late DateTime _fechaNacimiento;

  @override
  void initState() {
    super.initState();
    // Inicializa los controladores con los datos del trabajador existente.
    final trabajador = widget.trabajador;
    _nombresController = TextEditingController(text: trabajador.nombres);
    _apellidosController = TextEditingController(text: trabajador.apellidos);
    _sueldoController = TextEditingController(
      text: trabajador.sueldo.toString(),
    );
    _fechaNacimiento = trabajador.fechaNacimiento;
  }

  @override
  void dispose() {
    _nombresController.dispose();
    _apellidosController.dispose();
    _sueldoController.dispose();
    super.dispose();
  }

  void _guardarCambios() {
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

    final trabajadorActualizado = Trabajador(
      id: widget.trabajador.id, // Mantiene el mismo ID.
      nombres: _nombresController.text,
      apellidos: _apellidosController.text,
      fechaNacimiento: _fechaNacimiento,
      sueldo: sueldo,
    );

    // Llama al método del provider para actualizar.
    Provider.of<TrabajadorProvider>(
      context,
      listen: false,
    ).actualizarTrabajador(trabajadorActualizado);

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
        middle: const Text('Editar Trabajador'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: _guardarCambios,
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
                prefix: const Text('Nombres'),
                textCapitalization: TextCapitalization.words,
              ),
              CupertinoTextFormFieldRow(
                controller: _apellidosController,
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
