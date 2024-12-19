import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import 'providers/location_provider.dart';

void main() {
  try {
    runApp(
      ChangeNotifierProvider(
        create: (context) => LocationProvider(),
        child: const MyApp(),
      ),
    );
  } catch (e) {
    print(e);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Location Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MapScreen(),
    );
  }
}

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    Provider.of<LocationProvider>(context, listen: false).initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location Tracker'),
      ),
      body: Consumer<LocationProvider>(
        builder: (context, locationProvider, child) {
          if (locationProvider.currentPosition == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final currentPosition = LatLng(
            locationProvider.currentPosition!.latitude,
            locationProvider.currentPosition!.longitude,
          );

          return GoogleMap(
            initialCameraPosition: CameraPosition(
              target: currentPosition,
              zoom: 15,
            ),
            markers: _createMarkers(locationProvider),
            onMapCreated: (GoogleMapController controller) {},
          );
        },
      ),
    );
  }

  Set<Marker> _createMarkers(LocationProvider provider) {
    _markers.clear();

    // Marqueur pour notre position
    if (provider.currentPosition != null) {
      _markers.add(
        Marker(
          markerId: const MarkerId('current_location'),
          position: LatLng(
            provider.currentPosition!.latitude,
            provider.currentPosition!.longitude,
          ),
          infoWindow: const InfoWindow(title: 'Ma position'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      );
    }

    // Marqueurs pour les autres appareils
    for (var location in provider.locations) {
      _markers.add(
        Marker(
          markerId: const MarkerId("1"),
          position: LatLng(location.latitude, location.longitude),
          infoWindow: const InfoWindow(title: 'Location'),
        ),
      );
    }

    return _markers;
  }
}
