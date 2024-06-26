import 'package:buscapet/classes/classeuser.dart';
import 'package:buscapet/classesutils/utilspet.dart';
import 'package:buscapet/loginscreen.dart';
import 'package:buscapet/services/cadastroservice.dart';
import 'package:buscapet/services/usuarioservice.dart';
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
  final TextEditingController _endrecoController = TextEditingController();
  final TextEditingController _cepController = TextEditingController();
  final TextEditingController _bairroController = TextEditingController();
  final TextEditingController _cidadeController = TextEditingController();
  final TextEditingController _estadoController = TextEditingController();

  ValidaEmail _validaEmail = ValidaEmail();

  //Service pet
  //ServicePet cadastroService = ServicePet();
  UsuaroService usuarioServive = UsuaroService();
  ListaEstados _listaEstados = ListaEstados();
  //Estado Selecionado
  String? _estadoSelecionado;

  HashCode _hashCodePassword = HashCode();

  String nomeUser = "";
  String emailUser = "";
  String celularUser = "";
  String senhaUser = "";
  String enderoUser = "";
  String cepUser = "";
  String bairroUser = "";
  String cidadeUser = "";
  String eatadoUser = "";

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    _nomeController.dispose();
    _telefoneController.dispose();
    super.dispose();
  }

  /// Exibe um diálogo de confirmação de cadastro.

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
                  try {
                    setState(() {
                      isLoading = true;
                    }); // Start loading
                    await usuarioServive.cadUserApi(usuario);

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
                        return MyErrorDialog(
                            message:
                                "Erro ao cadastrar ou usuário já existente. ");
                    
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
    List<String> _listaestados = _listaEstados.listaEstados();
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
                decoration: InputDecoration(labelText: 'Nome Completo'),
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
              //Endereco
              FormBuilderTextField(
                controller: _endrecoController,
                name: 'endereco',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Este campo é obrigatório';
                  }
                  return null;
                },
                decoration: InputDecoration(labelText: 'Endereço'),
                inputFormatters: [UpperCaseTextFormatter()],
                keyboardType: TextInputType.text,
                onChanged: (String? value) {
                  setState(() {
                    enderoUser = value!;
                  });
                },
              ),
              //Cep
              FormBuilderTextField(
                controller: _cepController,
                name: 'cep',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Este campo é obrigatório';
                  }
                  return null;
                },
                decoration: InputDecoration(labelText: 'Cep'),
                inputFormatters: [
                  MaskedInputFormatter('#####-###'),
                ],
                keyboardType: TextInputType.text,
                onChanged: (String? value) {
                  setState(() {
                    cepUser = value!;
                  });
                },
              ),
              //Bairro
              FormBuilderTextField(
                controller: _bairroController,
                name: 'bairro',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Este campo é obrigatório';
                  }
                  return null;
                },
                decoration: InputDecoration(labelText: 'Bairro'),
                inputFormatters: [UpperCaseTextFormatter()],
                keyboardType: TextInputType.text,
                onChanged: (String? value) {
                  setState(() {
                    bairroUser = value!;
                  });
                },
              ),
              //Cidade
              FormBuilderTextField(
                controller: _cidadeController,
                name: 'cidade',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Este campo é obrigatório';
                  }
                  return null;
                },
                decoration: InputDecoration(labelText: 'Cidade'),
                inputFormatters: [UpperCaseTextFormatter()],
                keyboardType: TextInputType.text,
                onChanged: (String? value) {
                  setState(() {
                    cidadeUser = value!;
                  });
                },
              ),

              //Estado
              FormBuilderDropdown<String>(
                name: 'estado', // Nome do campo no FormBuilder
                decoration: InputDecoration(labelText: 'Estado'),
                initialValue: _estadoSelecionado,

                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Este campo é obrigatório';
                  }
                  return null;
                },
                items: _listaestados.map((estado) {
                  return DropdownMenuItem(
                    value: estado,
                    child: Text(
                      estado,
                      style: TextStyle(fontSize: 13),
                    ),
                  );
                }).toList(),
                onChanged: (String? novoValor) {
                  setState(() {
                    _estadoSelecionado = novoValor!;
                  });
                },
              ),

              SizedBox(height: 16.0),
              FormBuilderTextField(
                controller: _senhaController,
                name: 'senhaUser',
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
                      endereco: enderoUser,
                      bairro: bairroUser,
                      cep: cepUser,
                      cidade: cidadeUser,
                      estado: _estadoSelecionado,
                    );
                    //Aqui a caixa de dialogo para confirmacao
                    _showMyDialog(context, usuario);
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
