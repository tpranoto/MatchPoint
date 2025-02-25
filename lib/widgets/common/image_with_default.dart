import 'package:flutter/material.dart';

class ImageWithDefault extends StatelessWidget {
  final String? photoUrl;
  final String defaultAsset;
  final double size;
  const ImageWithDefault(
      {super.key,
      required this.photoUrl,
      required this.defaultAsset,
      required this.size});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image(
        height: size,
        width: size,
        fit: BoxFit.fill,
        image: photoUrl != null
            ? NetworkImage(photoUrl!)
            : AssetImage(
                defaultAsset,
              ),
      ),
    );
  }
}
