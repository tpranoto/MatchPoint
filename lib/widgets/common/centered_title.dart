import 'package:flutter/material.dart';

class CenteredTitle extends StatelessWidget {
  final String text;
  final double size;
  const CenteredTitle(this.text, {super.key, this.size = 14});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: size),
      ),
    );
  }
}
