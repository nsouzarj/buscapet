import 'package:flutter/material.dart';

import 'package:buscapet/loginscreen.dart';
import 'package:buscapet/services/usuarioservice.dart';

import 'classesutils/utilspet.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _codeController = TextEditingController();
  final _newPasswordController = TextEditingController();
  UsuaroService usuarioService = UsuaroService();
  ValidaEmail _validaEmail = ValidaEmail();

  @override
  void dispose() {
    _emailController.dispose();
    _codeController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Recuperar Senha',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'E-Email',
                ),
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
              SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: Icon(
                        Icons.qr_code,
                        color: Colors.white,
                      ),
                      label: Text(
                        "Gerar Código",
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      onPressed: () async {
                        if (_emailController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Insira um e-mail válido.'),
                            backgroundColor: Colors.red
                          ),
                        );
                          return null;
                        }

                        // Implementar lógica para gerar e enviar o código
                        // Exemplo:
                        //if (_formKey.currentState!.validate()) {
                        // Enviar código para o email
                        await usuarioService.gerarCodigo(_emailController.text);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'O código gerado foi enviado para seu e-email.'),
                            backgroundColor: Colors.blue,
                          ),
                        );
                        // ...
                        // }
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              Text("O código gerado será enviado para seu e-mail cadastrdo."),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _codeController,
                decoration: InputDecoration(
                  labelText: 'Insira o Código',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o código';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _newPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Nova Senha',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira sua senha';
                  }
                  if (value.length < 8) {
                    return 'A senha deve ter no mínimo 8 caracteres';
                  }
                  if (!RegExp(r'[0-9]').hasMatch(value)) {
                    return 'A senha deve conter pelo menos um número';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton.icon(
                label: Text(
                  "Enviar",
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    //Altera para nova senha
                    String email = _emailController.text;
                    String codigogerado = _codeController.text;
                    String novasenha = _newPasswordController.text;
                    Dados dados = Dados(
                        email: email, senha: novasenha, codigo: codigogerado);
                    _showMyDialog(context, dados);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showMyDialog(BuildContext context, Dados dados) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        bool isLoading = false; // Track loading state
        return StatefulBuilder(
            // Use StatefulBuilder to manage loading state within the dialog
            builder: (context, setState) {
          return AlertDialog(
            title: const Text(
              'Aviso!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  const Text(
                    'Confirma a nova senha?',
                    style: TextStyle(fontSize: 14, color: Colors.blueAccent),
                  ),
                  if (isLoading) // Show indicator only when loading
                    const Center(child: CircularProgressIndicator()),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancelar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Confirmar'),
                onPressed: () async {
                  try {
                    setState(() {
                      isLoading = true;
                    }); // Start loading
                    await usuarioService.alterarSenha(
                        dados.email, dados.senha, dados.codigo);
                    await showModalBottomSheet(
                      context: context,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(8)),
                      ),
                      builder: (BuildContext context) {
                        return Container(
                          height: 200,
                          padding: EdgeInsets.all(20),
                          child: Column(
                            children: [
                              Text(
                                "Aviso",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 10),
                              Text(
                                "Senha alterada com sucesso!",
                                style: TextStyle(color: Colors.blue),
                              ),
                              SizedBox(height: 20),
                              ElevatedButton(
                                child: Text("Fechar"),
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) => LoginScreen()),
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  } catch (e) {
                    await showModalBottomSheet(
                      context: context,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(8)),
                      ),
                      builder: (BuildContext context) {
                        return Container(
                          height: 200,
                          padding: EdgeInsets.all(20),
                          child: Column(
                            children: [
                              Text(
                                "Aviso",
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(height: 10),
                              Text(
                                "Erro ao alterar a senha. ",
                                style: TextStyle(color: Colors.red),
                              ),
                              SizedBox(height: 20),
                              ElevatedButton(
                                child: Text("Fechar"),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                            ],
                          ),
                        );
                      },
                      // ... Error bottom sheet ...
                    );
                  } finally {
                    setState(() {
                      isLoading = false;
                    }); // Stop loading in all cases
                  }
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
      },
    );
  }
}

class Dados {
  final String email;
  final String senha;
  final String codigo;
  Dados({
    required this.email,
    required this.senha,
    required this.codigo,
  });
}
