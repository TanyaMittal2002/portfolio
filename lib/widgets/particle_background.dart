import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class ParticleBackground extends StatefulWidget {
  const ParticleBackground({super.key});

  @override
  State<ParticleBackground> createState() => _ParticleBackgroundState();
}

class _ParticleBackgroundState extends State<ParticleBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final List<_Particle> _particles = [];
  final Random _random = Random();
  Offset? _cursor;
  Size _canvasSize = Size.zero;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 16000),
    )..addListener(_tickParticles);
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_tickParticles)
      ..dispose();
    super.dispose();
  }

  void _ensureParticles(Size size) {
    if (_particles.isNotEmpty && size == _canvasSize) return;
    _canvasSize = size;
    _particles
      ..clear()
      ..addAll(List.generate(70, (_) => _spawnParticle(size)));
  }

  _Particle _spawnParticle(Size size) {
    final pos = Offset(
      _random.nextDouble() * size.width,
      _random.nextDouble() * size.height,
    );
    final speed = 0.15 + _random.nextDouble() * 0.35;
    final heading = _random.nextDouble() * 2 * pi;
    final velocity = Offset(
      cos(heading) * speed,
      sin(heading) * speed,
    );
    final baseColor = const Color(0xFF7A4DFF);
    final tint = HSVColor.fromColor(baseColor)
        .withHue((HSVColor.fromColor(baseColor).hue + _random.nextDouble() * 20) % 360)
        .withSaturation(0.7 + _random.nextDouble() * 0.2)
        .withValue(0.9);

    return _Particle(
      position: pos,
      velocity: velocity,
      size: 1.6 + _random.nextDouble() * 2.4,
      color: tint.toColor().withOpacity(0.25 + _random.nextDouble() * 0.35),
    );
  }

  void _tickParticles() {
    if (!mounted || _canvasSize == Size.zero) return;

    for (var i = 0; i < _particles.length; i++) {
      final p = _particles[i];

      // Gentle attraction to cursor, otherwise wander.
      Offset attraction = Offset.zero;
      if (_cursor != null) {
        final toCursor = _cursor! - p.position;
        final double dist = toCursor.distance.clamp(1, 400).toDouble();
        attraction = (toCursor / dist) * 0.7;
      } else {
        attraction = Offset(
          (_random.nextDouble() - 0.5) * 0.2,
          (_random.nextDouble() - 0.5) * 0.2,
        );
      }

      final nextVelocity = (p.velocity + attraction) * 0.97;
      final nextPos = p.position + nextVelocity;

      Offset wrappedPos = nextPos;
      if (nextPos.dx < -30 || nextPos.dx > _canvasSize.width + 30) {
        wrappedPos = Offset(
          nextPos.dx < 0 ? _canvasSize.width + 10 : -10,
          nextPos.dy,
        );
      }
      if (nextPos.dy < -30 || nextPos.dy > _canvasSize.height + 30) {
        wrappedPos = Offset(
          wrappedPos.dx,
          nextPos.dy < 0 ? _canvasSize.height + 10 : -10,
        );
      }

      _particles[i] = p.copyWith(position: wrappedPos, velocity: nextVelocity);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final size = constraints.biggest;
          _ensureParticles(size);

          return MouseRegion(
            opaque: false,
            onHover: (event) => _cursor = event.localPosition,
            onExit: (_) => _cursor = null,
            child: CustomPaint(
              size: size,
              painter: _ParticlePainter(
                particles: _particles,
                glowColor: const Color(0xFF4B2EFF).withOpacity(0.12),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final Color glowColor;

  _ParticlePainter({
    required this.particles,
    required this.glowColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final glowPaint = Paint()
      ..color = glowColor
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18.0);

    final dotPaint = Paint()..strokeCap = StrokeCap.round;

    for (final p in particles) {
      canvas.drawCircle(p.position, p.size * 2.6, glowPaint);
      dotPaint.color = p.color;
      dotPaint.strokeWidth = p.size;
      canvas.drawPoints(ui.PointMode.points, [p.position], dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _Particle {
  final Offset position;
  final Offset velocity;
  final double size;
  final Color color;

  _Particle({
    required this.position,
    required this.velocity,
    required this.size,
    required this.color,
  });

  _Particle copyWith({
    Offset? position,
    Offset? velocity,
  }) {
    return _Particle(
      position: position ?? this.position,
      velocity: velocity ?? this.velocity,
      size: size,
      color: color,
    );
  }
}
