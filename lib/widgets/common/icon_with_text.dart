import 'package:flutter/material.dart';

class IconWithText extends StatelessWidget {
  final IconData icon;
  final String text;

  final Color textColor;
  const IconWithText({
    super.key,
    required this.icon,
    required this.text,
    this.textColor = Colors.blueGrey,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 10,
      children: [
        Icon(icon, color: Colors.blueGrey),
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
