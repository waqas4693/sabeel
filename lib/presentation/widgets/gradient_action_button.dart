import 'package:flutter/material.dart';

class GradientActionButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool enabled;
  final Widget? icon;
  final EdgeInsetsGeometry? padding;
  final bool
  iconPrefix; 

  const GradientActionButton({
    super.key,
    required this.text,
    this.onPressed,
    this.enabled = true,
    this.icon,
    this.padding,
    this.iconPrefix = false,
  });

  @override
  State<GradientActionButton> createState() => _GradientActionButtonState();
}

class _GradientActionButtonState extends State<GradientActionButton> {
  @override
  Widget build(BuildContext context) {
    final gradient = const LinearGradient(
      colors: [Color(0xFF1e3a5f), Color(0xFF2d5283)],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    );

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: widget.enabled ? 1.0 : 0.6,
      child: Container(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(10),
          border: const Border.fromBorderSide(
            BorderSide(color: Color(0x4D4299e1), width: 2),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: const Offset(0, 20),
              blurRadius: 25,
              spreadRadius: -5,
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: const Offset(0, 8),
              blurRadius: 10,
              spreadRadius: -6,
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: widget.enabled ? widget.onPressed : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
            shadowColor: Colors.transparent,
            elevation: 0,
            padding:
                widget.padding ??
                const EdgeInsets.symmetric(horizontal: 35, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon prefix (before text)
              if (widget.iconPrefix && widget.icon != null) ...[
                widget.icon!,
                const SizedBox(width: 8),
              ],
              // Text
              Text(
                widget.text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.2,
                ),
              ),
              // Icon suffix (after text)
              if (!widget.iconPrefix && widget.icon != null) ...[
                const SizedBox(width: 8),
                widget.icon!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
