import 'package:buscapet/classes/classecadastro.dart';
import 'package:buscapet/classesutils/utilspet.dart';
import 'package:buscapet/services/buscapetservice.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view.dart';
import 'package:url_launcher/url_launcher.dart';
import 'fotospets.dart';

// Tela de filtro
class TelaFiltroPet extends StatefulWidget {
  @override
  _TelaFiltroPetState createState() => _TelaFiltroPetState();
}

class _TelaFiltroPetState extends State<TelaFiltroPet> {
  final _formKey = GlobalKey<FormState>();
  final _nomeAnimalController = TextEditingController();
  final _racaController = TextEditingController();
  final _tipoController = TextEditingController();
  final _situacaoController = TextEditingController();
  final ListaRacaCaes _listaRaca = ListaRacaCaes();

  // Variáveis para armazenar os valores selecionados nos filtros
  String? _racaSelecionada;
  String? _tipoSelecionado;
  String? _situacaoSelecionada;

  @override
  Widget build(BuildContext context) {
    // Lista de opções para os filtros
    final List<String> _listaRacas =
        _listaRaca.ListaRaca(); // Substitua pelas raças reais
    final List<String> _listaTipos = ['CANINO', 'FELINO', 'OUTRO'];
    final List<String> _listaSituacoes = [
      'DESAPARECIDO',
      'ABANDONADO',
      'ADOCAO'
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Filtrar Pets',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Campo de texto para o nome do animal
              TextFormField(
                controller: _nomeAnimalController,
                inputFormatters: [UpperCaseTextFormatter()],
                decoration: InputDecoration(
                  labelText: 'Nome do Pet',
                ),
              ),
              SizedBox(height: 20),
              // Dropdown para selecionar o tipo
              DropdownButtonFormField<String>(
                value: _tipoSelecionado,
                onChanged: (value) {
                  setState(() {
                    _tipoSelecionado = value;
                  });
                },
                items: _listaTipos.map((tipo) {
                  return DropdownMenuItem(
                    value: tipo,
                    child: Text(tipo),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelText: 'Tipo',
                ),
              ),
              DropdownButtonFormField<String>(
                value: _racaSelecionada,
                onChanged: (value) {
                  setState(() {
                    _racaSelecionada = value;
                  });
                },
                items: _listaRacas.map((raca) {
                  return DropdownMenuItem(
                    value: raca,
                    child: Text(
                      raca,
                      style: TextStyle(fontSize: 13),
                    ),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelText: 'Raça',
                ),
              ),
              // Dropdown para selecionar a raça
              SizedBox(height: 20),
              // Dropdown para selecionar a situação
              DropdownButtonFormField<String>(
                value: _situacaoSelecionada,
                onChanged: (value) {
                  setState(() {
                    _situacaoSelecionada = value;
                  });
                },
                items: _listaSituacoes.map((situacao) {
                  return DropdownMenuItem(
                    value: situacao,
                    child: Text(situacao),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelText: 'Situação',
                ),
              ),
              SizedBox(height: 32),
              // Botão para aplicar os filtros
              ElevatedButton(
                onPressed: () {
                  // Obter os valores dos filtros
                  String nomeAnimal = _nomeAnimalController.text;
                  String? raca = _racaSelecionada;
                  String? tipo = _tipoSelecionado;
                  String? situacao = _situacaoSelecionada;
                  // Passar os filtros para a tela da lista de pets
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ListaPetFiltrada(
                        nomeAnimal: nomeAnimal,
                        raca: raca,
                        tipo: tipo,
                        situacao: situacao,
                      ),
                    ),
                  );
                },
                child: Text('Aplicar Filtros'),
              ),
              SizedBox(height: 16),
              // Botão para limpar os filtros
              ElevatedButton(
                onPressed: () {
                  _limparFiltros();
                },
                child: Text('Limpar Filtros'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Método para limpar os filtros
  void _limparFiltros() {
    setState(() {
      _nomeAnimalController.clear();
      _racaSelecionada = null;
      _tipoSelecionado = null;
      _situacaoSelecionada = null;
    });
  }
}

// Tela da lista de pets filtrada
class ListaPetFiltrada extends StatefulWidget {
  final String nomeAnimal;
  final String? raca;
  final String? tipo;
  final String? situacao;

  ListaPetFiltrada({
    required this.nomeAnimal,
    required this.raca,
    required this.tipo,
    required this.situacao,
  });

  @override
  _ListaPetFiltradaState createState() => _ListaPetFiltradaState();
}

class _ListaPetFiltradaState extends State<ListaPetFiltrada> {
  BuscapetService _buscaService = BuscapetService();
  UtilsPet _dataUilt = UtilsPet();
  Global _global = Global();

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Lista de Pets Filtrada',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder<List<CadastroPet>>(
        future: _buscaService.getPetList(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // Aplicar filtros aos pets
            List<CadastroPet> petsFiltrados = snapshot.data!.where((pet) {
              bool nomeValido = widget.nomeAnimal.isEmpty ||
                  pet.nomeAnimal
                      .toLowerCase()
                      .contains(widget.nomeAnimal.toLowerCase());
              bool racaValida = widget.raca == null || pet.raca == widget.raca;
              bool tipoValido = widget.tipo == null || pet.tipo == widget.tipo;
              bool situacaoValida =
                  widget.situacao == null || pet.situacao == widget.situacao;
              return nomeValido && racaValida && tipoValido && situacaoValida;
            }).toList();

            if (petsFiltrados.isEmpty) {
              return Center(
                child: Text("Nenhum pet encontrado com esses filtros."),
              );
            }

            return ListView.builder(
              itemCount: petsFiltrados.length,
              itemBuilder: (context, index) {
                final pet = petsFiltrados[index];
                return ExpansionTile(
                  leading: GestureDetector(
                    onTap: () {
                      if (pet.imagens.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FullScreenImage(
                              imageUrl:
                                  "${_global.urlGeral}/pet/imagem/${pet.imagens[0].nomeArquivo}",
                            ),
                          ),
                        );
                      }
                    },
                    child: CircleAvatar(
                      radius: 25,
                      backgroundImage: pet.imagens.isNotEmpty
                          ? CachedNetworkImageProvider(
                              "${_global.urlGeral}/pet/imagem/${pet.imagens[0].nomeArquivo}")
                          : null,
                      child: pet.imagens.isEmpty
                          ? Icon(Icons.pets, size: 30)
                          : null,
                    ),
                  ),
                  title: Text(pet.nomeAnimal,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black)),
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text('Tipo: ',
                                  style: TextStyle(color: Colors.black)),
                              Expanded(
                                  child: Text(
                                pet.tipo,
                                style: TextStyle(color: Colors.black),
                                overflow: TextOverflow.ellipsis,
                              ))
                            ],
                          ),
                          Row(
                            children: [
                              Text('Raça: ',
                                  style: TextStyle(color: Colors.black)),
                              Expanded(
                                  child: Text(
                                pet.raca,
                                style: TextStyle(color: Colors.black),
                                overflow: TextOverflow.ellipsis,
                              ))
                            ],
                          ),
                          Row(
                            children: [
                              Text('Status: ',
                                  style: TextStyle(color: Colors.black)),
                              Expanded(
                                  child: Text(
                                pet.situacao,
                                style: TextStyle(color: Colors.black),
                                overflow: TextOverflow.ellipsis,
                              ))
                            ],
                          ),
                          Row(
                            children: [
                              Text('Data: ',
                                  style: TextStyle(color: Colors.black)),
                              Expanded(
                                  child: Text(
                                '${_dataUilt.formatarData(pet.datadodesaparecimento, 'BR')}',
                                style: TextStyle(color: Colors.black),
                                overflow: TextOverflow.ellipsis,
                              )),
                            ],
                          ),
                          Row(
                            children: [
                              Text('Tutor: ',
                                  style: TextStyle(color: Colors.black)),
                              Expanded(
                                  child: Text(
                                pet.nomeTutor,
                                style: TextStyle(color: Colors.black),
                                overflow: TextOverflow.ellipsis,
                              )),
                            ],
                          ),
                          Row(
                            children: [
                              Text('Celular: ',
                                  style: TextStyle(color: Colors.black)),
                              Expanded(
                                  child: Text(
                                pet.celular,
                                style: TextStyle(color: Colors.black),
                                overflow: TextOverflow.ellipsis,
                              )),
                            ],
                          ),
                          Row(
                            children: [
                              Text('E-Mail: ',
                                  style: TextStyle(color: Colors.black)),
                              Expanded(
                                child: InkWell(
                                  onTap: () => launch('mailto:${pet.email}'),
                                  child: Text(
                                    pet.email,
                                    style: TextStyle(
                                        color: Colors.blue,
                                        decoration: TextDecoration.underline),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text('OBS: ',
                                  style: TextStyle(color: Colors.black)),
                              Flexible(
                                  child: Text(
                                pet.descricao,
                                style: TextStyle(color: Colors.black),
                              )),
                            ],
                          ),
                          SizedBox(height: 10),
                          ElevatedButton.icon(
                            icon: Icon(
                              Icons.camera,
                              color: Colors.blue,
                              size: 30,
                            ),
                            onPressed: () {
                              List<String> caminho = [];
                              if (pet.imagens.length >= 2) {
                                for (var petlista in pet.imagens) {
                                  petlista.nomeArquivo.toString();
                                  caminho.add(
                                      "${_global.urlGeral}/pet/imagem/${petlista.nomeArquivo}");
                                }
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TelaDetalhe(
                                      imageUrls: caminho,
                                    ),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                        Text('A foto unica e do avatar acima.'),
                                    backgroundColor:
                                        Colors.blue, // Cor de fundo para erro
                                  ),
                                );
                              }
                            },
                            label: Text('Ver mais fotos.'),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            );
          } else if (snapshot.hasError) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content:
                      Text('Erro ao carregar lista de pets: ${snapshot.error}'),
                  backgroundColor: Colors.red,
                ),
              );
            });
            return Center(child: Text('Erro ao carregar dados'));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

// Widget para exibir uma imagem em tela cheia
class FullScreenImage extends StatelessWidget {
  final String imageUrl;

  FullScreenImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: PhotoView(
          backgroundDecoration: BoxDecoration(
              color: Colors.black, borderRadius: BorderRadius.circular(20)),
          enableRotation: true,
          enablePanAlways: true,
          semanticLabel: 'Foto do Pet',
          imageProvider: CachedNetworkImageProvider(imageUrl),
        ),
      ),
    );
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