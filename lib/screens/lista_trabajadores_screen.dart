import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:gestor_trabajadores/models/trabajador.dart';
import 'package:gestor_trabajadores/providers/trabajador_provider.dart';
import 'package:gestor_trabajadores/screens/agregar_trabajador_screen.dart';
import 'package:gestor_trabajadores/screens/editar_trabajador_screen.dart'; // Importar la nueva pantalla

class ListaTrabajadoresScreen extends StatelessWidget {
  const ListaTrabajadoresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final trabajadorProvider = Provider.of<TrabajadorProvider>(context);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Trabajadores'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.add),
          onPressed: () {
            Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (context) => const AgregarTrabajadorScreen(),
              ),
            );
          },
        ),
      ),
      child: SafeArea(
        child: Consumer<TrabajadorProvider>(
          builder: (context, provider, child) {
            if (provider.trabajadores.isEmpty) {
              return const Center(
                child: Text(
                  'No hay trabajadores registrados.',
                  style: TextStyle(color: CupertinoColors.inactiveGray),
                ),
              );
            }
            return ListView.builder(
              itemCount: provider.trabajadores.length,
              itemBuilder: (context, index) {
                final trabajador = provider.trabajadores[index];
                final currencyFormatter = NumberFormat.currency(
                  locale: 'es_PE',
                  symbol: 'S/ ',
                );
                final dateFormatter = DateFormat('dd/MM/yyyy');

                return CupertinoListTile(
                  title: Text(trabajador.nombreCompleto),
                  subtitle: Text(
                    'Nacimiento: ${dateFormatter.format(trabajador.fechaNacimiento)}',
                  ),
                  additionalInfo: Text(
                    currencyFormatter.format(trabajador.sueldo),
                    style: const TextStyle(color: CupertinoColors.systemGreen),
                  ),
                  // --- MODIFICACIÓN ---
                  // Al tocar el tile, navega a la pantalla de edición.
                  onTap: () {
                    Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (context) =>
                            EditarTrabajadorScreen(trabajador: trabajador),
                      ),
                    );
                  },
                  // --- FIN MODIFICACIÓN ---
                  trailing: CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: const Icon(
                      CupertinoIcons.delete,
                      color: CupertinoColors.systemRed,
                    ),
                    onPressed: () => _mostrarAlertaEliminar(
                      context,
                      trabajador,
                      trabajadorProvider,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _mostrarAlertaEliminar(
    BuildContext context,
    Trabajador trabajador,
    TrabajadorProvider provider,
  ) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Confirmar eliminación'),
        content: Text(
          '¿Estás seguro de que quieres eliminar a ${trabajador.nombreCompleto}?',
        ),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            child: const Text('Cancelar'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: const Text('Eliminar'),
            onPressed: () {
              provider.eliminarTrabajador(trabajador.id);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
