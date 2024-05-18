import 'package:buscapet/caduser.dart';
import 'package:buscapet/classesutils/utilspet.dart';
import 'package:buscapet/recuperasenha.dart';
import 'package:buscapet/services/cadastroservice.dart';
import 'package:buscapet/menuprincipal.dart';
import 'package:buscapet/services/usuarioservice.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Tela de login para o aplicativo Buscapet.
///
/// Esta tela permite que os usuários façam login com seu email e senha.
/// Também fornece opções para cadastrar uma nova conta ou recuperar uma senha esquecida.
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  ValidaEmail _validaEmail = ValidaEmail();


  UsuaroService serv = UsuaroService();

  /// Lida com a tentativa de login do usuário.
  ///
  /// Valida os dados do formulário, autentica o usuário usando [ServicePet.verifyUserCad]
  /// e navega para a tela do menu se a autenticação for bem-sucedida.
  /// Exibe uma caixa de diálogo de erro se a autenticação falhar.
  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      String email = _emailController.text;
      String password = _passwordController.text;
      bool isAuthenticated = await serv.verifyUserCad(email, password);
      if (isAuthenticated) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        Navigator.pushReplacementNamed(context, '/menu');
      } else {
        _showErrorDialog("Erro de autenticação", "Email ou senha inválidos.");
      }
    }
  }

  /// Exibe uma caixa de diálogo de erro com o título e a mensagem especificados.
  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            style: TextStyle(color: Colors.black, fontSize: 18),
          ),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira seu email';
                  }
                  if (!_validaEmail.validarEmail(value)) {
                    return 'E-Mail inválido';
                  }

                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                style: TextStyle(
                    backgroundColor: Colors.black, color: Colors.black),
                decoration: InputDecoration(labelText: 'Senha'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira sua senha';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _handleLogin,
                child: Text("Entrar"),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  // Navegar para a tela de cadastro de usuário
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CadastroScreen(),
                    ),
                  );
                },
                child: Text("Cadastre sua conta"),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  // Navegar para a tela de cadastro de usuário

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ForgotPasswordScreen(),
                    ),
                  );
                },
                child: Text("Esqueceu a senha?"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Verifica o estado de login do usuário.
///
/// Retorna `true` se o usuário estiver logado, caso contrário, retorna `false`.
Future<bool> checkLoginStatus() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool('isLoggedIn') ?? false;
}
