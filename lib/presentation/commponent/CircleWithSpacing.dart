import 'package:flutter/material.dart';

class CircleWithSpacing extends StatelessWidget {

  final double diameter;
  final Color color;
  final double spacing;

  const CircleWithSpacing({
    Key? key,
    this.diameter = 12.0, // Default diameter of the circle
    this.color = Colors.black45, // Default color
    this.spacing = 5.0, // Default spacing
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: diameter,
          height: diameter,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
        SizedBox(width: spacing),
      ],
    );
  }
}
