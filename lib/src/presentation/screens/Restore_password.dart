// ignore_for_file: file_names, library_private_types_in_public_api, use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController emailController = TextEditingController();

  Future<void> _resetPassword(BuildContext context) async {
    try {
      await _auth.sendPasswordResetEmail(email: emailController.text);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Se ha enviado un correo electrónico para restablecer la contraseña.'),
      ));
    } catch (e) {
      print('Error al enviar el correo electrónico de restablecimiento de contraseña: $e');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Hubo un error al enviar el correo electrónico de restablecimiento de contraseña.'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4EA674), // Color de fondo de la AppBar
        title: const Text('Restablecer Contraseña'),
        centerTitle: true,
      ),
      backgroundColor: const Color.fromARGB(255, 112, 173, 139), // Color de fondo de la pantalla completa
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: const Color(0xFFD7D9D7), // Color de fondo del contenedor
              borderRadius: BorderRadius.circular(20.0),
            ),
            width: MediaQuery.of(context).size.width * 0.85,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/llave.png', // Ruta de la imagen
                  height: 100.0, // Altura de la imagen
                  width: 100.0, // Ancho de la imagen
                ),
                const SizedBox(height: 20.0),
                const Text(
                  'Introduce tu correo electrónico',
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20.0),
                const Text(
                  'Ingresa el correo electrónico asociado a tu cuenta para restablecer la contraseña.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16.0),
                ),
                const SizedBox(height: 20.0),
                _buildTextField(
                  hintText: 'E-mail',
                  icon: Icons.email,
                  controller: emailController,
                ),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {
                    _resetPassword(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4EA674), // Color de fondo del botón
                    padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 15.0),
                  ),
                  child: const Text(
                    'Enviar correo',
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    String? hintText,
    IconData? icon,
    TextEditingController? controller,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: TextField(
        controller: controller,
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
