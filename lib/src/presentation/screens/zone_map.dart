import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ps_mosquito/colors.dart';

class ZoneMapScreen extends StatefulWidget {
  const ZoneMapScreen({super.key});

  @override
  State<ZoneMapScreen> createState() => _ZoneMapScreenState();
}

class _ZoneMapScreenState extends State<ZoneMapScreen> {
  final _initialCameraPosition = const CameraPosition(
    target: LatLng(-17.031711121280154, -64.86349766064014),
    zoom: 13,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: MyColors.primaryColor,
          title: const Text('Mapa de Puntos'),
        ),
        body: GoogleMap(
            initialCameraPosition: _initialCameraPosition,
            myLocationButtonEnabled: true,
            markers: Set.from([
              Marker(
                markerId: MarkerId('1'),
                position: LatLng(-17.031711121280154, -64.86349766064014),
                infoWindow: const InfoWindow(
                  title: 'Punto 1',
                  snippet: 'Descripción del punto 1',
                ),
              ),
              Marker(
                markerId: MarkerId('2'),
                position: LatLng(-17.032205813571156, -64.85783126037614),
                infoWindow: const InfoWindow(
                  title: 'Punto 2',
                  snippet: 'Descripción del punto 2',
                ),
              ),
              Marker(
                markerId: MarkerId('3'),
                position: LatLng(-17.038935118884243, -64.86486937670652),
                infoWindow: const InfoWindow(
                  title: 'Punto 3',
                  snippet: 'Descripción del punto 3',
                ),
              ),
            ])));
  }
}
