// Fungsi untuk membuat tombol bulat
import 'package:flutter/material.dart';

class CircleButton extends StatelessWidget {
  final IconData iconData;
  final double iconSize;
  final Color buttonColor;
  final VoidCallback? onPressed;

  const CircleButton({
    super.key,
    required this.iconData,
    required this.iconSize,
    required this.buttonColor,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: buttonColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                iconData,
                size: iconSize, // Atur ukuran icon agar pas
                color: Colors.white,
                
              ),
            ),
          ),
        ),
      ),
    );
  }
}
