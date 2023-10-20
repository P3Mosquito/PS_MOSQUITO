import 'package:flutter/material.dart';
import 'package:ps_mosquito/colors.dart';
import 'map_mobile.dart'; // Importa la pantalla de mapa móvil

class AddTaskScreen extends StatelessWidget {
  final Map<String, dynamic> taskData;

  AddTaskScreen({required this.taskData});

  @override
  Widget build(BuildContext context) {
    final taskName = taskData['Nombre'];
    final zona = taskData['Zona'];
    final ubicacion = taskData['Ubicacion'];
    final supervisorId = taskData['SupervisorId'];

    return Scaffold(
      backgroundColor: MyColors.thirdColor,
      appBar: AppBar(
        backgroundColor: MyColors.primaryColor,
        title: const Text('Agregar Punto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: MyColors.primaryColor,
              ),
              onPressed: () {
                // Navegar a la pantalla de mapa móvil
                Navigator.push(context, MaterialPageRoute(builder: (context) => MapMobile()));
              },

              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.location_pin),
                  SizedBox(width: 8),
                  Text('Mapa: Realizar tareas'),
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: ListTile(
                title: Text('Nombre: $taskName'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Zona: $zona'),
                    Text('Ubicación: $ubicacion'),
                    Text('ID del supervisor: $supervisorId'),
                  ],
                ),
              ),
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            const TextField(
              decoration: InputDecoration(labelText: 'Descripción'),
              keyboardType: TextInputType.multiline,
              maxLines: null,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Tarea'),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: MyColors.primaryColor,
              ),
              onPressed: () {
                // Agregar lógica para cargar imágenes aquí
              },
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.camera_alt),
                  SizedBox(width: 8),
                  Text('Subir Imagen'),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: SizedBox(
        width: 120,
        child: FloatingActionButton(
          onPressed: () {
            // Navegar a la pantalla de inicio
            Navigator.of(context).pushNamed('/login');
          },
          backgroundColor: MyColors.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: const Text(
            'Guardar',
            style: TextStyle(fontSize: 14),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
