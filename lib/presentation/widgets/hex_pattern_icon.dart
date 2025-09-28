import 'package:flutter/material.dart';
import 'dart:math' as math;

class HexPatternIcon extends StatelessWidget {
  final double size;
  final Color color;
  final double opacity;
  const HexPatternIcon({
    Key? key,
    this.size = 96,
    this.color = const Color(0xFFB0C4DE),
    this.opacity = 0.08,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(size),
      painter: _HexPatternPainter(color: color, opacity: opacity),
    );
  }
}

class _HexPatternPainter extends CustomPainter {
  final Color color;
  final double opacity;
  _HexPatternPainter({required this.color, this.opacity = 0.08});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color.withOpacity(opacity)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.2;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2.2;
    // Draw main hexagon
    _drawHexagon(canvas, center, radius, paint);
    // Draw inner hexagon
    _drawHexagon(canvas, center, radius * 0.75, paint);
    // Draw inner circle
    canvas.drawCircle(center, radius * 0.6, paint);
    // Draw outer circle
    canvas.drawCircle(center, radius, paint);
    // Draw star (two triangles)
    _drawStar(canvas, center, radius * 0.85, paint);
  }

  void _drawHexagon(Canvas canvas, Offset center, double radius, Paint paint) {
    final path = Path();
    for (int i = 0; i < 6; i++) {
      final angle = (i * 60.0 - 30.0) * math.pi / 180.0;
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawStar(Canvas canvas, Offset center, double radius, Paint paint) {
    // Draw two equilateral triangles, one pointing up, one down
    final path1 = Path();
    final path2 = Path();
    for (int i = 0; i < 3; i++) {
      final angle1 = (i * 120.0 - 90.0) * math.pi / 180.0;
      final x1 = center.dx + radius * math.cos(angle1);
      final y1 = center.dy + radius * math.sin(angle1);
      if (i == 0) {
        path1.moveTo(x1, y1);
      } else {
        path1.lineTo(x1, y1);
      }
      final angle2 = (i * 120.0 - 30.0) * math.pi / 180.0;
      final x2 = center.dx + radius * math.cos(angle2);
      final y2 = center.dy + radius * math.sin(angle2);
      if (i == 0) {
        path2.moveTo(x2, y2);
      } else {
        path2.lineTo(x2, y2);
      }
    }
    path1.close();
    path2.close();
    canvas.drawPath(path1, paint);
    canvas.drawPath(path2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
