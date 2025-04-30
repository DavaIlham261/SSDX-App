import 'dart:ui';

import 'package:flutter/material.dart';

class GlassSidebar extends StatelessWidget {
  final double blurSigma;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final Widget child;

  const GlassSidebar({
    super.key,
    required this.child,
    this.blurSigma = 15,
    this.borderRadius = 30,
    this.padding = const EdgeInsets.symmetric(horizontal: 20),
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: Container(
          height: 60,
          decoration: _decoration(),
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }

  BoxDecoration _decoration() {
    return BoxDecoration(
      color: const Color.fromRGBO(255, 255, 255, 0.3),
      boxShadow: [
        BoxShadow(
          // color: const Color.fromRGBO(0, 0, 0, 0.5),
          color: const Color.fromRGBO(0, 0, 0, 0),
          blurRadius: borderRadius,
          spreadRadius: -5,
        ),
      ],
      borderRadius: BorderRadius.circular(30),
      border: Border.all(color: Colors.white30, width: 2),
      gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                const Color.fromRGBO(255, 255, 255, 0.8),
                const Color.fromRGBO(255, 255, 255, 0.3),
              ],
              stops: const [0.0, 1.0],
            ),
      
      // LinearGradient(
      //   colors: [Colors.white54, Colors.white10],
      //   begin: Alignment.centerLeft,
      //   end: Alignment.centerRight,
      // ),
    );
  }
}
