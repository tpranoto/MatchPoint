import 'package:flutter/material.dart';

class SquaredButton extends StatelessWidget {
  final String text;
  final Function()? onPressed;
  final Widget? icon;
  final Size? size;
  final Color bg;
  final Color fg;
  final Color? border;

  const SquaredButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.size,
    this.bg = Colors.white,
    this.fg = Colors.black,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        fixedSize: size,
        backgroundColor: bg,
        foregroundColor: fg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          side: border == null
              ? BorderSide.none
              : BorderSide(
                  color: border!,
                ),
        ),
      ),
      icon: icon,
      label: Text(text),
    );
  }
}
