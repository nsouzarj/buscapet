import 'dart:async';
import 'package:buscapet/classes/classecadastro.dart';
import 'package:buscapet/listapets.dart';
import 'package:buscapet/loginscreen.dart';
import 'package:buscapet/menuprincipal.dart';
import 'package:flutter/material.dart';
import 'fomulariocadastro.dart';
import 'dart:ui';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MaterialApp(
    home: SplashScreen(),
    debugShowCheckedModeBanner: false,
    // Define rotas nomeadas para cada tela
    routes: {
      '/splash': (context) => SplashScreen(),
      '/menu': (context) => MenuPrincipal(),
      '/login': (context) => LoginScreen(),
      '/listaPets': (context) => TelaFiltroPet(),
      '/cadastro': (context) => FormularioCadastroPet(),
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
  ));
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    Timer(
      const Duration(seconds: 3),
      () => Navigator.pushReplacementNamed(
          context, isLoggedIn ? '/menu' : '/login'), // Navega para a tela correta
    );
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