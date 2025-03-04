import 'package:flutter/material.dart';

class RoundedPillButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final IconData icon;
  final Color backgroundColor;
  final Color textColor;
  final Color iconColor;
  final double? width;
  final double? radius;

  const RoundedPillButton({super.key, 
    required this.onPressed,
    required this.text,
    required this.icon,
    this.backgroundColor = Colors.blue,
    this.textColor = Colors.white,
    this.iconColor = Colors.white,
    this.width, // Allow width to be optional
    this.radius
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius ?? 30.0),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        ),
        child: Row(
          mainAxisSize: width == null ? MainAxisSize.min : MainAxisSize.max, // Adjust based on width
          children: [
            Icon(icon, color: iconColor),
            const SizedBox(width: 8.0),
            Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: 16.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
