import 'package:flutter/material.dart';

class AppIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;
  final double opacity;
  final VoidCallback? onTap;

  const AppIcon({
    super.key,
    required this.icon,
    this.color = Colors.grey,
    this.size = 24,
    this.opacity = 1.0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final iconWidget = Opacity(
      opacity: opacity.clamp(0.0, 1.0),
      child: Icon(
        icon,
        color: color,
        size: size,
      ),
    );

    // If callback exists → make it clickable
    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(size),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: iconWidget,
        ),
      );
    }

    return iconWidget;
  }
}
