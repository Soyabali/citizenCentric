import 'package:flutter/material.dart';

class ContainerDecoration {

  static BoxDecoration container({
    Color color = Colors.white,
    BorderRadius? borderRadius,
    List<BoxShadow>? boxShadow,
    DecorationImage? backgroundImage,
    double opacity = 1.0,
    Border? border,
  }) {
    return BoxDecoration(
      color: color.withOpacity(opacity),
      borderRadius: borderRadius,
      boxShadow: boxShadow,
      image: backgroundImage,
      border: border,
    );
  }
}

