// ignore_for_file: deprecated_member_use

import 'dart:ui';
import 'package:flutter/material.dart';

class GlassSidebar extends StatefulWidget {
  final double blurSigma;
  final double blurRadius;
  final double spreadRadius;
  final double? width;
  final double height;
  final EdgeInsetsGeometry padding;
  final Widget child;
  final double glowIntensity;
  final double scaleFactor;
  final bool enableParticles;

  const GlassSidebar({
    super.key,
    required this.child,
    this.blurSigma = 12,
    this.blurRadius = 25,
    this.spreadRadius = -8,
    this.width,
    this.height = 60,
    this.padding = const EdgeInsets.symmetric(horizontal: 20),
    this.glowIntensity = 0.0,
    this.enableParticles = false,
    this.scaleFactor = 1.03,
  });

  @override
  State<GlassSidebar> createState() => _GlassSidebarState();
}

class _GlassSidebarState extends State<GlassSidebar>
    with TickerProviderStateMixin {
  bool _isHovering = false;
  late AnimationController _hoverController;
  late AnimationController _particleController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();

    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _particleController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: widget.scaleFactor).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeOutBack),
    );

    _glowAnimation = Tween<double>(
      begin: 0.0,
      end: .1,
    ).animate(CurvedAnimation(parent: _hoverController, curve: Curves.easeOut));

    if (widget.enableParticles) {
      _particleController.repeat();
    }
  }

  @override
  void dispose() {
    _hoverController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovering = true);
        _hoverController.forward();
      },
      onExit: (_) {
        setState(() => _isHovering = false);
        _hoverController.reverse();
      },
      child: AnimatedBuilder(
        animation: Listenable.merge([_hoverController, _particleController]),
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  // Main glow effect
                  BoxShadow(
                    color: const Color(0xFF667eea).withOpacity(
                      0.2 +
                          (_glowAnimation.value * 0.3) +
                          (widget.glowIntensity * 0.2),
                    ),
                    blurRadius: widget.blurRadius + (_glowAnimation.value * 10),
                    spreadRadius: widget.spreadRadius,
                  ),
                  // Inner glow
                  BoxShadow(
                    color: Colors.white.withOpacity(
                      0.1 + (_glowAnimation.value * 0.2),
                    ),
                    blurRadius: 5,
                    spreadRadius: -3,
                    offset: const Offset(0, -1),
                  ),
                  // Colored edge glow
                  BoxShadow(
                    color: const Color(
                      0xFF764ba2,
                    ).withOpacity(_glowAnimation.value * 0.2),
                    blurRadius: 20,
                    spreadRadius: -5,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: widget.blurSigma,
                    sigmaY: widget.blurSigma,
                  ),
                  child: Stack(
                    children: [
                      // Main glass container
                      Container(
                        width: widget.width,
                        height: widget.height,
                        decoration: _buildGlassDecoration(),
                        child: Padding(
                          padding: widget.padding,
                          child: widget.child,
                        ),
                      ),
                      // Particle effect overlay
                      if (widget.enableParticles && _isHovering)
                        Positioned.fill(child: _buildParticleOverlay()),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  BoxDecoration _buildGlassDecoration() {
    final glowIntensity = _glowAnimation.value + widget.glowIntensity;

    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withOpacity(0.25 + (glowIntensity * 0.15)),
          Colors.white.withOpacity(0.05 + (glowIntensity * 0.1)),
          Colors.white.withOpacity(0.15 + (glowIntensity * 0.1)),
        ],
        stops: const [0.0, 0.5, 1.0],
      ),
      borderRadius: BorderRadius.circular(30),
      border: Border.all(
        width: 1.5,
        color: Colors.white.withOpacity(0.2 + (glowIntensity * 0.2)),
      ),
    );
  }

  Widget _buildParticleOverlay() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: RadialGradient(
          center: Alignment(
            0.5 + (_particleController.value * 0.3 - 0.15),
            0.5 + (_particleController.value * 0.2 - 0.1),
          ),
          radius: 0.8,
          colors: [
            const Color(0xFF667eea).withOpacity(0.1),
            const Color(0xFF764ba2).withOpacity(0.05),
            Colors.transparent,
          ],
        ),
      ),
    );
  }
}
