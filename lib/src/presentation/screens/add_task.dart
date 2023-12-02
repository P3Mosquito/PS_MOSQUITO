// ignore_for_file: deprecated_member_use, sized_box_for_whitespace, unused_field, prefer_const_constructors, duplicate_import, unused_import, body_might_complete_normally_catch_error, unused_local_variable, use_super_parameters, library_private_types_in_public_api, non_constant_identifier_names, unused_element, use_build_context_synchronously
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ps_mosquito/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';

class AddTaskScreen extends StatefulWidget {
  final Map<String, dynamic> taskData;

  const AddTaskScreen({
    Key? key,
    required this.taskData,
    required String taskId,
    required Map<String, String> taskDetails,
  }) : super(key: key);

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  GoogleMapController? _mapController;
  LocationData? _locationData;
  List<File> _imageFiles = [];
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _tareaController = TextEditingController();
  final TextEditingController _cordenadasController = TextEditingController();

  Map<String, dynamic> taskDetails = {};
  Map<String, dynamic> task_listDetails = {};
  int cantidadEnviada = 0;
  int CantidadTareasRealizadas = 0;
  bool _enviandoTarea = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
    _getLocation();
  }

  void _cargarDatos() {
    setState(() {
      taskDetails = widget.taskData;
      final nombre = task_listDetails['nombre'];
      final descripcion = task_listDetails['descripcion'];
      final tarea = task_listDetails['tarea'];
      final imagenPaths = task_listDetails['imagen_paths'];

      if (nombre != null) {
        _nombreController.text = nombre;
      }
      if (descripcion != null) {
        _descripcionController.text = descripcion;
      }
      if (tarea != null) {
        _tareaController.text = tarea;
      }

      if (imagenPaths != null) {
        _imageFiles = imagenPaths.map((path) => File(path)).toList();
      }
    });
  }

  void _getLocation() async {
    Location location = Location();
    bool serviceEnabled = await location.serviceEnabled();

    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    _locationData = await location.getLocation();

    if (_mapController != null && _locationData != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLng(
            LatLng(_locationData!.latitude!, _locationData!.longitude!)),
      );
    }

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _takePicture() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _imageFiles.add(File(pickedFile.path));
      });
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFiles.add(File(pickedFile.path));
      });
    }
  }

  void _deleteImage(int index) {
    setState(() {
      _imageFiles.removeAt(index);
    });
  }

  void _pegarDatos() async {
    ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);

    if (data != null) {
      final text = data.text ?? '';

      setState(() {
        _nombreController.text = _extraerDato(text, 'Nombre');
        _descripcionController.text = _extraerDato(text, 'Descripción');
        _tareaController.text = _extraerDato(text, 'Tarea');
        _setLatitudLongitudEnCoordenadas(text);
      });
    }
  }

  String _extraerDato(String texto, String etiqueta) {
    RegExp regex = RegExp('$etiqueta: ([^\n]*)');
    Match match = regex.firstMatch(texto) as Match;
    return match.group(1) ?? '';
  }

  void _setLatitudLongitudEnCoordenadas(String texto) {
    RegExp regexLatitud = RegExp('Latitud: ([^,]*)');
    RegExp regexLongitud = RegExp('Longitud: ([^\n]*)');

    Match matchLatitud = regexLatitud.firstMatch(texto) as Match;
    Match matchLongitud = regexLongitud.firstMatch(texto) as Match;

    String latitud = matchLatitud.group(1) ?? '0';
    String longitud = matchLongitud.group(1) ?? '0';

    String coordenadas = 'Latitud: $latitud, Longitud: $longitud';

    setState(() {
      // Pega las coordenadas en el campo "Coordenadas Recolectadas"
      _cordenadasController.text = coordenadas;
    });
  }

  //Aux Tratando de actulizar el task de las tareas en tiempo real
  Future<void> markTaskAsInProgress(String taskId) async {
    try {
      await FirebaseFirestore.instance.collection('task').doc(taskId).update({
        'CantidadTareasRealizadas': FieldValue.increment(1),
      });

      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userId = user.uid;
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .update({
          'currentTaskId': taskId,
        });
      }
    } catch (error) {
      // ignore: avoid_print
      print('Error marcando la tarea como en progreso: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final zona = taskDetails['Zona'];
    final ubicacion = taskDetails['coordenadas'];
    var CantidadMax = taskDetails['CantidadMax'];
    var CantidadTareasRealizadas = taskDetails['CantidadTareasRealizadas'];

    final estado = taskDetails['Estado'];

    final latitude = _locationData?.latitude ?? 0;
    final longitude = _locationData?.longitude ?? 0;

    return Scaffold(
      backgroundColor: MyColors.thirdColor,
      appBar: AppBar(
        backgroundColor: MyColors.primaryColor,
        title: const Text('Agregar Punto'),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(height: 5),
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
                      title: Text('Zona: $zona'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                              'Cantidad de muestras a realizar en la zona: $CantidadMax'),
                          Text(
                              'Cantidad de muestras Realizadas: $CantidadTareasRealizadas'),
                          Text('Estado: $estado',
                              style: TextStyle(
                                  color: const Color.fromARGB(255, 0, 0, 0))),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 230,
                    child: GoogleMap(
                      onMapCreated: (controller) {
                        _mapController = controller;
                        _getLocation();
                      },
                      initialCameraPosition: CameraPosition(
                        target: LatLng(latitude, longitude),
                        zoom: 15.0,
                      ),
                      myLocationEnabled: true,
                      myLocationButtonEnabled: true,
                      polygons: ubicacion != null
                          ? <Polygon>{
                              Polygon(
                                polygonId: const PolygonId('myPolygon'),
                                points: ubicacion.map<LatLng>((coordinate) {
                                  double latitud = coordinate['Lat']!;
                                  double longitud = coordinate['Lng']!;
                                  return LatLng(latitud, longitud);
                                }).toList(),
                                strokeWidth: 2,
                                strokeColor:
                                    const Color.fromARGB(255, 247, 1, 1),
                                fillColor: const Color.fromARGB(75, 243, 33, 33)
                                    .withOpacity(0.3),
                              ),
                            }
                          : <Polygon>{},
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _pegarDatos,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MyColors.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.content_paste),
                        SizedBox(width: 8),
                        Text('Pegar Datos', style: TextStyle(fontSize: 14)),
                      ],
                    ),
                  ),
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
                  Visibility(
                    visible: false,
                    child: Text('Coordenadas: $latitude, $longitude'),
                  ),
                  TextFormField(
                    controller: _cordenadasController,
                    decoration: InputDecoration(
                      labelText: 'Coordenadas Recolectadas',
                      hintText:
                          'Latitud: ${_locationData?.latitude ?? 0}, Longitud: ${_locationData?.longitude ?? 0}',
                    ),
                    onChanged: (text) {},
                  ),
                  const SizedBox(height: 20),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: MyColors.primaryColor,
                        ),
                        onPressed: _takePicture,
                        child: const Row(
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
                        child: const Row(
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
                  if (_imageFiles.isNotEmpty)
                    Column(
                      children: _imageFiles.asMap().entries.map((entry) {
                        final index = entry.key;
                        final imageFile = entry.value;
                        return Stack(
                          children: [
                            SizedBox(
                              height: 200,
                              width: 200,
                              child: Image.file(imageFile),
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.red,
                                ),
                                onPressed: () => _deleteImage(index),
                                child: const Icon(Icons.close),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                ],
              ),
            ),
          ),
          if (_isLoading)
            AbsorbPointer(
              absorbing: true,
              child: Container(
                color: Colors.black.withOpacity(0.3),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _enviandoTarea || _isLoading
                  ? null
                  : () async {
                      if (_nombreController.text.isEmpty ||
                          _descripcionController.text.isEmpty ||
                          _tareaController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text('Por favor, complete todos los campos.'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      } else if (CantidadTareasRealizadas >= CantidadMax) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Has alcanzado la cantidad máxima de tareas enviadas.'),
                            duration: Duration(seconds: 3),
                          ),
                        );
                        // Verificar si la cantidad enviada es igual a la cantidad máxima
                      } else {
                        setState(() {
                          _enviandoTarea = true;
                          _isLoading = true;
                        });

                        // Subir las imágenes a Firebase Storage
                        List<String> imageUrls = [];
                        for (final imageFile in _imageFiles) {
                          Reference storageReference = FirebaseStorage.instance
                              .ref()
                              .child(
                                  'images/${DateTime.now().millisecondsSinceEpoch}.png');
                          UploadTask uploadTask =
                              storageReference.putFile(imageFile);

                          await uploadTask.whenComplete(() async {
                            String imageUrl =
                                await storageReference.getDownloadURL();
                            imageUrls.add(imageUrl);
                          }).catchError((error) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text('Error al cargar una imagen: $error'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          });
                        }

                        final tareasRef =
                            FirebaseFirestore.instance.collection('task_list');

                        final tareaData = {
                          'Nombre': _nombreController.text,
                          'descripcion': _descripcionController.text,
                          'tarea': _tareaController.text,
                          'coordenadas':
                              'Latitud: $latitude, Longitud: $longitude',
                          'imagen_paths': imageUrls,
                          'Id Tarea': taskDetails,
                        };

                        DocumentReference documentReference =
                            await tareasRef.add(tareaData);
                        String taskId = documentReference.id;
                        // Actualizar el valor de CantidadTareasRealizadas en taskDetails
                        setState(() {
                          taskDetails['CantidadTareasRealizadas'] =
                              (taskDetails['CantidadTareasRealizadas'] ?? 0) +
                                  1;
                        });

                        Future<void> markTaskAsInProgress(String taskId) async {
                          // Actualiza la colección 'task' con la nueva cantidad de tareas realizadas
                          await FirebaseFirestore.instance
                              .collection('task')
                              .doc(taskId)
                              .update({
                            'CantidadTareasRealizadas': FieldValue.increment(1),
                          });
                        }

                        cantidadEnviada++;
                        CantidadTareasRealizadas++;

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Tarea Enviada al Administrador'),
                            duration: Duration(seconds: 3),
                          ),
                        );

                        setState(() {
                          _enviandoTarea = false;
                          _isLoading = false;
                        });
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: MyColors.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.send),
                  const SizedBox(width: 8),
                  _enviandoTarea
                      ? CircularProgressIndicator()
                      : Text('Enviar tarea', style: TextStyle(fontSize: 14)),
                ],
              ),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: () {
                // Lógica para navegar a la ventana /storage
                Navigator.of(context).pushNamed('/storage');
              },
              style: ElevatedButton.styleFrom(
                primary: MyColors.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Row(
                children: const [
                  Icon(Icons.cloud_off),
                  SizedBox(width: 8),
                  Text('Sin conexión', style: TextStyle(fontSize: 14)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
