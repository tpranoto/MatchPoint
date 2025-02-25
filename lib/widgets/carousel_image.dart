import 'package:flutter/material.dart';

class ImageCarousel extends StatefulWidget {
  final List<String>? photoUrl;

  const ImageCarousel({super.key, required this.photoUrl});

  @override
  State <ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final List<String> images = (widget.photoUrl != null && widget.photoUrl!.isNotEmpty) ? widget.photoUrl!
        : ["assets/matchpoint.png"];

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        SizedBox(
          height: 400,
          child: PageView.builder(
            controller: _pageController,
            itemCount: images.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  images[index],
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(child: CircularProgressIndicator());
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset("assets/matchpoint.png",
                        fit: BoxFit.cover, width: double.infinity);
                  },
                ),
              );
            },
          ),
        ),
        Positioned(
          bottom: 10,
          right: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              "${_currentIndex + 1} / ${images.length}",
              style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}
