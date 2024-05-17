import 'dart:async';
import 'package:buscapet/listapets.dart';
import 'package:flutter/material.dart';
import 'fomulariocadastro.dart';
import 'dart:ui';

import 'graficos/graficos.dart';

class MenuPrincipal extends StatefulWidget {
  @override
  State<MenuPrincipal> createState() => _MenuPrincipalState();
}

class _MenuPrincipalState extends State<MenuPrincipal> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Busca Pet', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
      ),
      drawer: Drawer(
        width: 350,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(

              duration: Duration(seconds: 20),
              decoration: BoxDecoration(
                color: Colors.black, shape: BoxShape.rectangle      
              ),
          
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.pets),
              title: Text('Cadastrar Pet'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) =>FormularioCadastroPet()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.search),
              title: Text('Buscar Pet'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => TelaFiltroPet()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.auto_graph),
              title: Text('Grafico Atual'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => PizzaChartExample()),
                );
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        // Added SingleChildScrollView
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(
              horizontal: 20), // Add padding for better spacing
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                Image.asset(
                  'assets/images/gato1.jpg',
                  width: 250,
                  height: 250,
                  fit: BoxFit.contain, // Control image fit
                ),
                SizedBox(height: 20),
                ElevatedButton.icon(
                  icon: Icon(Icons.pets, size: 40, color: Colors.greenAccent),
                  label: Text(
                    'Cadastrar Pet',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => FormularioCadastroPet()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                ),
                SizedBox(height: 30),
                ElevatedButton.icon(
                  icon: Icon(Icons.search, size: 40, color: Colors.deepOrange),
                  label: Text(
                    'Buscar Pet',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => TelaFiltroPet()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Versão 1.0 - 2024',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white
                  ),
                ),
                SizedBox(height: 20), // Add bottom padding to avoid overflow
              ],
            ),
          ),
        ),
      ),
    );
  }
}
