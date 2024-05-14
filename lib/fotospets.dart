import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/painting.dart';
import 'package:photo_view/photo_view.dart';

/// Widget que exibe uma lista de imagens de pets e permite a visualização ampliada.
class TelaDetalhe extends StatefulWidget {
  /// Lista de URLs das imagens dos pets.
  final List<String> imageUrls;

  /// Construtor da classe TelaDetalhe.
  /// 
  /// Recebe a lista de URLs das imagens dos pets como argumento obrigatório.
  TelaDetalhe({required this.imageUrls});

  @override
  _TelaDeDetalhe createState() => _TelaDeDetalhe();
}

/// Estado da classe TelaDetalhe.
class _TelaDeDetalhe extends State<TelaDetalhe> {
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /// Constrói a interface da tela de detalhes.
    /// 
    /// Retorna um Scaffold contendo uma AppBar com título "Imagens do Pet" e um body
    /// com um ListView.builder que exibe as imagens dos pets. Cada imagem é exibida
    /// dentro de um GestureDetector que permite a navegação para a tela de zoom
    /// ao ser tocada.
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Imagens do Pet',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
      ),
      body: ListView.builder(
        itemCount: widget.imageUrls.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TelaFotoZoom(imageUrl: widget.imageUrls[index]),
                ),
              );
            },
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    child: CachedNetworkImage(
                      imageUrl: widget.imageUrls[index],
                      placeholder: (context, url) => CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error, size: 30,),
                      width: double.infinity,
                      height: 320,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Text("Toque na foto para ampliar", style: TextStyle(color: Colors.blue),),
                const Divider(),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Widget que exibe uma imagem ampliada do pet.
class TelaFotoZoom extends StatelessWidget {
  /// URL da imagem do pet.
  final String imageUrl;

  /// Construtor da classe TelaFotoZoom.
  /// 
  /// Recebe a URL da imagem do pet como argumento obrigatório.
  const TelaFotoZoom({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// Constrói a interface da tela de zoom.
    /// 
    /// Retorna um Scaffold contendo uma AppBar com título "Imagem Ampliada" e um body
    /// com um GestureDetector que envolve um PhotoView. O GestureDetector permite o retorno
    /// para a tela anterior ao ser tocado. O PhotoView exibe a imagem ampliada do pet
    /// com recursos de zoom, rotação e pan.
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Imagem Ampliada',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
      ),
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: PhotoView(
          backgroundDecoration: BoxDecoration(color: Colors.black),
          enableRotation: true,
          enablePanAlways: true,
          semanticLabel: 'Foto do Pet',
          imageProvider: CachedNetworkImageProvider(imageUrl),
        ),
      ),
    );
  }
}