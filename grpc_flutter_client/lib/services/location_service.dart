import 'dart:async';

import 'package:grpc/grpc.dart';
import 'package:grpc_flutter_client/proto/generated/location.pbgrpc.dart';

class LocationService {
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();

  ClientChannel? _channel;
  LocationServiceClient? _client;
  StreamSubscription? _locationSubscription;
  final _locationController = StreamController<Location>.broadcast();

  Stream<Location> get locationStream => _locationController.stream;

  Future<void> initialize() async {
    _channel = ClientChannel(
      'localhost', // Remplacez par l'IP de votre serveur
      port: 50051,
      options: const ChannelOptions(
        credentials: ChannelCredentials.insecure(),
      ),
    );

    _client = LocationServiceClient(_channel!);
  }

  Future<void> sendLocation(double latitude, double longitude) async {
    final location = Location()
      ..latitude = latitude
      ..longitude = longitude;

    try {
      final response = await _client!.sendLocation(location);
      print('Location envoyée: ${response.message}');
    } catch (e) {
      print('Erreur lors de l\'envoi: $e');
    }
  }

  void dispose() {
    _locationSubscription?.cancel();
    _channel?.shutdown();
    _locationController.close();
  }
}
