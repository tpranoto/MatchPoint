import 'package:flutter/material.dart';

class IconWithText extends StatelessWidget {
  final IconData icon;
  final String text;

  final Color textColor;
  const IconWithText({
    super.key,
    required this.icon,
    required this.text,
    this.textColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 10,
      children: [
        Icon(icon, color: Colors.blueAccent),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
        )
      ],
    );
  }
}

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
