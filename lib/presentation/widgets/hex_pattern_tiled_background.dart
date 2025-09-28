import 'package:flutter/material.dart';
import 'hex_pattern_icon.dart';

class HexPatternTiledBackground extends StatelessWidget {
  final double iconSize;
  final double opacity;
  final Color color;
  const HexPatternTiledBackground({
    this.iconSize = 96,
    this.opacity = 0.08,
    this.color = const Color(0xFFFFFFFF),
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h = constraints.maxHeight;
        final List<Widget> tiles = [];
        final double vertDist = iconSize * 0.75;
        for (double y = 0; y < h + iconSize; y += vertDist) {
          for (double x = 0; x < w + iconSize; x += iconSize * 1.75) {
            final dx =
                ((y / vertDist).floor() % 2 == 0) ? x : x + iconSize * 0.875;
            tiles.add(
              Positioned(
                left: dx,
                top: y,
                child: HexPatternIcon(
                  size: iconSize,
                  color: color,
                  opacity: opacity,
                ),
              ),
            );
          }
        }
        return Stack(children: tiles);
      },
    );
  }
}
