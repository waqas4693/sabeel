import 'package:flutter/material.dart';

class GradientPillButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool enabled;
  final Widget? icon;
  final EdgeInsetsGeometry? padding;
  final bool fullWidth;
  final bool iconPrefix;

  const GradientPillButton({
    super.key,
    required this.text,
    this.onPressed,
    this.enabled = true,
    this.icon,
    this.padding,
    this.fullWidth = false,
    this.iconPrefix = false,
  });

  @override
  State<GradientPillButton> createState() => _GradientPillButtonState();
}

class _GradientPillButtonState extends State<GradientPillButton> {
  @override
  Widget build(BuildContext context) {
    final gradient = const LinearGradient(
      colors: [Color(0xFF1EAEDB), Color(0xFF33C3F0)],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    );

    Widget buttonContent = AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: widget.enabled ? 1.0 : 0.6,
      child: Container(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(9999), // Pill shape
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF33C3F0).withOpacity(0.3),
              blurRadius: 16,
              spreadRadius: 1,
              offset: const Offset(0, 4),
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
                const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            minimumSize: const Size(0, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(9999), // Pill shape
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
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
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  letterSpacing: 1.1,
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

    if (widget.fullWidth) {
      return SizedBox(width: double.infinity, child: buttonContent);
    }
    return buttonContent;
  }
}
