import 'package:flutter/material.dart';
import 'package:ps_mosquito/src/presentation/screens/add_task.dart';
import 'package:ps_mosquito/src/presentation/screens/login_mobile.dart';
import 'package:ps_mosquito/src/presentation/screens/menu_mobile.dart';
import 'package:ps_mosquito/src/presentation/screens/task_mobile.dart';
import 'package:ps_mosquito/src/presentation/screens/zone_map.dart';

void main() {
  runApp(MyApp());
}

class Task {
  String name;

  Task(this.name);
}

class MyApp extends StatelessWidget {
  final List<Task> tasks = [
    Task('Tarea 1'),
    Task('Tarea 2'),
    Task('Tarea 3'),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mosquito',
      // Define las rutas de la aplicación
      routes: {
        '/my_tasks': (context) =>
            TaskListScreen(tasks), // Ruta para la lista de tareas
        '/login': (context) =>
            const LoginScreen(), // Ruta para la pantalla de inicio de sesión
        //'/home': (context) => HomeScreen(), // Ruta para la pantalla de inicio
        '/zone_map': (context) =>
            const ZoneMapScreen(), // Ruta para la pantalla de mapa de zona
        //'/my_perfil': (context) => MyPerfilScreen(), // Ruta para la pantalla de perfil
        '/add_task': (context) => const AddTaskScreen(),
        '/menu_mobile': (context) =>
            MenuMobile(), // Ruta para la pantalla de agregar tarea
      },
      // Define la pantalla inicial
      initialRoute: '/login',
    );
  }
}
