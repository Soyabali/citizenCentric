import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../resources/platformButtonType.dart';
import '../resources/styles_manager.dart';


class PlatformPrimaryButton extends StatelessWidget {

  final String label;
  final VoidCallback? onPressed;
  final double height;
  final double width;
  final Color? backgroundColor;
  final EdgeInsetsGeometry padding;
  final PlatformButtonType buttonType;

  const PlatformPrimaryButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.height = 48,
    this.width = double.infinity,
    this.backgroundColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
    this.buttonType = PlatformButtonType.primary,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isIOS = defaultTargetPlatform == TargetPlatform.iOS;

    return SizedBox(
      width: width,
      height: height,
      child: isIOS ? _cupertinoButton(context) : _materialButton(context),
    );
  }

  // =======================
  // COMMON STYLE HANDLERS
  // =======================

  BorderRadius _borderRadius() {
    switch (buttonType) {
      case PlatformButtonType.stadium:
        return BorderRadius.circular(100);
      case PlatformButtonType.roundedSmall:
        return BorderRadius.circular(6);
      case PlatformButtonType.outline:
      case PlatformButtonType.primary:
        return BorderRadius.circular(10);
      case PlatformButtonType.text:
        return BorderRadius.zero;
    }
  }

  EdgeInsetsGeometry _resolvedPadding() {
    switch (buttonType) {
      case PlatformButtonType.stadium:
        return const EdgeInsets.symmetric(horizontal: 28);
      case PlatformButtonType.text:
        return EdgeInsets.zero;
      default:
        return padding;
    }
  }

  bool get _isOutline => buttonType == PlatformButtonType.outline;
  bool get _isText => buttonType == PlatformButtonType.text;

  // =======================
  // 🍎 iOS BUTTON
  // =======================

  Widget _cupertinoButton(BuildContext context) {
    if (_isText) {
      return CupertinoButton(
        padding: _resolvedPadding(),
        onPressed: onPressed,
        child: Text(
          label,
          style: getButtonStyle(color: CupertinoColors.activeBlue),
        ),
      );
    }

    return CupertinoButton(
      padding: _resolvedPadding(),
      borderRadius: _borderRadius(),
      color: _isOutline
          ? CupertinoColors.transparent
          : backgroundColor ?? CupertinoColors.activeBlue,
      disabledColor: CupertinoColors.systemGrey3,
      onPressed: onPressed,
      child: Text(
        label,
        style: getButtonStyle(
          color: _isOutline
              ? CupertinoColors.activeBlue
              : CupertinoColors.white,
        ),
      ),
    );
  }

  // =======================
  // 🤖 ANDROID BUTTON
  // =======================

  Widget _materialButton(BuildContext context) {
    if (_isText) {
      return TextButton(
        onPressed: onPressed,
        child: Text(
          label,
          style: getButtonStyle(color: Theme.of(context).primaryColor),
        ),
      );
    }

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        elevation: _isOutline ? 0 : 2,
        backgroundColor: _isOutline
            ? Colors.transparent
            : backgroundColor ?? Theme.of(context).primaryColor,
        disabledBackgroundColor: Colors.grey.shade400,
        padding: _resolvedPadding(),
        shape: RoundedRectangleBorder(
          borderRadius: _borderRadius(),
          side: _isOutline
              ? BorderSide(
            color: Theme.of(context).primaryColor,
          )
              : BorderSide.none,
        ),
      ),
      child: Text(
        label,
        style: getButtonStyle(
          color: _isOutline ? Theme.of(context).primaryColor : Colors.white,
        ),
      ),
    );
  }
}
