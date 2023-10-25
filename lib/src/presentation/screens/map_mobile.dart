import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapMobile extends StatefulWidget {
  const MapMobile({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MapMobileState createState() => _MapMobileState();
}

class _MapMobileState extends State<MapMobile> {
  GoogleMapController? _controller;
  LocationData? _locationData;

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  void _getLocation() async {
    Location location = Location();
    bool serviceEnabled = await location.serviceEnabled();

    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    _locationData = await location.getLocation();

    if (mounted) {
      setState(() {
        _goToLocation(LatLng(_locationData!.latitude!, _locationData!.longitude!));
      });
    }
  }

  void _goToLocation(LatLng location) {
    _controller?.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: location, zoom: 15.0),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4EA674),
        title: const Text(
          'Google Maps',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: GoogleMap(
        onMapCreated: (controller) {
          _controller = controller;
        },
        initialCameraPosition: const CameraPosition(
          target: LatLng(0, 0), // Ubicación inicial (se actualizará con la ubicación real)
          zoom: 15.0,
        ),
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
    );
  }
}
