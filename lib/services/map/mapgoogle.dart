import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';

class MapaScreen extends StatefulWidget {
  final String endereco;
  final String bairro;
  final String cidade;
  final String estado;

  MapaScreen({
    required this.endereco,
    required this.bairro,
    required this.cidade,
    required this.estado,
  });

  @override
  State<MapaScreen> createState() => _MapaScreenState();
}

class _MapaScreenState extends State<MapaScreen> {
  late GoogleMapController _mapController;
  LatLng _currentPosition =
      LatLng(-23.5505, -46.6333); // Ponto inicial padrão (centro de São Paulo)
  bool _mapControllerInitialized = false;

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  Future<LatLng?> _getGeolocation() async {
    try {
      print(
          'Endereço para geocodificação: ${widget.endereco}, ${widget.bairro}, ${widget.cidade}, ${widget.estado}');
      List<Location> locations = await locationFromAddress(
        '${widget.endereco}, ${widget.bairro}, ${widget.cidade}, ${widget.estado}',
      );

      if (locations.isNotEmpty) {
        print(
            'Coordenadas encontradas: ${locations.first.latitude}, ${locations.first.longitude}'); // Imprima as coordenadas para verificar
        return LatLng(locations.first.latitude, locations.first.longitude);
      } else {
        print('Endereço não encontrado.');
        // Exiba um diálogo de erro para o usuário
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text('Erro'),
            content: Text(
                'Não foi possível encontrar o endereço. Por favor, verifique se o endereço está correto.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Fecha o diálogo
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      print('Erro na geocodificação: $e'); // Imprima o erro no console
      // Exiba um diálogo de erro para o usuário
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('Erro'),
          content: Text(
              'Ocorreu um erro ao obter a localização. Por favor, tente novamente mais tarde.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o diálogo
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
    return null; // Retorne nulo se não encontrar as coordenadas
  }

  Future<void> _requestLocationPermission() async {
    // 1. Verificar se a permissão já está concedida
    if (await Permission.location.isGranted) {
      await _getGeolocation();
      return; // Saia da função se a permissão já estiver concedida
    }

    // 2. Verificar se a permissão está negada permanentemente
    var status = await Permission.location.status;
    if (status.isPermanentlyDenied) {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('Permissão de Localização'),
          content: Text(
              'A permissão de localização foi negada permanentemente. Você precisa concedê-la nas configurações do aplicativo.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o diálogo
                openAppSettings(); // Abre as configurações do aplicativo
              },
              child: Text('Abrir Configurações'),
            ),
          ],
        ),
      );
      return; // Saia da função se a permissão estiver negada permanentemente
    }

    // 3. Solicitar permissão se não estiver concedida ou negada permanentemente
    status = await Permission.location.request();
    if (status.isGranted) {
      await _getGeolocation(); // Obtenha a localização se a permissão for concedida
    } else if (status.isDenied) {
      // Permissão negada, exiba um aviso ao usuário
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('Permissão de Localização'),
          content: Text(
              'A permissão de localização é necessária para exibir o mapa. Deseja concedê-la agora?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o diálogo
                _requestLocationPermission(); // Solicita a permissão novamente
              },
              child: Text('Sim'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o diálogo
              },
              child: Text('Não'),
            ),
          ],
        ),
      );
    }
  }

   Widget _buildGoogleMap() {
    if (_mapControllerInitialized) {
      print(
          'Mapa inicializado: _mapControllerInitialized = true'); // Imprima para verificar
      return Container( // Adiciona um Container para a moldura
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.blue, // Cor da moldura
            width: 3, // Largura da moldura
          ),
        ),
        child: GoogleMap(
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
           

          onMapCreated: (GoogleMapController controller) {
            _mapController = controller;
            _mapControllerInitialized = true;
          },
          initialCameraPosition: CameraPosition(
            target: _currentPosition,
            zoom: 15,
            
          ),
          markers: {
            Marker(
              markerId: const MarkerId('local'),
              position: _currentPosition,
              infoWindow: InfoWindow(
                title: '${widget.endereco}',
                snippet: '${widget.cidade}, ${widget.estado}', // Texto resumido
              ),
            ),
          },
        ),
      );
    } else {
      print(
          'Mapa não inicializado: _mapControllerInitialized = false'); // Imprima para verificar
      return Center(child: CircularProgressIndicator());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Localizaçao',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder(
        future: _getGeolocation(), // Aguarda a geocodificação
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            print('Geocodificação em andamento...'); // Imprima para verificar
            return Center(
                child:
                    CircularProgressIndicator()); // Exibe um indicador de carregamento
          } else if (snapshot.hasError) {
            print(
                'Erro na geocodificação: ${snapshot.error}'); // Imprima para verificar
            return Center(
                child: Text(
                    'Erro: ${snapshot.error}')); // Exibe um erro se ocorrer
          } else if (snapshot.hasData) {
            if (snapshot.data != null) {
              // Verifique se as coordenadas foram encontradas
              _currentPosition = snapshot.data!; // Define as coordenadas
            }
            print('Geocodificação concluída'); // Imprima para verificar
            // Renderize o GoogleMap mesmo se as coordenadas não forem encontradas
            // para inicializar o _mapController
            _mapControllerInitialized = true;
            return _buildGoogleMap(); // Renderiza o mapa apenas após a geocodificação estar concluída
          } else {
             _mapControllerInitialized = false;
            print(
                 
                'Geocodificação não encontrou resultados'); // Imprima para verificar
            return Center(
                child: Text(
                    'Nenhum endereço encontrado')); // Mensagem se não encontrar endereço
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }
}
