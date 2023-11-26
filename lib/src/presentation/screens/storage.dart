// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:ps_mosquito/src/presentation/screens/look_task.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Storage extends StatefulWidget {
  @override
  _StorageState createState() => _StorageState();
}

class _StorageState extends State<Storage> {
  TextEditingController nombreController = TextEditingController();
  TextEditingController tareaController = TextEditingController();
  TextEditingController descripcionController = TextEditingController();
  List<String> tareasGuardadas = [];
  List<bool> tareaMarcada = [];
  Position? currentLocation;
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    cargarTareasGuardadas();
    obtenerUbicacionActual();
  }

  void cargarTareasGuardadas() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      tareasGuardadas = prefs.getStringList('tareas') ?? [];
      tareaMarcada = List.generate(tareasGuardadas.length, (index) => false);
    });
  }

  Future<void> guardarTareasLocalmente() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('tareas', tareasGuardadas);
  }

  Future<void> obtenerUbicacionActual() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Location services are not enabled
        // Handle accordingly, show a message, or request the user to enable location services.
        return;
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // Permissions are denied. Handle accordingly.
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever. Handle accordingly.
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        currentLocation = position;
        _markers.clear();
        _markers.add(
          Marker(
            markerId: MarkerId("currentLocation"),
            position: LatLng(position.latitude, position.longitude),
          ),
        );
      });

      if (_mapController != null) {
        _mapController!.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 15,
            ),
          ),
        );
      }
    } catch (e) {
      // ignore: avoid_print
      print("Error al obtener la ubicación: $e");
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _mapController = controller;
    });
  }

  void guardarDatosLocalmente() async {
    await obtenerUbicacionActual();

    final nombre = nombreController.text;
    final tarea = tareaController.text;
    final descripcion = descripcionController.text;

    String datos = 'Nombre: $nombre\nTarea: $tarea\nDescripción: $descripcion';

    if (currentLocation != null) {
      datos +=
          '\nLatitud: ${currentLocation!.latitude}, Longitud: ${currentLocation!.longitude}';
    }

    tareasGuardadas.add(datos);
    tareaMarcada.add(false);

    nombreController.clear();
    tareaController.clear();
    descripcionController.clear();

    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Tarea guardada exitosamente.'),
      ),
    );

    guardarTareasLocalmente();
    setState(() {});
  }

  void eliminarTarea(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar eliminación'),
          content: Text('¿Estás seguro de que deseas eliminar esta tarea?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  tareasGuardadas.removeAt(index);
                  tareaMarcada.removeAt(index);
                });

                Navigator.of(context).pop();
                guardarTareasLocalmente();
              },
              child: Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  void copiarDatosAlPortapapeles(int index) {
    if (index >= 0 && index < tareasGuardadas.length) {
      final tarea = tareasGuardadas[index];

      Clipboard.setData(ClipboardData(text: tarea));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Datos de la tarea copiados al portapapeles:\n$tarea'),
          action: SnackBarAction(
            label: 'Ver lista de tareas',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LookTaskView(
                    tareaDetails: tarea,
                    taskData: const {},
                    taskId: '',
                    taskDetails: const {},
                  ),
                ),
              );
            },
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Índice de tarea no válido.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4EA674),
        title: Text('Registrar Tarea'),
        actions: [
          IconButton(
            onPressed: () {
              guardarDatosLocalmente();
            },
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nombreController,
              decoration: InputDecoration(
                labelText: 'Nombre',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: tareaController,
              decoration: InputDecoration(
                labelText: 'Tarea',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: descripcionController,
              decoration: InputDecoration(
                labelText: 'Descripción',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: GoogleMap(
                onMapCreated: (controller) {
                  _onMapCreated(controller);
                },
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                    currentLocation?.latitude ?? 0.0,
                    currentLocation?.longitude ?? 0.0,
                  ),
                  zoom: 15,
                ),
                myLocationEnabled: true, // Enable my location button
              ),
            ),
            Text(
              'Tareas Guardadas:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Color.fromARGB(255, 3, 54, 3),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: tareasGuardadas.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: Key(tareasGuardadas[index]),
                    onDismissed: (direction) {
                      eliminarTarea(index);
                    },
                    child: Card(
                      elevation: 5,
                      margin: EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        title: Text(
                          tareasGuardadas[index],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(
                              221,
                              7,
                              7,
                              7,
                            ),
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Checkbox(
                              value: tareaMarcada[index],
                              onChanged: (bool? value) {
                                setState(() {
                                  tareaMarcada[index] = value ?? false;
                                });
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.content_paste_go),
                              onPressed: () {
                                copiarDatosAlPortapapeles(index);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                eliminarTarea(index);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
