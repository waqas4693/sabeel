import 'dart:math';
import 'package:flutter/material.dart';

class CustomParticlesBackground extends StatefulWidget {
  final int numberOfParticles;
  final Color color;
  final double opacity;
  final double maxSize;
  final double minSize;
  final double speed;
  const CustomParticlesBackground({
    Key? key,
    this.numberOfParticles = 10,
    this.color = Colors.white,
    this.opacity = 0.5,
    this.maxSize = 7,
    this.minSize = 2,
    this.speed = 0.1,
  }) : super(key: key);

  @override
  State<CustomParticlesBackground> createState() =>
      _CustomParticlesBackgroundState();
}

class _CustomParticlesBackgroundState extends State<CustomParticlesBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_Particle> _particles;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1))
          ..addListener(() {
            setState(() {});
          })
          ..repeat();
    _initParticles();
  }

  void _initParticles() {
    _particles = List.generate(widget.numberOfParticles, (index) {
      final size =
          widget.minSize +
          _random.nextDouble() * (widget.maxSize - widget.minSize);
      final position = Offset(_random.nextDouble(), _random.nextDouble());
      final direction =
          Offset(
            (_random.nextDouble() - 0.5) * 2,
            (_random.nextDouble() - 0.5) * 2,
          ).normalize();
      final speed = widget.speed * (0.5 + _random.nextDouble());
      return _Particle(
        position: position,
        direction: direction,
        size: size,
        speed: speed,
        color: widget.color.withOpacity(widget.opacity),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h = constraints.maxHeight;
        _updateParticles(w, h);
        return CustomPaint(
          painter: _ParticlesPainter(_particles, w, h),
          size: Size(w, h),
        );
      },
    );
  }

  void _updateParticles(double w, double h) {
    for (final p in _particles) {
      p.position += p.direction * p.speed / 100.0;
      // Wrap around the screen
      if (p.position.dx < 0) p.position = Offset(1, p.position.dy);
      if (p.position.dx > 1) p.position = Offset(0, p.position.dy);
      if (p.position.dy < 0) p.position = Offset(p.position.dx, 1);
      if (p.position.dy > 1) p.position = Offset(p.position.dx, 0);
    }
  }
}

class _Particle {
  Offset position;
  Offset direction;
  double size;
  double speed;
  Color color;
  _Particle({
    required this.position,
    required this.direction,
    required this.size,
    required this.speed,
    required this.color,
  });
}

class _ParticlesPainter extends CustomPainter {
  final List<_Particle> particles;
  final double width;
  final double height;
  _ParticlesPainter(this.particles, this.width, this.height);

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final paint =
          Paint()
            ..color = p.color
            ..style = PaintingStyle.fill;
      canvas.drawCircle(
        Offset(p.position.dx * width, p.position.dy * height),
        p.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

extension on Offset {
  Offset normalize() {
    final len = distance;
    if (len == 0) return this;
    return this / len;
  }
}
