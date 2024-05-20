import 'package:buscapet/classes/classecadastro.dart';
import 'package:buscapet/classesutils/utilspet.dart';
import 'package:buscapet/services/buscapetservice.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart'; // Import geolocator package

// Global Class (example, adjust as needed)

// Custom Exception Class
class NetworkError implements Exception {
  final String message;
  NetworkError(this.message);

  @override
  String toString() => 'NetworkError: $message';
}

class MapaScreenGeral extends StatefulWidget {
  @override
  State<MapaScreenGeral> createState() => _MapaScreenGeralState();
}

class _MapaScreenGeralState extends State<MapaScreenGeral> {
  Global global = Global();
  BuscapetService buscapetService = BuscapetService();
  // BuscapetService buscaService = BuscapetService();
  LatLng _currentPosition = LatLng(-23.5505, -46.6333); // Ponto inicial padrão (centro de São Paulo)
  bool _mapControllerInitialized = false;

  late GoogleMapController _mapController;
  LatLng? _firstLocation; // Declare _firstLocation as nullable

  Set<Marker> _markers = {};

  List<CadastroPet> enderecos = [];

  @override
  void initState() {
    super.initState();
    _fetchEnderecos();
    _determinePosition(); // Request location permission and get current location
  }

  // Function to request location permission and get current location
  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, don't continue
      // Show an alert dialog to the user asking to enable location services
      return;
    }

    // Check for location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, don't continue
        // Show an alert dialog to the user asking to allow location permissions
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      // Show an alert dialog to the user asking to change permission settings
      return;
    }

    // When we reach here, the user has granted permission
    // Now, fetch the position
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    // Update the current position
    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
    });
  }

  _fetchEnderecos() async {
    try {
      enderecos = await buscapetService.getPetList();
      await _moveMapToFirstAddress(enderecos);
    } catch (e) {
      // Handle errors here, e.g., display an error message
      print('Erro ao obter endereços: $e');
      if (e is NetworkError) {
        // Handle network errors specifically
        // Example: Show a SnackBar with the error message
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.message),
        ));
      } else {
        // Handle other errors (e.g., JSON parsing errors)
        // Example: Show a dialog with the error message
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Erro'),
            content: Text(e.toString()),
          ),
        );
      }
    }
  }

  Future<void> _moveMapToFirstAddress(List<CadastroPet> enderecos) async {
    for (var endereco in enderecos) {
      try {
        List<Location> locations = await locationFromAddress(
          '${endereco.endereco}, ${endereco.bairro}, ${endereco.cidade}, ${endereco.estado}',
        );

        if (locations.isNotEmpty) {
          _firstLocation =
              LatLng(locations.first.latitude, locations.first.longitude);
          _mapControllerInitialized = true; // Assign to _firstLocation
          _markers.add(Marker(
            markerId: MarkerId(endereco.endereco),
            position: _firstLocation!, // Use _firstLocation here
            infoWindow: InfoWindow(
              title: endereco.nomeAnimal, // '${endereco.nomeAnimal}, ${endereco.situacao}',
              snippet: '${endereco.endereco}, ${endereco.cidade}',
            ),
          ));

          // Move the map to the first location found
          if (_mapControllerInitialized) {
            _mapController.animateCamera(CameraUpdate.newCameraPosition(
              CameraPosition(
                target: _firstLocation!, // Use _firstLocation here
                zoom: 11.0, // Adjust zoom level as needed
              ),
            ));
          }
          break; // Exit the loop after finding the first valid address
        } else {
          // Handle the case where the address conversion fails
          print('Endereço não encontrado: ${endereco.endereco}');
          // You can add error handling here (e.g., display an error message)
        }
      } catch (e) {
        print('Erro ao obter localização: $e');
        // Handle the error (e.g., display an error message)
      }
    }

    // Add markers for all other addresses
    for (var endereco in enderecos) {
      try {
        List<Location> locations = await locationFromAddress(
          '${endereco.endereco}, ${endereco.bairro}, ${endereco.cidade}, ${endereco.estado}',
        );

        if (locations.isNotEmpty) {
          LatLng location =
              LatLng(locations.first.latitude, locations.first.longitude);
          _markers.add(Marker(
            markerId: MarkerId(endereco.endereco),
            position: location,
            infoWindow: InfoWindow(
              title: endereco.nomeAnimal + '-' + endereco.situacao + '(A)',
              snippet: '${endereco.endereco}, ${endereco.cidade}',
            ),
          ));
        } else {
          // Handle the case where the address conversion fails
          print('Endereço não encontrado: ${endereco.endereco}');
          // You can add error handling here (e.g., display an error message)
        }
      } catch (e) {
        print('Erro ao obter localização: $e');
        // Handle the error (e.g., display an error message)
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mapa de Pets'),
      ),
      body: GoogleMap(
        compassEnabled: true,
        mapToolbarEnabled: true,
        myLocationEnabled: true,
        buildingsEnabled: true,
        indoorViewEnabled: true,
        tiltGesturesEnabled: true,
        trafficEnabled: true,
        rotateGesturesEnabled: true,
        zoomGesturesEnabled: true,
        scrollGesturesEnabled: true,
        initialCameraPosition: CameraPosition(
          target: _currentPosition, // Use the determined position
          zoom: 15.0, // Adjust the zoom level as needed
        ),
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
          _mapControllerInitialized = true;
        },
        markers: _markers,
      ),
    );
  }
}