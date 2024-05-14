import 'package:buscapet/classes/classecadastro.dart';
import 'package:buscapet/classesutils/utilspet.dart';
import 'package:buscapet/services/buscapetservice.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:photo_view/photo_view.dart';
import 'package:url_launcher/url_launcher.dart';
import 'fotospets.dart';

/// Widget stateful que exibe uma lista de pets cadastrados.
class ListaPet extends StatefulWidget {
  @override
  _TelaDeCadastroState createState() => _TelaDeCadastroState();
}

/// Estado do widget ListaPet.
class _TelaDeCadastroState extends State<ListaPet> {
  BuscapetService _buscaService = BuscapetService(); // Serviço para buscar pets.
  UtilsPet _dataUilt = UtilsPet(); // Utilitário para formatar datas.
  Global _global = Global(); // Variável global com configurações.

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Lista de Pets',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder<List<CadastroPet>>(
        future: _buscaService.getPetList(), // Busca a lista de pets.
        builder: (context, snapshot) {
          // Se os dados foram carregados com sucesso...
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final pet = snapshot.data![index]; // Obtém o pet atual.

                // Widget ExpansionTile para exibir detalhes do pet.
                return ExpansionTile(
                  // Avatar do pet.
                  leading: GestureDetector(
                    onTap: () {
                      // Se o pet tiver imagens, exibe a primeira em tela cheia.
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
                      // Exibe a imagem do avatar do pet.
                      backgroundImage: pet.imagens.isNotEmpty
                          ? CachedNetworkImageProvider(
                              "${_global.urlGeral}/pet/imagem/${pet.imagens[0].nomeArquivo}")
                          : null,
                      // Se não houver imagem, exibe um ícone padrão.
                      child: pet.imagens.isEmpty
                          ? Icon(Icons.pets, size: 30)
                          : null,
                    ),
                  ),
                  // Título do ExpansionTile, exibindo o nome do animal.
                  title: Text(pet.nomeAnimal,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black)),
                  // Detalhes do pet exibidos quando o ExpansionTile é expandido.
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Linha com a raça do pet.
                          Row(
                            children: [
                              Text('Raça: ', style: TextStyle(color: Colors.black)),
                              Expanded(
                                  child: Text(
                                    pet.tipo,
                                    style: TextStyle(color: Colors.black),
                                    overflow: TextOverflow.ellipsis,
                                  ))
                            ],
                          ),
                          // Linha com o tipo do pet.
                          Row(
                            children: [
                              Text('Tipo: ', style: TextStyle(color: Colors.black)),
                              Expanded(
                                  child: Text(
                                    pet.raca,
                                    style: TextStyle(color: Colors.black),
                                    overflow: TextOverflow.ellipsis,
                                  ))
                            ],
                          ),
                          // Linha com o status do pet.
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
                          // Linha com a data de desaparecimento do pet.
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
                          // Linha com o nome do tutor do pet.
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
                          // Linha com o número de celular do tutor.
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
                          // Linha com o endereço de e-mail do tutor.
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
                          // Linha com observações sobre o pet.
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
                          // Botão para visualizar mais fotos do pet.
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
            // Se houve um erro ao carregar os dados...
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      'Erro ao carregar lista de pets: ${snapshot.error}'),
                  backgroundColor: Colors.red,
                ),
              );
            });
            return Center(child: Text('Erro ao carregar dados'));
          }
          // Enquanto os dados estão sendo carregados, exibe um indicador de progresso.
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

/// Widget para exibir uma imagem em tela cheia.
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