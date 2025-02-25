import 'package:flutter/material.dart';

class IconWithText extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color textColor;
  final double size;
  const IconWithText({
    super.key,
    required this.icon,
    required this.text,
    this.textColor = Colors.blueGrey,
    this.size = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 10,
      children: [
        Icon(
          icon,
          color: textColor,
          size: size + 2,
        ),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: size,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
        )
      ],
    );
  }
}
