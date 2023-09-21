import 'package:flutter/material.dart';
import 'package:ps_mosquito/colors.dart';
import 'package:ps_mosquito/main.dart';

class TaskListScreen extends StatelessWidget {
  final List<Task> tasks;

  TaskListScreen(this.tasks);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.thirdColor,
      appBar: AppBar(
        backgroundColor: MyColors.primaryColor,
        title: const Text('Lista de Tareas'),
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return ListTile(
            title: Text(task.name),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    // Acción al presionar el botón de editar
                    // Puedes abrir una pantalla de edición aquí
                    //Ir a la pantalla de edicion
                    Navigator.of(context).pushNamed('/add_task');
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    // Acción al presionar el botón de eliminar
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: MyColors.primaryColor,
                          title: const Text('Eliminar Tarea'),
                          content: const Text(
                              '¿Estás seguro de que deseas eliminar esta tarea?'),
                          actions: [
                            TextButton(
                              style: TextButton.styleFrom(
                                foregroundColor: MyColors.whiteColor,
                              ),
                              child: const Text('Cancelar'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.red,
                              ),
                              child: const Text('Eliminar'),
                              onPressed: () {
                                // Eliminar la tarea de la lista
                                tasks.removeAt(index);
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
      //add two fab buttons row to the scaffold
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FloatingActionButton(
              backgroundColor: MyColors.primaryColor,
              heroTag: 'addTask',
              onPressed: () {
                // Acción al presionar el botón de agregar tarea
                // Puedes abrir una pantalla de agregar tarea aquí
                //Ir a la pantalla de agregar tarea
                //Navigator.of(context).pushNamed('/add_task');
              },
              child: const Icon(Icons.sync),
            ),
            const SizedBox(width: 200),
            FloatingActionButton(
              backgroundColor: MyColors.primaryColor,
              heroTag: 'logout',
              onPressed: () {
                // Acción al presionar el botón de cerrar sesión
                // Puedes cerrar sesión aquí
                //Ir a la pantalla de inicio de sesion
                //Navigator.of(context).pushNamed('/login');
              },
              child: const Icon(Icons.refresh),
            ),
          ],
        ),
      ),
    );
  }
}
