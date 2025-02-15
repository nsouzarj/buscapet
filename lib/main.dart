import 'dart:async';
import 'package:buscapet/caduser.dart';
import 'package:buscapet/classes/classecadastro.dart';
import 'package:buscapet/listapets.dart';
import 'package:buscapet/loginscreen.dart';
import 'package:buscapet/menuprincipal.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'fomulariocadastro.dart';
import 'dart:ui';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/foundation.dart';
import 'package:local_auth/local_auth.dart'; // Importe o pacote de autenticação biométrica

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
      // Define rotas nomeadas para cada tela
      routes: {
        '/splash': (context) => SplashScreen(),
        '/menu': (context) => MenuPrincipal(),
        '/login': (context) => LoginScreen(),
        '/listaPets': (context) => TelaFiltroPet(),
        '/cadastro': (context) => FormularioCadastroPet(),
        '/cadusuario': (context) => CadastroScreen(),
      },
      // Adiciona o suporte para a localização em português do Brasil
      locale: const Locale('pt', 'BR'),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('pt', 'BR'),
      ],
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final LocalAuthentication _localAuth = LocalAuthentication(); // Instância para autenticação biométrica

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    bool biometricEnabled = prefs.getBool('biometricEnabled') ?? false;

    if (isLoggedIn && biometricEnabled) {
      // Verifica se o dispositivo suporta biometria
      bool isBiometricAvailable = await _isBiometricAvailable();
      if (isBiometricAvailable) {
        // Tenta autenticar com biometria
        bool authenticatedWithBiometrics = await _authenticateWithBiometrics();
        if (authenticatedWithBiometrics) {
          // Se autenticado com biometria, navega para o menu principal
          Timer(
            const Duration(seconds: 3),
                () => Navigator.pushReplacementNamed(context, '/menu'),
          );
          return;
        }
      }
    }

    // Caso contrário, navega para a tela de login
    Timer(
      const Duration(seconds: 3),
          () => Navigator.pushReplacementNamed(context, isLoggedIn ? '/menu' : '/login'),
    );
  }

  Future<bool> _isBiometricAvailable() async {
    try {
      bool canCheckBiometrics = await _localAuth.canCheckBiometrics;
      List<BiometricType> availableBiometrics = await _localAuth.getAvailableBiometrics();

      if (canCheckBiometrics && availableBiometrics.isNotEmpty) {
        return true;
      }
    } catch (e) {
      print("Erro ao verificar disponibilidade de biometria: $e");
    }
    return false;
  }

  Future<bool> _authenticateWithBiometrics() async {
    try {
      bool authenticated = await _localAuth.authenticate(
        localizedReason: "Autentique-se para acessar o aplicativo",
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
      return authenticated;
    } catch (e) {
      print("Erro durante a autenticação biométrica: $e");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 300,
              height: 300,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Image.asset(
                  'assets/images/raika1.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}