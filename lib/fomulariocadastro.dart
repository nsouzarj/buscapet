// Crie uma nova classe para o formulário de cadastro de pets
import 'dart:io';
import 'package:buscapet/classes/imagempet.dart';
import 'package:buscapet/services/cadastroservice.dart';
import 'package:buscapet/services/fileservice.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker_plus/multi_image_picker_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';
import 'classes/classecadastro.dart';
import 'classesutils/utilspet.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class MyApp extends StatelessWidget {
  // Crie esta classe MyApp
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('pt', ''),
        const Locale('pt', 'BR'), // Portuguese (Brazil)
        // Add more locales as needed
      ],
      locale: const Locale('pt', 'BR'),
      title: 'Cadastro de Pets',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FormularioCadastroPet(),
    );
  }
}

class FormularioCadastroPet extends StatefulWidget {
  @override
  _TelaDeCadastroState createState() => _TelaDeCadastroState();
}

class _TelaDeCadastroState extends State<FormularioCadastroPet> {
  TextEditingController _controllerData = TextEditingController();
  TextEditingController _controller = TextEditingController();
  // Crie um FocusNode
  FocusNode _focusNodeData = FocusNode();
  List<Asset> images = <Asset>[];

  //Service de cadsatro
  final _formKey = GlobalKey<FormBuilderState>();
  //Service pet
  ServicePet cadastroService = ServicePet();
  final ImagePicker _picker = ImagePicker();
  //
  UtilsPet _utilsPet = new UtilsPet();
  //Servico de imagem
  ServiceImages _serviceImages = new ServiceImages();
  ValidaEmail _validarEmail = ValidaEmail();
  //Campos para a classe Aninal
  String nomeAnimal = "";
  String tipoAnimal = "";
  String racaAnimal = "";
  String idadeAnimal = "";
  bool _chipado = false;
  bool _vacinado = false;
  bool _castrado = false;
  String descricaoAnimal = "";
  String dataDesaparecimento = "";
  String bairroAnimal = "";
  String cidadeEstado = "";
  String nomeTutor = "";
  String emailTutor = "";
  String celularTutor = "";

  List<File> _imagens = []; // Definição da variável para armazenar a imagem
  List<XFile> _imageFileList = []; //Definiacao para multiplos arquivos
  final ImagePicker imagePicker = ImagePicker();
  Future<void> _selecionarData(BuildContext context) async {
    // Intl.defaultLocale = 'pt_BR';
    final DateTime? dataEscolhida = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (dataEscolhida != null && dataEscolhida != DateTime.now()) {
      setState(() {
        _controllerData.text = DateFormat('dd/MM/yyyy').format(dataEscolhida);
      });
    }
  }

  //Mostra a caixa de confrimacao
  Future<void> _showMyDialog(
      BuildContext context, CadastroPet meuCadastro) async {
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
                    'Confirma o cadastro do pet?',
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
                  print(meuCadastro.toJson());
                  try {
                    setState(() {
                      isLoading = true;
                    }); // Start loading
                    await cadastroService.cadPetApi(meuCadastro);
                    _serviceImages.uploadMultipleImages(_imagens);
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
                                    fontSize: 19, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 10),
                              Text(
                                "Cadastro realizado.",
                                style: TextStyle(color: Colors.blue),
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
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 10),
                              Text(
                                "Erro ao cadastrar.",
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

  //Seleciona multiplas images
  Future<void> _selecionarImagensDaGaleria() async {
    List<File> arquivosImagens = [];
    // Verifica e solicita permissão
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    List<Asset> imagensSelecionadas = [];
    try {
      imagensSelecionadas = await MultiImagePicker.pickImages(
        androidOptions: AndroidOptions(
            maxImages: 4,
            hasCameraInPickerPage: true,
            useDetailsView: true,
            lightStatusBar: true,
            actionBarColor: Colors.black,
            actionBarTitle: "Fotos da Galeria",
            statusBarColor: Colors.white,
            actionBarTitleColor: Colors.white,
            autoCloseOnSelectionLimit: false,
            selectCircleStrokeColor: Colors.red,
            textOnNothingSelected: "Ok",
            selectionLimitReachedText: "Maximo de fotos 4."),
        iosOptions: IOSOptions(
          doneButton: UIBarButtonItem(title: 'Confirm', tintColor: Colors.cyan),
          cancelButton:
              UIBarButtonItem(title: 'Cancel', tintColor: Colors.orange),
          albumButtonColor: Colors.cyan,
        ),
      );
    } on Exception catch (e) {
      // Exibir SnackBar com a mensagem de erro
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao selecionar imagens: $e'),
          backgroundColor: Colors.red, // Cor de fundo para erro
        ),
      );
      // Tratar erro
    }

    // Converte os assets em arquivos

    for (var asset in imagensSelecionadas) {
      ByteData byteData = await asset.getByteData();
      List<int> imageData = byteData.buffer.asUint8List();
      File arquivo =
          await File('${(await getTemporaryDirectory()).path}/${asset.name}')
              .writeAsBytes(imageData);
      arquivosImagens.add(arquivo);
    }

    // Atualiza a lista de imagens
    setState(() {
      for (File foto in arquivosImagens) {
        if (_imagens.length <= 3) {
          _imagens.add(foto);
        } else {
          // Exibe a mensagem centralizada por 10 segundos
          final BuildContext contextoTela =
              context; // Armazena o contexto da tela
          showDialog(
            context: context,
            builder: (BuildContext context) {
              Future.delayed(Duration(seconds: 3), () {
                Navigator.of(contextoTela)
                    .pop(); // Usa o contexto da tela para fechar o diálogo
              });
              return MensagemCentralizada(
                  mensagem: 'Limite máximo de 4 fotos!');
            },
          );
        }
      }
    });
  }

  //Captura da camera
  Future<void> _capturarImagemDaCamera() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      File arquivoImagem = File(image.path);
      setState(() {
        if (_imagens.length <= 3) {
          _imagens.add(arquivoImagem);
        } else {
          final BuildContext contextoTela =
              context; // Armazena o contexto da tela
          showDialog(
            context: context,
            builder: (BuildContext context) {
              Future.delayed(Duration(seconds: 3), () {
                Navigator.of(contextoTela)
                    .pop(); // Usa o contexto da tela para fechar o diálogo
              });
              return MensagemCentralizada(
                  mensagem: 'Limíte de 4 fotos atingido!');
            },
          );
        }
      });
    }
  }

  Future<void> _adicionarFoto(BuildContext context) async {
    // Verifica as permissões
    var status = await Permission.photos.status;
    if (!status.isGranted) {
      await Permission.photos.request();
    }

    // Mostra opções para a câmera ou galeria
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: Icon(Icons.photo_library),
                    title:
                        Text('Galeria', style: TextStyle(color: Colors.black)),
                    onTap: () async {
                      _selecionarImagensDaGaleria();
                      // Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: Icon(Icons.photo_camera),
                  title: Text('Câmera', style: TextStyle(color: Colors.black)),
                  onTap: () async {
                    _capturarImagemDaCamera();
                    //  Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final text = _controller.text.toUpperCase();
      _controller.value = _controller.value.copyWith(
        text: text,
        selection:
            TextSelection(baseOffset: text.length, extentOffset: text.length),
        composing: TextRange.empty,
      );
    });
  }

  void selectImages() async {
    final List<XFile>? selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages != null && selectedImages.isNotEmpty) {
      // Check for null
      _imageFileList!.addAll(selectedImages);
    }
    if (selectedImages!.isNotEmpty) {
      _imageFileList!.addAll(selectedImages);
    }
    print("Image List Length:" + _imageFileList!.length.toString());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Cadastro do Pet',
            style: TextStyle(color: Colors.white),
          ),
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.black,
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16),
            child: FormBuilder(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  FormBuilderTextField(
                      name: 'nomeAnimal',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Este campo é obrigatório';
                        }
                        return null;
                      },
                      decoration: InputDecoration(labelText: 'Nome do Pet'),
                      inputFormatters: [UpperCaseTextFormatter()],
                      keyboardType: TextInputType.text,
                      onChanged: (String? value) {
                        setState(() {
                          nomeAnimal = value!;
                        });
                      }),
                  FormBuilderTextField(
                      name: 'tipoAnimal',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Este campo é obrigatório';
                        }
                        return null;
                      },
                      decoration: InputDecoration(labelText: 'Tipo do Pet'),
                      inputFormatters: [UpperCaseTextFormatter()],
                      keyboardType: TextInputType.text,
                      onChanged: (String? value) {
                        setState(() {
                          tipoAnimal = value!;
                        });
                      }),
                  FormBuilderTextField(
                      name: 'racaAnimal',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Este campo é obrigatório';
                        }
                        return null;
                      },
                      decoration: InputDecoration(labelText: 'Raça do Pet'),
                      inputFormatters: [UpperCaseTextFormatter()],
                      keyboardType: TextInputType.text,
                      onChanged: (String? value) {
                        setState(() {
                          racaAnimal = value!;
                        });
                      }),

                  FormBuilderTextField(
                      name: 'idadeAnimal',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Este campo é obrigatório';
                        }
                        return null;
                      },
                      decoration: InputDecoration(labelText: 'Idade do Pet'),
                      keyboardType: TextInputType.number,
                      onChanged: (String? value) {
                        setState(() {
                          idadeAnimal = value! ?? "0";
                        });
                      }),

                  Column(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Pet Chipado?',
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: ListTile(
                              title: const Text('Sim'),
                              leading: Radio<bool>(
                                value: true,
                                groupValue: _chipado,
                                onChanged: (bool? value) {
                                  setState(() {
                                    _chipado = value!;
                                  });
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListTile(
                              title: const Text('Não'),
                              leading: Radio<bool>(
                                value: false,
                                groupValue: _chipado,
                                onChanged: (bool? value) {
                                  setState(() {
                                    _chipado = value!;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  Column(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Pet Vacinado?',
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: ListTile(
                              title: const Text('Sim'),
                              leading: Radio<bool>(
                                value: true,
                                groupValue: _vacinado,
                                onChanged: (bool? value) {
                                  setState(() {
                                    _vacinado = value!;
                                  });
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListTile(
                              title: const Text('Não'),
                              leading: Radio<bool>(
                                value: false,
                                groupValue: _vacinado,
                                onChanged: (bool? value) {
                                  setState(() {
                                    _vacinado = value!;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Pet Castrado?',
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: ListTile(
                              title: const Text('Sim'),
                              leading: Radio<bool>(
                                value: true,
                                groupValue: _castrado,
                                onChanged: (bool? value) {
                                  setState(() {
                                    _castrado = value!;
                                  });
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListTile(
                              title: const Text('Não'),
                              leading: Radio<bool>(
                                value: false,
                                groupValue: _castrado,
                                onChanged: (bool? value) {
                                  setState(() {
                                    _castrado = value!;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  FormBuilderTextField(
                      name: 'descricao',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Este campo é obrigatório';
                        }
                        return null;
                      },
                      decoration:
                          InputDecoration(labelText: 'Observação sobre o Pet'),
                      keyboardType: TextInputType.text,
                      maxLines: 5,
                      onChanged: (String? value) {
                        setState(() {
                          descricaoAnimal = value!;
                        });
                      }),

                  FormBuilderTextField(
                      focusNode: _focusNodeData,
                      name: 'dataDesa',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Este campo é obrigatório';
                        }
                        return null;
                      },
                      decoration:
                          InputDecoration(labelText: 'Data do Desaparecimento'),
                      controller: _controllerData,
                      keyboardType: TextInputType.text,
                      onTap: () {
                        _selecionarData(context).then((_) {
                          // Retorna o foco para o campo dataDesa após a seleção da data
                          FocusScope.of(context).requestFocus(_focusNodeData);
                        });
                      },
                      onChanged: (String? value) {
                        setState(() {
                          dataDesaparecimento = value!;
                        });
                      }),

                  FormBuilderTextField(
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
                          bairroAnimal = value!;
                        });
                      }),
                  FormBuilderTextField(
                      name: 'cidadeEstado',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Este campo é obrigatório';
                        }
                        return null;
                      },
                      decoration: InputDecoration(labelText: 'Cidade/Estado'),
                      inputFormatters: [UpperCaseTextFormatter()],
                      keyboardType: TextInputType.text,
                      onChanged: (String? value) {
                        setState(() {
                          cidadeEstado = value!;
                        });
                      }),
                  FormBuilderTextField(
                      name: 'nomeTutor',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Este campo é obrigatório';
                        }
                        return null;
                      },
                      decoration:
                          InputDecoration(labelText: 'Nome do Responsável'),
                      inputFormatters: [UpperCaseTextFormatter()],
                      keyboardType: TextInputType.text,
                      onChanged: (String? value) {
                        setState(() {
                          nomeTutor = value!;
                        });
                      }),
                  FormBuilderTextField(
                    name: 'email',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Este campo é obrigatório';
                      }
                      if (!_validarEmail.validarEmail(value)) {
                        return 'E-Mail inválido';
                      }
                      return null;
                    },
                    decoration: InputDecoration(labelText: 'Email de Contato'),
                    inputFormatters: [LowCaseTextFormatter()],
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (String? value) {
                      setState(() {
                        emailTutor = value!;
                      });
                    },
                  ),
                  FormBuilderTextField(
                      name: 'celularTutor',
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
                          celularTutor = value!;
                        });
                      }),
                  SizedBox(height: 20),
                  // Exibe as imagens selecionadas
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Fotos do Pet',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        height: 100,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _imagens.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              // Adiciona InkWell para detectar toques
                              onTap: () {
                                // Exibe um diálogo de confirmação
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text(
                                        'Aviso!',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      content: Text(
                                        'Excluir esta foto?',
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.blue),
                                      ),
                                      actions: [
                                        TextButton(
                                          child: Text('Cancelar'),
                                          onPressed: () =>
                                              Navigator.of(context).pop(),
                                        ),
                                        TextButton(
                                          child: Text('Excluir'),
                                          onPressed: () {
                                            setState(() {
                                              _imagens.removeAt(
                                                  index); // Remove a imagem da lista
                                            });
                                            Navigator.of(context)
                                                .pop(); // Fecha o diálogo
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.file(_imagens[index]),
                              ),
                            );
                          },
                        ),
                      ),
                      Text("Toque na foto para excluir da lista.")
                    ],
                  ),
                  SizedBox(height: 20),
                  ElevatedButton.icon(
                    icon: Icon(
                      Icons.camera,
                      size: 40,
                      color: Colors.white,
                    ),
                    label: Text(
                      'Adicionar Fotos',
                      style: TextStyle(fontSize: 22, color: Colors.white),
                    ),
                    onPressed: () async {
                      if (_imagens.length == 4) {
                        final BuildContext contextoTela = context;
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title:
                                  Text('Aviso!', textAlign: TextAlign.center),
                              content: Text(
                                'Já tem o limite de imagens permitida! O limite e de quatro fotos.',
                              ),
                              actions: [
                                TextButton(
                                  child: Text('Fechar'),
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(); // Close the dialog
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        _adicionarFoto(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // Cor de fundo azul
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton.icon(
                    icon: Icon(
                      Icons.pets,
                      size: 40,
                      color: Colors.white,
                    ),
                    label: Text('Cadastrar',
                        style: TextStyle(fontSize: 22, color: Colors.white)),
                    onPressed: () async {
                      //Essa oartae trat os arquivos
                      List<String> nomesArquivos = _imagens
                          .map((file) => file.path.split('/').last)
                          .toList();

                      List<ImagemPet> imagensPet = [];
                      //Aqui intera para pegar cada nome de arquivo do array nomesArquivos
                      for (String nome in nomesArquivos) {
                        var imagemPet = ImagemPet(
                          id: 0,
                          caminhoImagem: '/home/nelson/imagenspet',
                          nomeArquivo: nome,
                          tipo: 'imagem',
                        );
                        imagensPet.add(imagemPet);
                      }
                      // Adicione mais objetos ImagemPet conforme necessário
                      CadastroPet meuCadastro = CadastroPet(
                        id: 0,
                        nomeAnimal: nomeAnimal,
                        tipo: tipoAnimal,
                        raca: racaAnimal,
                        idade: idadeAnimal,
                        chipado: _chipado,
                        vacinado: _vacinado,
                        castrado: _castrado,
                        descricao: descricaoAnimal,
                        situacao:
                            'DESAPARECIDO', //Desaparecido, //Encontrado, //Adotado
                        datadodesaparecimento:
                            _utilsPet.formatarData(dataDesaparecimento, 'US'),
                        bairro: bairroAnimal,
                        cidadeEstado: cidadeEstado,
                        nomeTutor: nomeTutor,
                        email: emailTutor,
                        celular: celularTutor.toString(),
                        imagens: imagensPet,
                      );

                      if (_formKey.currentState!.validate()) {
                        _showMyDialog(context, meuCadastro);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton.icon(
                    icon: Icon(
                      Icons.cancel,
                      size: 40,
                      color: Colors.white,
                    ),
                    label: Text('Cancelar',
                        style: TextStyle(fontSize: 22, color: Colors.white)),
                    onPressed: () {
                      Navigator.of(context).pop(); // Volta para a tela anterior
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey, // Cor de fundo cinza
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

//Classe para caixa alta
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

//Classe para caixa baixa
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
