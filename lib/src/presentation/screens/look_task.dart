// ignore_for_file: use_build_context_synchronously, avoid_print, unnecessary_string_interpolations, use_super_parameters, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'add_task.dart';

class LookTaskView extends StatelessWidget {
  const LookTaskView({
    Key? key,
    required this.taskData,
    required this.taskId,
    required Map taskDetails, required String tareaDetails,
  }) : super(key: key);

  final Map<String, dynamic> taskData;
  final String taskId;

  Color getBackgroundColorForEstado(String estado) {
    if (estado == 'Pendiente') {
      return Color.fromARGB(255, 76, 175, 150);
    } else if (estado == 'En Proceso') {
      return const Color.fromARGB(255, 59, 248, 255);
    } else if (estado == 'Terminado') {
      return const Color.fromARGB(255, 207, 54, 27);
    } else {
      return Color.fromARGB(255, 8, 179, 202);
    }
  }

  Future<void> markTaskAsInProgress(String taskId) async {
    try {
      await FirebaseFirestore.instance.collection('task').doc(taskId).update({
        'Estado': 'En Proceso',
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
      print('Error marcando la tarea como en progreso: $error');
    }
  }

  Future<void> markTaskAsCompleted(String taskId) async {
    try {
      await FirebaseFirestore.instance.collection('task').doc(taskId).update({
        'Estado': 'Terminado',
      });
    } catch (error) {
      print('Error marcando la tarea como completada: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4EA674),
        title: const Text('Lista de Tareas'),
      ),
      backgroundColor: const Color(0xFF70AD8B),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FutureBuilder<User?>(
              future: FirebaseAuth.instance.authStateChanges().first,
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.done) {
                  final user = userSnapshot.data;
                  if (user != null) {
                    final userId = user.uid;
                    return StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('task')
                          .where('SupervisorId', isEqualTo: userId)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.active) {
                          if (snapshot.hasData) {
                            final taskDocs = snapshot.data!.docs;
                            if (taskDocs.isNotEmpty) {
                              return Expanded(
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: taskDocs.map((taskDoc) {
                                      final taskData = taskDoc.data()
                                          as Map<String, dynamic>;
                                      final zona = taskData['Zona'];
                                      final taskId = taskDoc.id;
                                      final cantidadMax =
                                          taskData['CantidadMax'];
                                      final estado = taskData['Estado'];

                                      return InkWell(
                                        onTap: () async {
                                          if (estado != 'Terminado') {
                                            await markTaskAsInProgress(taskId);
                                            await FirebaseFirestore.instance
                                                .collection('task')
                                                .doc(taskId)
                                                .update({
                                              'IDtarea': '$taskId',
                                            });
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    AddTaskScreen(
                                                  taskData: taskData,
                                                  taskId: taskId,
                                                  taskDetails: const {
                                                    'Estado': 'En Proceso',
                                                  },
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Container(
                                                margin:
                                                    const EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      estado == 'En Proceso'
                                                          ? Color.fromARGB(255, 59, 255, 118)
                                                          : getBackgroundColorForEstado(
                                                              estado),
                                                      Color.fromARGB(235, 251, 255, 39)                                                 ],
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  boxShadow: const [
                                                    BoxShadow(
                                                      color: Colors.grey,
                                                      blurRadius: 5,
                                                    ),
                                                  ],
                                                ),
                                                child: ListTile(
                                                  title: Text(
                                                    zona,
                                                    style: TextStyle(
                                                      decoration: estado ==
                                                              'Terminado'
                                                          ? TextDecoration
                                                              .lineThrough
                                                          : TextDecoration.none,
                                                    ),
                                                  ),
                                                  subtitle: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Text(
                                                        'Cantidad de Muestras en la zona: $cantidadMax',
                                                        style: TextStyle(
                                                          decoration: estado ==
                                                                  'Terminado'
                                                              ? TextDecoration
                                                                  .lineThrough
                                                              : TextDecoration
                                                                  .none,
                                                        ),
                                                      ),
                                                      Text(
                                                        'Estado: $estado',
                                                        style: TextStyle(
                                                          color: estado ==
                                                                  'Terminado'
                                                              ? Colors.grey
                                                              : Colors.white,
                                                          decoration: estado ==
                                                                  'Terminado'
                                                              ? TextDecoration
                                                                  .lineThrough
                                                              : TextDecoration
                                                                  .none,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            if (estado != 'Terminado')
                                              ElevatedButton(
                                                onPressed: () async {
                                                  await markTaskAsCompleted(
                                                      taskId);
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Color.fromARGB(0, 94, 89, 89),
                                                  padding: EdgeInsets.zero, 
                                                ),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                      colors: [
                                                        Colors.red,
                                                        Color.fromARGB(255, 255, 51, 0),
                                                      ],
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                          vertical: 15),

                                                  child: const Text(
                                                    'Tarea Terminada',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              );
                            } else {
                              return const Text('No se encontraron tareas.');
                            }
                          }
                        }
                        return const CircularProgressIndicator();
                      },
                    );
                  } else {
                    return const Text('Usuario no autenticado.');
                  }
                }
                return const CircularProgressIndicator();
              },
            ),
          ],
        ),
      ),
    );
  }
}
