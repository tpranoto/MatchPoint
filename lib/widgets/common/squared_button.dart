import 'package:flutter/material.dart';

class SquaredButton extends StatelessWidget {
  final String text;
  final Function() onPressed;

  final Widget icon;
  final Color bg;
  final Color fg;

  const SquaredButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.icon,
    this.bg = Colors.white,
    this.fg = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: bg,
        foregroundColor: fg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
      icon: icon,
      label: Text(text),
    );
  }
}
