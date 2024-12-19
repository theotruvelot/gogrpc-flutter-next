import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

import '../proto/generated/location.pb.dart';
import '../services/location_service.dart';

class LocationProvider with ChangeNotifier {
  final LocationService _locationService = LocationService();
  final List<Location> _locations = [];
  Position? _currentPosition;

  List<Location> get locations => _locations;
  Position? get currentPosition => _currentPosition;

  Future<void> initialize() async {
    await _locationService.initialize();

    _locationService.locationStream.listen((location) {
      _locations.add(location);
      notifyListeners();
    });

    // Démarrer le suivi de la position
    await _startLocationTracking();
  }

  Future<void> _startLocationTracking() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );

    Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position position) {
      _currentPosition = position;
      _locationService.sendLocation(position.latitude, position.longitude);
      notifyListeners();
    });
  }
}
