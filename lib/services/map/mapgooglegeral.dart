import 'package:buscapet/classes/classecadastro.dart';
import 'package:buscapet/classesutils/utilspet.dart';
import 'package:buscapet/fotospets.dart';
import 'package:buscapet/services/buscapetservice.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart'; // Import geolocator package
import 'package:url_launcher/url_launcher.dart'; // Import url_launcher package

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

  LatLng? _currentPosition; // Now nullable, as it might be null initially
  bool _mapControllerInitialized = false;
  late GoogleMapController _mapController;

  Set<Marker> _markers = {};

  List<CadastroPet> enderecos = [];

  // State variable to control the visibility of the custom info window
  bool _showCustomInfoWindow = false;
  CadastroPet? _selectedPet;

  @override
  void initState() {
    super.initState();
    _fetchEnderecos();
    // Call _determinePosition() after the initState is finished
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _determinePosition();
    });
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
      // Move the map to the current position after getting GPS data
      if (_mapControllerInitialized && _currentPosition != null) {
        _mapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
            target: _currentPosition!,
            zoom: 14.0, // Adjust zoom level as needed
          ),
        ));
      }
    });
  }

  _fetchEnderecos() async {
    try {
      enderecos = await buscapetService.getPetList();
      // Add markers after fetching addresses, even if _currentPosition is not yet available
      _addMarkersForAddresses();
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

  void _addMarkersForAddresses() async {
    // Add markers for all addresses
    for (var endereco in enderecos) {
      String tipo = endereco.tipo;
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
            // Use a custom icon for the marker, if you want
            // icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
            infoWindow: InfoWindow(
              title: endereco.nomeAnimal,
              snippet: 'Toque aqui para ver os detalhes',
              onTap: () {
                // Show the custom info window
                setState(() {
                  _showCustomInfoWindow = true;
                  _selectedPet = endereco;
                });
              },
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

  // Function to open the email app with the specified email address
  void _openEmailApp(String email) async {
    // Create the email URL
    String emailUri = 'mailto:$email';

    // Check if the device can open the URL
    if (await canLaunch(emailUri)) {
      // Launch the email app
      await launch(emailUri);
    } else {
      // Handle the case where the device cannot open the email app
      print('Unable to open email app.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mapa de Pets'),
      ),
      body: Stack(
        children: [
          GoogleMap(
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
              target: _currentPosition ??
                  LatLng(-23.5505,
                      -46.6333), // Use the determined position or default if null
              zoom: 14.0, // Adjust the zoom level as needed
            ),
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
              _mapControllerInitialized = true;
              // Move the map to the current position if it's available now
              if (_currentPosition != null) {
                _mapController.animateCamera(CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: _currentPosition!,
                    zoom: 14.0, // Adjust zoom level as needed
                  ),
                ));
              }
            },
            markers: _markers,
          ),
          // Custom Info Window
          if (_showCustomInfoWindow && _selectedPet != null)
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Situação: ' + _selectedPet!.situacao + '(A)',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0,
                        color: Colors.blue, // Customize text color
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Tipo: ' + _selectedPet!.tipo,
                      style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.black), // Customize text color
                    ),
                    Text(
                      'Endereço: ' +
                          ' ${_selectedPet!.endereco}, ${_selectedPet!.cidade}',
                      style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.black), // Customize text color
                    ),
                    Text(
                      'Contato: ' + _selectedPet!.nomeTutor,
                      style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.black), // Customize text color
                    ),
                    Text(
                      'Telefone: ' + _selectedPet!.celular,
                      style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.black), // Customize text color
                    ),
                    // Wrap the email text with GestureDetector
                    GestureDetector(
                      onTap: () {
                        // Open the email app when the email text is tapped
                        // _openEmailApp(_selectedPet!.email);
                        launch('mailto:${_selectedPet!.email}');
                      },
                      child: Text(
                        'E-Email: ' + _selectedPet!.email,
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    Text(
                      'Nota: ' + _selectedPet!.descricao,
                      style: TextStyle(
                          fontSize: 12.0,
                          color: Color.fromARGB(
                              255, 218, 12, 12)), // Customize text color
                    ),

                    SizedBox(height: 16.0),
                    Row(children: [
                      ElevatedButton(
                        onPressed: () {
                          // Close the custom info window
                          setState(() {
                            _showCustomInfoWindow = false;
                            _selectedPet = null;
                          });
                        },
                        child: Text('Fechar'),
                      ),
                      SizedBox(width: 16),
                      ElevatedButton.icon(
                        icon: Icon(
                          Icons.camera,
                          color: Colors.blue,
                          size: 30,
                        ),
                        onPressed: () {
                          List<String> caminho = [];
                          if (_selectedPet!.imagens.length > 0) {
                            for (var petlista in _selectedPet!.imagens) {
                              petlista.nomeArquivo.toString();
                              caminho.add(
                                  "${global.urlGeral}/pet/imagem/${petlista.nomeArquivo}");
                            }
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TelaDetalhe(
                                  imageUrls: caminho,
                                ),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text('Pet não possui foto cadastrada.',style: TextStyle(color: Colors.red)),
                                backgroundColor: Color.fromARGB(255, 91, 111, 128),
                              ),
                            );
                          }
                        },
                        label: Text('(+) Fotos.'),
                      ),
                    ]),

                    SizedBox(height: 16.0),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
