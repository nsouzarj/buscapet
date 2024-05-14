import 'package:buscapet/classes/classeuser.dart';
import 'package:buscapet/classesutils/utilspet.dart';
import 'package:buscapet/loginscreen.dart';
import 'package:buscapet/services/cadastroservice.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

/// Tela de cadastro de usuário.
class CadastroScreen extends StatefulWidget {
  @override
  _CadastroScreenState createState() => _CadastroScreenState();
}

/// Estado da tela de cadastro.
class _CadastroScreenState extends State<CadastroScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();

  ValidaEmail _validaEmail = ValidaEmail();

  //Service pet
  ServicePet cadastroService = ServicePet();

  HashCode _hashCodePassword = HashCode();

  String celularUser = "";
  String nomeUser = "";
  String emailUser = "";
  String senhaUser = "";

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    _nomeController.dispose();
    _telefoneController.dispose();
    super.dispose();
  }

  /// Exibe um diálogo de confirmação de cadastro.
  /// 
  /// [context] Contexto do widget.
  /// [usuario] Usuário a ser cadastrado.
  Future<void> _showMyDialog(BuildContext context, Usuario usuario) async {
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
                    'Confirma o seu cadastro?',
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
                  print(usuario.toJson());
                  try {
                    setState(() {
                      isLoading = true;
                    }); // Start loading
                    await cadastroService.cadUserApi(usuario);
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
                                "Cadastro salvo com sucesso!.",
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
                                "Erro ao cadastrar. ",
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cadastro de Usuário',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        // Adicione SingleChildScrollView aqui
        padding: EdgeInsets.all(16.0),
        child: FormBuilder(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              FormBuilderTextField(
                controller: _nomeController,
                name: 'nomeUser',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Este campo é obrigatório';
                  }
                  return null;
                },
                decoration: InputDecoration(labelText: 'Nome Completol'),
                inputFormatters: [UpperCaseTextFormatter()],
                keyboardType: TextInputType.text,
                onChanged: (String? value) {
                  setState(() {
                    nomeUser = value!;
                  });
                },
              ),
              SizedBox(height: 16.0),
              FormBuilderTextField(
                name: 'email',
                controller: _emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Este campo é obrigatório';
                  }
                  if (!_validaEmail.validarEmail(value)) {
                    return 'E-Mail inválido';
                  }
                  // return null;
                },
                decoration: InputDecoration(labelText: 'Email'),
                inputFormatters: [LowCaseTextFormatter()],
                keyboardType: TextInputType.emailAddress,
                onChanged: (String? value) {
                  setState(() {
                    emailUser = value!;
                  });
                },
              ),
              SizedBox(height: 16.0),
              FormBuilderTextField(
                controller: _telefoneController,
                name: 'Telefone',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Este campo é obrigatório';
                  }
                  return null;
                },
                decoration:
                    InputDecoration(labelText: 'Celular(DD) "WhatsApp"'),
                inputFormatters: [
                  MaskedInputFormatter('(##) #####-####'),
                ],
                keyboardType: TextInputType.phone,
                onChanged: (String? value) {
                  setState(() {
                    celularUser = value!;
                  });
                },
              ),
              SizedBox(height: 16.0),
              FormBuilderTextField(
                controller: _senhaController,
                name: 'senhaUser',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Este campo é obrigatório';
                  }
                  return null;
                },
                decoration: InputDecoration(labelText: 'Senha'),
                keyboardType: TextInputType.visiblePassword,
                onChanged: (String? value) {
                  setState(() {
                    senhaUser = value!;
                  });
                },
              ),
              SizedBox(height: 32.0),
              ElevatedButton(
                child: Text('Cadastrar'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Usuario usuario = Usuario(
                      nomeUser: nomeUser,
                      emailUser: emailUser,
                      celularUser: celularUser,
                      senhaUser: _hashCodePassword.hashPassword(senhaUser),
                    );
                    //Aqui ira para a api do sistema
                    _showMyDialog(context, usuario);
                    // print(usuario.toJsonString());
                    // Navegar para outra tela após o cadastro
                    // Navigator.pop(context);
                  } else {
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Formatador de texto para caixa alta.
class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

/// Formatador de texto para caixa baixa.
class LowCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toLowerCase(),
      selection: newValue.selection,
    );
  }
}