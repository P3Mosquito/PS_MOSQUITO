// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, avoid_print, use_super_parameters, deprecated_member_use, prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:location/location.dart';

class MenuMobile extends StatefulWidget {
  const MenuMobile({Key? key}) : super(key: key);

  @override
  _MenuMobileState createState() => _MenuMobileState();
}

class _MenuMobileState extends State<MenuMobile> with TickerProviderStateMixin {
  bool showImage = false;

  late AnimationController _rotateController;
  late Animation<double> _rotateAnimation;

  final Location location = Location();

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

    _checkAndRequestLocationPermission();
  }

  @override
  void dispose() {
    _rotateController.dispose();
    super.dispose();
  }

  Future<void> _checkAndRequestLocationPermission() async {
    bool serviceEnabled;
    PermissionStatus permissionStatus;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionStatus = await location.hasPermission();
    if (permissionStatus == PermissionStatus.denied) {
      permissionStatus = await location.requestPermission();
      if (permissionStatus != PermissionStatus.granted) {
        return;
      }
    }
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', false);
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4EA674),
        title: const Text(
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
            color: const Color.fromARGB(255, 112, 173, 139),
          ),
          Positioned(
            top: 60,
            left: 20,
            right: 20,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFD7D9D7),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
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
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.person),
                  const SizedBox(width: 8),
                  Text(
                    FirebaseAuth.instance.currentUser?.email ?? 'Usuario',
                    style: const TextStyle(
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
            left: 30,
            right: 30,
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: const Color(0xFFD7D9D7),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/look_task');
                    },
                    style: ElevatedButton.styleFrom(
                      primary: const Color(0xFF4EA674),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 60,
                        vertical: 20,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.task,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Tareas',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/storage');
                    },
                    style: ElevatedButton.styleFrom(
                      primary: const Color(0xFF4EA674),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 60,
                          vertical: 20), // Adjust the button width here
                    ),
                    child: const Text(
                      'Cerrar Sesión',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      //
                      Navigator.of(context).pushNamed('/zone_map');
                    },
                    style: ElevatedButton.styleFrom(
                      primary: const Color(0xFF99BF9C),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 60,
                          vertical: 20), // Adjust the button width here
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.cloud_off,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Tarea sin conexión',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/User_data');
                    },
                    style: ElevatedButton.styleFrom(
                      primary: const Color(0xFF4EA674),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 60,
                        vertical: 20,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.person,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Perfil del Usuario',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _signOut,
                    style: ElevatedButton.styleFrom(
                      primary: const Color(0xFF4EA674),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 60,
                        vertical: 20,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.logout,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Cerrar Sesión',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
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
