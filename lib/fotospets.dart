import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:photo_view/photo_view.dart';

/// Widget que exibe um carrossel de imagens de pets com efeito parallax e botões na BottomBar.
class TelaDetalhe extends StatefulWidget {
  /// Lista de URLs das imagens dos pets.
  final List<String> imageUrls;

  /// Construtor da classe TelaDetalhe.
  TelaDetalhe({required this.imageUrls});

  @override
  _TelaDeDetalhe createState() => _TelaDeDetalhe();
}

/// Estado da classe TelaDetalhe.
class _TelaDeDetalhe extends State<TelaDetalhe> {
  late final PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: 1.0,
      initialPage: 0,
    )..addListener(_updateCurrentPage);
  }

  void _updateCurrentPage() {
    final page = _pageController.page;
    if (page != null && mounted) {
      setState(() => _currentPage = page.round());
    }
  }

  void _nextImage() {
    if (_currentPage < widget.imageUrls.length - 1) {
      _pageController.animateToPage(
        _currentPage + 1,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousImage() {
    if (_currentPage > 0) {
      _pageController.animateToPage(
        _currentPage - 1,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Imagens do Pet',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
      ),
      body: SizedBox.expand(
        child: PageView.builder(
          controller: _pageController,
          itemCount: widget.imageUrls.length,
          itemBuilder: (context, index) {
            double parallax = 0.0;
            if (_pageController.position.haveDimensions && _pageController.page != null) {
              parallax = (_pageController.page! - index);
            }
            return ParallaxCard(
              imageUrl: widget.imageUrls[index],
              parallaxOffset: parallax,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TelaFotoZoom(imageUrl: widget.imageUrls[index]),
                  ),
                );
              },
            );
          },
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.black,
        child: Container(
          height: 70,
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: _currentPage > 0 ? _previousImage : null,
                color: _currentPage > 0 ? Colors.white : Colors.grey,
                iconSize: 30,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  widget.imageUrls.length,
                      (index) => PageIndicator(isActive: index == _currentPage),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
                onPressed: _currentPage < widget.imageUrls.length - 1 ? _nextImage : null,
                color: _currentPage < widget.imageUrls.length - 1 ? Colors.white : Colors.grey,
                iconSize: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Indicador de página para o carrossel
class PageIndicator extends StatelessWidget {
  final bool isActive;

  const PageIndicator({super.key, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: isActive ? 24 : 8,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

/// Card com efeito de parallax para cada imagem
class ParallaxCard extends StatelessWidget {
  final String imageUrl;
  final double parallaxOffset;
  final VoidCallback onTap;

  const ParallaxCard({
    super.key,
    required this.imageUrl,
    required this.parallaxOffset,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final parallaxValue = parallaxOffset * 80;

    return GestureDetector(
      onTap: onTap,
      child: Hero(
        tag: imageUrl,
        child: ClipRRect(
          borderRadius: BorderRadius.zero, // Sem arredondamento para ajuste total nas bordas
          child: Stack(
            fit: StackFit.expand,
            children: [
              Positioned.fill(
                child: Transform.translate(
                  offset: Offset(parallaxValue, 0),
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Colors.grey[300],
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.error, size: 50, color: Colors.red),
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: const [0.7, 0.95],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 16,
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    "Toque para ampliar",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      shadows: const [
                        Shadow(
                          blurRadius: 10.0,
                          color: Colors.black,
                          offset: Offset(0.0, 2.0),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Widget que exibe uma imagem ampliada do pet.
class TelaFotoZoom extends StatelessWidget {
  /// URL da imagem do pet.
  final String imageUrl;

  const TelaFotoZoom({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Imagem Ampliada',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
      ),
      body: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Hero(
          tag: imageUrl,
          child: PhotoView(
            backgroundDecoration: const BoxDecoration(color: Colors.black),
            semanticLabel: 'Foto do Pet',
            imageProvider: CachedNetworkImageProvider(imageUrl),
          ),
        ),
      ),
    );
  }
}