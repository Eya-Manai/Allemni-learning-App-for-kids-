import 'package:flutter/material.dart';

class DrawButtton extends StatelessWidget {
  final String text;
  final Color color;
  final Color textColor;

  final double width;
  final double height;
  final double size;

  final VoidCallback? onPressed;
  final Widget? child;

  const DrawButtton({
    super.key,
    required this.text,
    required this.width,
    required this.height,
    required this.size,
    required this.color,
    required this.textColor,

    this.onPressed,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
        child:
            child ??
            Text(
              text,
              style: TextStyle(
                fontSize: size,
                color: textColor,
                fontWeight: FontWeight.bold,
                fontFamily: 'childFont',
              ),
            ),
      ),
    );
  }
}
