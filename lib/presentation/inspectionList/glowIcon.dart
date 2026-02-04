import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GlowIcon extends StatefulWidget {
  const GlowIcon({super.key});

  @override
  State<GlowIcon> createState() => _GlowIconState();
}

class _GlowIconState extends State<GlowIcon>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(
      begin: 0.2,
      end: 0.8,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(_glowAnimation.value),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: child,
        );
      },
      child: const Icon(
        Icons.arrow_forward_ios,
        size: 25,
        color: Colors.red,
      ),
    );
  }
}
