
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../resources/styles_manager.dart';
import '../resources/text_type.dart';

class PlatformText extends StatelessWidget {
  final String text;
  final AppTextType type;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool? softWrap;

  const PlatformText(
      this.text, {
        Key? key,
        this.type = AppTextType.body,
        this.color,
        this.textAlign,
        this.maxLines,
        this.overflow,
        this.softWrap
      }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // pick a platform
    final bool isIOS = defaultTargetPlatform == TargetPlatform.iOS;

    TextStyle style = _getTextStyleByType(
      type: type,
      context: context,
      isIOS: isIOS,
    );
    // Override color if provided
    if (color != null) {
      style = style.copyWith(color: color);
    }

    return Text(
      text,
      style: style,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
    );
  }

  TextStyle _getTextStyleByType({
    required AppTextType type,
    required BuildContext context,
    required bool isIOS,
  }) {
    switch (type) {
      case AppTextType.headline:
        return getHeadlineStyle(
          color: isIOS ? CupertinoColors.label : Colors.black87,
        );

      // case AppTextType.title:
      //   return getTitleStyle(
      //     color: isIOS ? CupertinoColors.label : Colors.black87,
      //   );
      case AppTextType.title:
        return getTitleStyle(
          color: isIOS ? CupertinoColors.white : Colors.black87,
        );

      case AppTextType.subtitle:
        return getSubtitleStyle(
          color: isIOS ? CupertinoColors.secondaryLabel : Colors.black54,
        );

      case AppTextType.body:
        return getBodyStyle(
          color: isIOS ? CupertinoColors.label : Colors.black87,
        );

      case AppTextType.caption:
        return getCaptionStyle(
          color: isIOS ? CupertinoColors.secondaryLabel : Colors.grey,
        );

      case AppTextType.button:
        return getButtonStyle(
          color: isIOS ? CupertinoColors.white : Colors.white,
        );
    }
  }
}
