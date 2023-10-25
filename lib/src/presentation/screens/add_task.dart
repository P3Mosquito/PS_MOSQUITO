import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:ps_mosquito/colors.dart';

class AddTaskScreen extends StatefulWidget {
  final Map<String, dynamic> taskData;

  const AddTaskScreen({super.key, required this.taskData});

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  GoogleMapController? _controller;
  LocationData? _locationData;
  File? _imageFile;
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _tareaController = TextEditingController();

  Map<String, dynamic> taskDetails = {};

  @override
  void initState() {
    super.initState();
    _cargarDatos();
    _getLocation();
  }


  void _cargarDatos() {
    // Cargar datos iniciales desde widget.taskData
    setState(() {
      taskDetails = widget.taskData;
      final nombre = taskDetails['nombre'];
      final descripcion = taskDetails['descripcion'];
      final tarea = taskDetails['tarea'];
      final imagenPath = taskDetails['imagen_path'];

      if (nombre != null) {
        _nombreController.text = nombre;
      }
      if (descripcion != null) {
        _descripcionController.text = descripcion;
      }
      if (tarea != null) {
        _tareaController.text = tarea;
      }
      if (imagenPath != null) {
        _imageFile = File(imagenPath);
      }
    });
  }

  void _getLocation() async {
    // Obtener la ubicación actual
    Location location = Location();
    bool serviceEnabled = await location.serviceEnabled();

    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    _locationData = await location.getLocation();

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _takePicture() async {
    // Tomar una foto utilizando la cámara del dispositivo
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickImage() async {
    // Seleccionar una imagen de la galería
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void _deleteImage() {
    // Eliminar la imagen seleccionada
    setState(() {
      _imageFile = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Obtener información sobre la tarea desde taskDetails y ubicación actual
    final taskName = taskDetails['Nombre'];
    final zona = taskDetails['Zona'];
    final ubicacion = taskDetails['Ubicacion'];
    final supervisorId = taskDetails['SupervisorId'];

    final latitude = _locationData?.latitude ?? 0;
    final longitude = _locationData?.longitude ?? 0;

    return Scaffold(
      backgroundColor: MyColors.thirdColor,
      appBar: AppBar(
        backgroundColor: MyColors.primaryColor,
        title: const Text('Agregar Punto'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 5),
              // Información de la tarea
              Container(
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
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
              // Campos de entrada para nombre, descripción y tarea
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(labelText: 'Nombre'),
              ),
              TextFormField(
                controller: _descripcionController,
                decoration: const InputDecoration(labelText: 'Descripción'),
                keyboardType: TextInputType.multiline,
                maxLines: null,
              ),
              TextFormField(
                controller: _tareaController,
                decoration: const InputDecoration(labelText: 'Tarea'),
              ),
              // Muestra las coordenadas de la ubicación actual
              Text('Coordenadas: $latitude, $longitude'),
              const SizedBox(
                height: 20,
              ),
              // Google Map
              Container(
                height: 180,
                child: GoogleMap(
                  onMapCreated: (controller) {
                    _controller = controller;
                  },
                  initialCameraPosition: CameraPosition(
                    target: LatLng(latitude, longitude),
                    zoom: 15.0,
                  ),
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              // Botones para tomar una foto o seleccionar una imagen
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MyColors.primaryColor,
                    ),
                    onPressed: _takePicture,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.camera_alt),
                        SizedBox(width: 8),
                        Text('Tomar Foto'),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MyColors.primaryColor,
                    ),
                    onPressed: _pickImage,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.photo),
                        SizedBox(width: 8),
                        Text('Seleccionar Imagen'),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Muestra la imagen seleccionada (si hay una)
              if (_imageFile != null)
                Stack(
                  children: [
                    Container(
                      height: 200,
                      width: 200,
                      child: Image.file(_imageFile!),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red,
                        ),
                        onPressed: _deleteImage,
                        child: Icon(Icons.close),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
      // Botones flotantes para guardar y enviar la tarea
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () async {
              // Aquí puedes guardar los datos de la tarea actual en tu estructura de datos
              taskDetails['nombre'] = _nombreController.text;
              taskDetails['descripcion'] = _descripcionController.text;
              taskDetails['tarea'] = _tareaController.text;
              taskDetails['coordenadas'] = 'Latitud: $latitude, Longitud: $longitude';
              if (_imageFile != null) {
                taskDetails['imagen_path'] = _imageFile!.path;
              }

              // Puedes mostrar una notificación o realizar otras acciones si es necesario
            },
            style: ElevatedButton.styleFrom(
              primary: MyColors.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: Text('Guardar', style: TextStyle(fontSize: 14)),
          ),
          SizedBox(width: 16),
          ElevatedButton(
            onPressed: () {
              // Aquí puedes escribir la lógica para enviar la tarea.
            },
            style: ElevatedButton.styleFrom(
              primary: MyColors.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: Text('Enviar Tarea', style: TextStyle(fontSize: 14)),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}