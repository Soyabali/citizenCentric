import 'package:flutter/material.dart';

class AppImages {
  static DecorationImage decoration({
    required String asset,
    BoxFit fit = BoxFit.cover,
    Alignment alignment = Alignment.center,
  }) {
    return DecorationImage(
      image: AssetImage(asset),
      fit: fit,
      alignment: alignment,
    );
  }
}
