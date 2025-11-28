import 'dart:ui';

import 'package:flutter/material.dart';

class Glassmorphism extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry padding;

  const Glassmorphism({
    required this.child,
    this.borderRadius = 20,
    this.padding = const EdgeInsets.all(0),
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final bg = Theme.of(context).brightness == Brightness.dark
        ? Colors.white.withAlpha((0.06 * 255).toInt())
        : Colors.white.withAlpha((0.35 * 255).toInt());
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: Colors.white.withAlpha((0.12 * 255).toInt()),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha((0.06 * 255).toInt()),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

class GlassSection extends StatelessWidget {
  final Widget child;
  const GlassSection({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Glassmorphism(
      child: Padding(padding: const EdgeInsets.all(18.0), child: child),
    );
  }
}
