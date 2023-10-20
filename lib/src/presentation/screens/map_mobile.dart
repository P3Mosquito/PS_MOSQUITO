import 'package:flutter/material.dart';


class MapMobile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF4EA674), // Cambio del color de fondo de la AppBar
        title: Text(
          'Mapa',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white, // Color del título de la AppBar
          ),
        ),
      ),
    );
  }
}