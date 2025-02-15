import 'package:buscapet/caduser.dart';
import 'package:buscapet/classesutils/utilspet.dart';
import 'package:buscapet/recuperasenha.dart';
import 'package:buscapet/services/cadastroservice.dart';
import 'package:buscapet/menuprincipal.dart';
import 'package:buscapet/services/usuarioservice.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_auth/local_auth.dart'; // Importe o pacote de autenticação biométrica

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
  final LocalAuthentication _localAuth = LocalAuthentication(); // Instância para autenticação biométrica

  /// Lida com a tentativa de login do usuário.
  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      String email = _emailController.text;
      String password = _passwordController.text;
      bool isAuthenticated = await serv.verifyUserCad(email, password);
      if (isAuthenticated) {
        SharedPreferences prefs = await SharedPreferences.getInstance();

        // Verificar se o dispositivo suporta biometria
        bool isBiometricAvailable = await _isBiometricAvailable();
        if (isBiometricAvailable) {
          bool useBiometrics = await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Ativar Biometria"),
                content: Text("Deseja ativar o login com biometria?"),
                actions: <Widget>[
                  TextButton(
                    child: Text("Não"),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                  ),
                  TextButton(
                    child: Text("Sim"),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                  ),
                ],
              );
            },
          );

          if (useBiometrics) {
            bool authenticatedWithBiometrics = await _authenticateWithBiometrics();
            if (authenticatedWithBiometrics) {
              // Define isLoggedIn como true somente se a biometria for bem-sucedida
              await prefs.setBool('isLoggedIn', true);
              await prefs.setBool('biometricEnabled', true);
              Navigator.pushReplacementNamed(context, '/menu');
              return; // Sai da função após sucesso
            } else {
              // Limpa o estado de login se a biometria falhar ou for cancelada
              await prefs.setBool('isLoggedIn', false);
              _showErrorDialog("Erro", "Autenticação biométrica cancelada ou falhou.");
              return; // Sai da função após falha
            }
          }
        }

        // Se a biometria não estiver disponível ou o usuário optar por não usá-la
        await prefs.setBool('isLoggedIn', true);
        Navigator.pushReplacementNamed(context, '/menu');
      } else {
        _showErrorDialog("Erro de autenticação", "Email ou senha inválidos.");
      }
    }
  }

  /// Verifica se o dispositivo suporta biometria.
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

  /// Autentica o usuário com biometria.
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
      return false; // Retorna `false` em caso de erro ou cancelamento
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
                onPressed: () async {
                  // Verificar se o dispositivo suporta biometria
                  bool isBiometricAvailable = await _isBiometricAvailable();
                  if (isBiometricAvailable) {
                    bool authenticatedWithBiometrics = await _authenticateWithBiometrics();
                    if (authenticatedWithBiometrics) {
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
                      if (isLoggedIn) {
                        Navigator.pushReplacementNamed(context, '/menu');
                      } else {
                        _showErrorDialog("Erro", "Usuário não cadastrado com biometria.");
                      }
                    } else {
                      _showErrorDialog("Erro", "Autenticação biométrica cancelada ou falhou.");
                    }
                  } else {
                    _showErrorDialog("Erro", "Biometria não disponível neste dispositivo.");
                  }
                },
                child: Text("Login com Biometria"),
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
                  // Navegar para a tela de recuperação de senha
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