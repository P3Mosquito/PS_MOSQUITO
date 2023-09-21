import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fondo de imagen
          Image.asset(
            'assets/images/ciudad.jpg', // Ruta de la imagen
            fit: BoxFit.cover, // Ajustar la imagen para cubrir todo el fondo
            width: double
                .infinity, // Ancho de la imagen igual al ancho de la pantalla
            height: double
                .infinity, // Alto de la imagen igual al alto de la pantalla
          ),
          Container(
            color:
                Colors.transparent, // Hacer que el contenedor sea transparente
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Contenedor para el logotipo (aumenta la altura)
                    Container(
                      padding: const EdgeInsets.all(30.0), // Aumenta el padding
                      child: Image.asset(
                        'assets/images/logo_mosquito.png',
                        height: 120.0, // Aumenta la altura del logotipo
                      ),
                    ),
                    // Contenedor blanco con título y otros elementos
                    Container(
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: const Color(
                            0xFFD7D9D7), // Cambiar el color del Container a #D7D9D7
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Column(
                        children: [
                          // Título
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
                          ),
                          const SizedBox(height: 10.0),
                          _buildTextField(
                            hintText: 'Contraseña',
                            icon: Icons.lock,
                            isPassword: true,
                          ),
                          const SizedBox(height: 20.0),
                          _buildLoginButton(context),
                          const SizedBox(height: 10.0),
                          _buildForgotPasswordButton(),
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
}

Widget _buildTextField(
    {String? hintText, IconData? icon, bool isPassword = false}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 20.0),
    child: TextField(
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

Widget _buildLoginButton(context) {
  return ElevatedButton(
    onPressed: () {
      // Crea una instancia de NewPage y navega a ella
      //Navigator.of(context).pushNamed('/menu_mobile');
      Navigator.of(context).pushNamed('/menu_mobile');
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

Widget _buildForgotPasswordButton() {
  return TextButton(
    onPressed: () {
      // Agrega tu lógica para manejar el olvido de contraseña aquí.
    },
    child: const Text(
      'Olvidaste tu contraseña',
      style: TextStyle(
        fontSize: 16.0,
        color: Colors.blue,
      ),
    ),
  );
}
