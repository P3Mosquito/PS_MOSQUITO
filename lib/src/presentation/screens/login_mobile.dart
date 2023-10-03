import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> _signIn(BuildContext context) async {
    try {
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // Verifica si el inicio de sesión fue exitoso
      if (userCredential.user != null) {
        // Obtiene el rol del usuario desde Firebase Custom Claims
        final firebaseUser = userCredential.user!;
        await firebaseUser.reload(); // Recarga la información del usuario
        await firebaseUser.getIdTokenResult(true); // Obtiene el token actualizado
        final role = firebaseUser.displayName;

        // Lógica de redirección basada en el rol
        if (role == 'Supervisor') {
          Navigator.of(context).pushNamed('/menu_mobile');
        } else if (role == 'Administrador') {
          Navigator.of(context).pushNamed('/menu_web');
        }
      }
    } catch (e) {
      // Handle errores de inicio de sesión, por ejemplo, credenciales incorrectas.
      print('Error de inicio de sesión: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/images/ciudad.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Container(
            color: Colors.transparent,
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(30.0),
                      child: Image.asset(
                        'assets/images/logo_mosquito.png',
                        height: 120.0,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD7D9D7),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Bienvenido a Mosquito',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          _buildTextField(
                            hintText: 'E-mail',
                            icon: Icons.person,
                            controller: emailController,
                          ),
                          const SizedBox(height: 10.0),
                          _buildTextField(
                            hintText: 'Contraseña',
                            icon: Icons.lock,
                            isPassword: true,
                            controller: passwordController,
                          ),
                          const SizedBox(height: 20.0),
                          _buildLoginButton(context),
                          const SizedBox(height: 10.0),
                          _buildCreateAccountButton(context),
                          const SizedBox(height: 10.0),
                          _buildForgotPasswordButton(context),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
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

  Widget _buildLoginButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        _signIn(context);
      },
      style: ElevatedButton.styleFrom(
        primary: Color(0xFF4EA674),
        padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
      child: const Text(
        'Iniciar Sesión',
        style: TextStyle(fontSize: 18.0, color: Colors.black),
      ),
    );
  }

  Widget _buildCreateAccountButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.of(context).pushNamed('/register_web');
      },
      child: const Text(
        'Crear Cuenta',
        style: TextStyle(
          fontSize: 16.0,
          color: Colors.blue,
        ),
      ),
    );
  }

  Widget _buildForgotPasswordButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.of(context).pushNamed('/Restore_password');
      },
      child: const Text(
        '¿Olvidaste tu contraseña?',
        style: TextStyle(
          fontSize: 16.0,
          color: Colors.blue,
        ),
      ),
    );
  }
}
