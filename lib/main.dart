import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:gestor_trabajadores/providers/trabajador_provider.dart';
import 'package:gestor_trabajadores/screens/lista_trabajadores_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Usamos ChangeNotifierProvider para manejar el estado de la lista de trabajadores.
    // De esta forma, la UI se actualizará automáticamente cuando los datos cambien.
    return ChangeNotifierProvider(
      create: (context) => TrabajadorProvider(),
      child: const CupertinoApp(
        debugShowCheckedModeBanner: false,
        title: 'Gestor de Trabajadores',
        // Establecemos el tema de Cupertino para un look & feel de iOS.
        theme: CupertinoThemeData(
          brightness: Brightness.light,
          primaryColor: CupertinoColors.systemBlue,
        ),
        home: ListaTrabajadoresScreen(),
      ),
    );
  }
}
