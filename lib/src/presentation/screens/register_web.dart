// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, avoid_print, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String selectedRole = 'Supervisor'; // Valor inicial del rol

  List<String> roles = ['Supervisor', 'Administrador']; // Opciones del DropdownButton

  Future<void> _register(BuildContext context) async {
    try {
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // Verifica si el registro fue exitoso
      if (userCredential.user != null) {
        final firebaseUser = userCredential.user!;
        await firebaseUser.updateProfile(displayName: selectedRole);

        // Llama a la función para guardar detalles en Firestore
        await _postDetailsToFirestore(emailController.text, selectedRole);

        // Lógica de redirección basada en el rol
        if (selectedRole == 'Supervisor') {
          Navigator.of(context).pushNamed('/menu_mobile');
        } else if (selectedRole == 'Administrador') {
          Navigator.of(context).pushNamed('/menu_web');
        }
      }
    } catch (e) {
      // Handle errores de registro, por ejemplo, correo electrónico ya en uso, contraseña débil, etc.
      print('Error de registro: $e');
    }
  }

  Future<void> _postDetailsToFirestore(String email, String selectedRole) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final userCollection = _firestore.collection('users');

        Map<String, dynamic> userData = {
          'email': email,
          'role': selectedRole,
        };

        await userCollection.doc(user.uid).set(userData);
      }
    } catch (e) {
      print('Error al guardar los detalles en Firestore: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Formulario de Registro',
              style: TextStyle(fontSize: 24.0),
            ),
            _buildTextField(
              hintText: 'E-mail',
              icon: Icons.person,
              controller: emailController,
            ),
            _buildTextField(
              hintText: 'Contraseña',
              icon: Icons.lock,
              isPassword: true,
              controller: passwordController,
            ),
            DropdownButton<String?>(
              value: selectedRole,
              onChanged: (String? newValue) {
                setState(() {
                  selectedRole = newValue!;
                });
              },
              items: roles.map((String role) {
                return DropdownMenuItem<String?>(
                  value: role,
                  child: Text(role),
                );
              }).toList(),
            ),
            ElevatedButton(
              onPressed: () {
                _register(context);
              },
              child: const Text('Registrarse'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    String? hintText,
    IconData? icon,
    bool isPassword = false,
    TextEditingController? controller,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: Icon(icon),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

