import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'map_mobile.dart';
import 'add_task.dart'; // Importa add_task.dart

class LookTaskView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF4EA674),
        title: const Text('Lista de Tareas'),
      ),
      backgroundColor: Color.fromARGB(255, 112, 173, 139), // Fondo de color
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
                        if (snapshot.connectionState == ConnectionState.active) {
                          if (snapshot.hasData) {
                            final taskDocs = snapshot.data!.docs;
                            if (taskDocs.isNotEmpty) {
                              return Expanded(
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: taskDocs.map((taskDoc) {
                                      final taskData = taskDoc.data() as Map<String, dynamic>;
                                      final taskName = taskData['Nombre'];
                                      final zona = taskData['Zona'];
                                      final ubicacion = taskData['Ubicacion'];
                                      final supervisorId = taskData['SupervisorId'];
                                      final taskId = taskDoc.id;
                                      final completed = taskData['Completada'] ?? false;

                                      return InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => AddTaskScreen(taskData: taskData),
                                            ),
                                          );
                                        },
                                        child: Container(
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
                                            title: Text(taskName),
                                            subtitle: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text('Zona: $zona'),
                                                Text('Ubicación: $ubicacion'),
                                                Text('ID del supervisor: $supervisorId'),
                                              ],
                                            ),
                                            trailing: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                IconButton(
                                                  icon: Icon(
                                                    completed ? Icons.check : Icons.check_box_outline_blank,
                                                    color: completed ? Colors.green : Colors.grey,
                                                  ),
                                                  onPressed: () {
                                                    FirebaseFirestore.instance.collection('task').doc(taskId).update({'Completada': !completed});
                                                  },
                                                ),
                                                IconButton(
                                                  icon: Icon(Icons.delete, color: Colors.red),
                                                  onPressed: () {
                                                    _showDeleteConfirmationDialog(context, taskId);
                                                  },
                                                ),
                                                IconButton(
                                                  icon: Icon(Icons.map, color: Color.fromARGB(255, 0, 0, 0)),
                                                  onPressed: () {
                                                    Navigator.push(context, MaterialPageRoute(builder: (context) => MapMobile()));
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              );
                            } else {
                              return Text('No se encontraron tareas.');
                            }
                          }
                        }
                        return CircularProgressIndicator();
                      },
                    );
                  } else {
                    return Text('Usuario no autenticado.');
                  }
                }
                return CircularProgressIndicator();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, String taskId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar eliminación'),
          content: Text('¿Estás seguro de que quieres eliminar esta tarea?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Eliminar'),
              onPressed: () {
                FirebaseFirestore.instance.collection('task').doc(taskId).delete();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
