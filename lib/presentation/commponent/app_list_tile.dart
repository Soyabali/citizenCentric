import 'package:citizencentric/presentation/commponent/platform_text.dart';
import 'package:flutter/material.dart';
import '../resources/text_type.dart';
import 'AppIcon.dart';
import 'background_image.dart';

class AppListTile extends StatelessWidget {
  final String title;
  final String? assetImage;
  final IconData? leadingIcon;
  final IconData trailingIcon;
  final VoidCallback onTap;

  const AppListTile({
    super.key,
    required this.title,
    this.assetImage,
    this.leadingIcon,
    this.trailingIcon = Icons.arrow_forward_ios,
    required this.onTap,
  }) : assert(
  assetImage != null || leadingIcon != null,
  'Either assetImage or leadingIcon must be provided',
  );

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 4,
      ),
      leading: _buildLeading(),
      title:PlatformText(
        title,
        type: AppTextType.subtitle,
        color: Colors.black54,
      ),
      trailing: InkWell(
        onTap: onTap,
        child: AppIcon(
          icon: trailingIcon,
          size: 20,
        ),
      ),

      onTap: onTap,
    );
  }

  Widget _buildLeading() {
    return Container(
      height: 50,
      width: 50,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(3),
          child: assetImage != null
              ? BackgroundImage(
            imagePath: assetImage!,
            fit: BoxFit.cover,
          )   //Image.asset(assetImage!, fit: BoxFit.cover)
              :  AppIcon(
                 icon: Icons.home,
                 color: Colors.red,
                 onTap: (){
                   print("----clicked----");
                 },
          ) //Icon(leadingIcon, color: Colors.grey),
        ),
      ),
    );
  }
}
