import 'package:flutter/material.dart';
import 'package:ps_mosquito/colors.dart';

class AddTaskScreen extends StatelessWidget {
  const AddTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                height:
                    20), // Espacio entre los campos de texto y el botón de carga de imágenes
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
                  SizedBox(width: 8), // Espacio entre el icono y el texto
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
            borderRadius: BorderRadius.circular(8.0), // Radio de las esquinas
          ),
          child: const Text(
            'Guardar',
            style: TextStyle(fontSize: 14),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation
          .centerFloat, // Alinea el FAB en el centro inferior de la pantalla
    );
  }
}
