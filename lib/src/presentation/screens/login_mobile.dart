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
  final _formKey = GlobalKey<FormState>();

  String? emailError;
  String? passwordError;
  String? loginError;
  bool obscurePassword = true; // Controla la visibilidad de la contraseña

  Future<void> _signIn(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      try {
        final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        // Verifica si el inicio de sesión fue exitoso
        if (userCredential.user != null) {
          final firebaseUser = userCredential.user!;

          // Obtiene el rol del usuario desde Firebase Custom Claims
          String? role = firebaseUser.displayName;

          if (role == null) {
            // Si el usuario no tiene un rol asignado, se le asigna "Supervisor" de forma predeterminada
            role = "Supervisor";
          }

          await firebaseUser.reload(); // Recarga la información del usuario
          await firebaseUser.getIdTokenResult(true); // Obtiene el token actualizado

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
        // Mostrar mensaje de error genérico o específico según el tipo de error.
        if (e is FirebaseAuthException) {
          if (e.code == 'user-not-found') {
            setState(() {
              emailError = 'Usuario no encontrado';
            });
          } else if (e.code == 'wrong-password') {
            setState(() {
              passwordError = 'Contraseña incorrecta';
              loginError = 'Usuario o contraseña incorrecta'; // Mensaje de error adicional
            });
          } else {
            // Otro tipo de error
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF4EA674),
        title: Text('Inicio de Sesión'), // Establece el título de la pantalla
      ),
      body: Form(
        key: _formKey,
        child: Stack(
          children: [
            Container(
              color: Color.fromARGB(255, 112, 173, 139), // Fondo de color
              width: double.infinity,
              height: double.infinity,
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Agrega tu logotipo aquí
                  Image.asset(
                    'assets/images/logo_mosquito.png', // Ruta de tu logotipo
                    width: 120.0,
                  ),
                  const SizedBox(height: 20.0), // Espacio entre el logotipo y otros elementos

                  // Resto del código de inicio de sesión (campos de entrada, botones, etc.)
                  _buildTextField(
                    hintText: 'E-mail',
                    icon: Icons.person,
                    controller: emailController,
                    errorText: emailError,
                  ),
                  const SizedBox(height: 10.0),
                  _buildTextField(
                    hintText: 'Contraseña',
                    icon: Icons.lock,
                    isPassword: obscurePassword, // Usa el estado de visibilidad de la contraseña
                    controller: passwordController,
                    errorText: passwordError,
                  ),
                  const SizedBox(height: 20.0),
                  if (loginError != null)
                    Text(
                      loginError!,
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  _buildLoginButton(context),
                  const SizedBox(height: 10.0),
                  _buildForgotPasswordButton(context),
                ],
              ),
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
    String? errorText,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: TextFormField(
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
          errorText: errorText,
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    obscurePassword ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      obscurePassword = !obscurePassword;
                    });
                  },
                )
              : null,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Este campo es obligatorio';
          }
          return null;
        },
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
      child: Text(
        'Iniciar Sesión',
        style: TextStyle(fontSize: 18.0, color: Colors.black),
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
          color: Color.fromARGB(255, 255, 255, 255),
        ),
      ),
    );
  }
}
