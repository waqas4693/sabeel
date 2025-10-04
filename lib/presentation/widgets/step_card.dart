import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:ui';
import 'package:visibility_detector/visibility_detector.dart';

class StepCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final String description;
  final String? quote;
  final String iconSvg;
  final int stepNumber;
  const StepCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.iconSvg,
    required this.stepNumber,
    this.quote,
  }) : super(key: key);

  @override
  State<StepCard> createState() => _StepCardState();
}

class _StepCardState extends State<StepCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnim;
  late Animation<Offset> _slideAnim;
  late Animation<double> _topLineAnim;
  late Animation<double> _rightLineAnim;
  bool _hasAnimated = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _opacityAnim = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic),
        );
    _topLineAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeInOutCubic),
      ),
    );
    _rightLineAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeInOutCubic),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    if (!_hasAnimated && info.visibleFraction > 0.5) {
      _controller.forward();
      _hasAnimated = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('step_card_${widget.stepNumber}'),
      onVisibilityChanged: _onVisibilityChanged,
      child: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return AnimatedSlide(
              offset: _slideAnim.value,
              duration: const Duration(milliseconds: 700),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 768),
                margin: const EdgeInsets.symmetric(
                  vertical: 48,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromRGBO(0, 0, 0, 0.25),
                      offset: const Offset(0, 25),
                      blurRadius: 50,
                      spreadRadius: -12,
                    ),
                  ],
                ),
                child: Stack(
                  clipBehavior: Clip.hardEdge,
                  children: [
                    // Card background
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        color: Colors.white.withOpacity(0.1),
                        padding: const EdgeInsets.symmetric(
                          vertical: 48,
                          horizontal: 32,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // SVG icon inside the card
                            SvgPicture.string(
                              widget.iconSvg,
                              width: 64,
                              height: 64,
                              color: Colors.white,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Step ${widget.stepNumber}',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              widget.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              widget.description,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            if (widget.quote != null) ...[
                              const SizedBox(height: 24),
                              Text(
                                widget.quote!,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 18,
                                  fontStyle: FontStyle.italic,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    // Animated border lines
                    _AnimatedBorderLines(
                      topProgress: _topLineAnim.value,
                      rightProgress: _rightLineAnim.value,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _AnimatedBorderLines extends StatelessWidget {
  final double topProgress;
  final double rightProgress;
  const _AnimatedBorderLines({
    required this.topProgress,
    required this.rightProgress,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: CustomPaint(
          painter: _BorderLinesPainter(
            topProgress: topProgress,
            rightProgress: rightProgress,
          ),
        ),
      ),
    );
  }
}

class _BorderLinesPainter extends CustomPainter {
  final double topProgress;
  final double rightProgress;
  _BorderLinesPainter({required this.topProgress, required this.rightProgress});

  @override
  void paint(Canvas canvas, Size size) {
    // Define inset distance (adjust this value to control how far inside the lines are)
    const double inset = 4.0;

    final Paint paint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF8b5cf6), Color(0xFFd946ef), Color(0xFFf97316)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    // Top line: from center to both ends (moved inside by inset)
    if (topProgress > 0) {
      final double topY = inset; // Move line down from top edge
      final double centerX = size.width * 0.5;
      final double lineLength =
          (size.width * 0.5) - inset; // Adjust line length for inset

      // Left from center
      canvas.drawLine(
        Offset(centerX, topY),
        Offset(centerX - lineLength * topProgress, topY),
        paint,
      );
      // Right from center
      canvas.drawLine(
        Offset(centerX, topY),
        Offset(centerX + lineLength * topProgress, topY),
        paint,
      );
    }

    // Right line: from top right to bottom right (moved inside by inset)
    if (rightProgress > 0) {
      final double rightX =
          size.width - inset; // Move line left from right edge
      final double lineHeight =
          size.height - (inset * 2); // Adjust line height for inset

      canvas.drawLine(
        Offset(rightX, inset), // Start from inset distance from top
        Offset(
          rightX,
          inset + lineHeight * rightProgress,
        ), // End at calculated position
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _BorderLinesPainter oldDelegate) {
    return topProgress != oldDelegate.topProgress ||
        rightProgress != oldDelegate.rightProgress;
  }
}
