
import 'package:flutter/material.dart';
import '../commponent/background_image.dart';
import '../commponent/platform_text.dart';
import '../resources/text_type.dart';

class ActionCard extends StatelessWidget {
  final String image;
  final String title;
  final VoidCallback onTap;

  const ActionCard({
    required this.image,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(6),
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.grey.shade300, width: 1),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // background image class
              BackgroundImage(
                imagePath: image,
                fit: BoxFit.cover,
                width: 60,
                height: 60,
              ),
              const SizedBox(height: 5),
              // here you should used Textclass
              PlatformText(
                title,
                type: AppTextType.subtitle,
                color: Colors.black54,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
