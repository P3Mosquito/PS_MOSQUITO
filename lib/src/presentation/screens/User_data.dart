// ignore_for_file: library_private_types_in_public_api, prefer_final_fields, file_names, use_super_parameters

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserData extends StatefulWidget {
  const UserData({Key? key}) : super(key: key);

  @override
  _UserDataState createState() => _UserDataState();
}

class _UserDataState extends State<UserData> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  void _getCurrentUser() {
    final user = _auth.currentUser;
    if (user != null) {
      setState(() {
        _currentUser = user;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4EA674),
        title: const Text(
          'Perfil de Usuario',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: const <Widget>[
        ],
      ),
      body: _currentUser != null
          ? FutureBuilder<DocumentSnapshot>(
              future: _firestore.collection('users').doc(_currentUser!.uid).get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }
                if (snapshot.hasData) {
                  final userData = snapshot.data!.data() as Map<String, dynamic>;
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          leading: const Icon(Icons.person),
                          title: Text('Name: ${userData['name']}'),
                        ),
                        ListTile(
                          leading: const Icon(Icons.person),
                          title: Text('Last Name: ${userData['lastname']}'),
                        ),
                        ListTile(
                          leading: const Icon(Icons.email),
                          title: Text('Email: ${_currentUser!.email}'),
                        ),
                        ListTile(
                          leading: const Icon(Icons.work),
                          title: Text('Position: ${userData['position']}'),
                        ),
                        ListTile(
                          leading: const Icon(Icons.security),
                          title: Text('Role: ${userData['role']}'),
                        ),
                      ],
                    ),
                  );
                }
                return const Center(
                  child: Text('User data not found.'),
                );
              },
            )
          : const Center(
              child: Text('User not logged in.'),
            ),
    );
  }
}
