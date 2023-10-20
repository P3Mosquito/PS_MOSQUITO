import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MenuMobile extends StatefulWidget {
  @override
  _MenuMobileState createState() => _MenuMobileState();
}

class _MenuMobileState extends State<MenuMobile> with TickerProviderStateMixin {
  bool showImage = false;

  late AnimationController _rotateController;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();

    _rotateController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        showImage = true;
      });
      _rotateController.forward();
    });

    _rotateAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * 3.141592653589793,
    ).animate(_rotateController);
  }

  @override
  void dispose() {
    _rotateController.dispose();
    super.dispose();
  }

  Future<void> _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      // Redirige a la pantalla de inicio de sesión o a donde desees después del cierre de sesión.
      Navigator.of(context).pushReplacementNamed('/login');
    } catch (e) {
      print("Error al cerrar sesión: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF4EA674),
        title: Text(
          'Menú',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            color: Color.fromARGB(255, 112, 173, 139), // Fondo de color
          ),
          Positioned(
            top: 60,
            left: 20,
            right: 20,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color(0xFFD7D9D7),
                borderRadius: BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  AnimatedBuilder(
                    animation: _rotateController,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: _rotateAnimation.value,
                        child: Visibility(
                          visible: showImage,
                          child: Image.asset(
                            'assets/images/logo_mosquito.png',
                            width: 100,
                            height: 100,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Mosquito Captura y Analiza',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 5,
            left: 10,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.person),
                  SizedBox(width: 8),
                  Text(
                    FirebaseAuth.instance.currentUser?.email ?? 'Usuario',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 300,
            left: 20,
            right: 20,
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                color: Color(0xFFD7D9D7),
                borderRadius: BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/look_task');
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFF4EA674),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 60,
                        vertical: 20,
                      ),
                    ),
                    child: Text(
                      'Tareas',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/map_mobile');
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFF4EA674),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 60,
                        vertical: 20,
                      ),
                    ),
                    child: Text(
                      'Mapa',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _signOut,
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFF4EA674),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 60,
                        vertical: 20,
                      ),
                    ),
                    child: Text(
                      'Cerrar Sesión',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
