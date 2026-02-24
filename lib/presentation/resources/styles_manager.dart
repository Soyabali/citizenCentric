
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'font_manager.dart';

// base TextStyle

TextStyle _baseTextStyle({
  required double fontSize,
  required FontWeight fontWeight,
  required Color color,
}) {
  return TextStyle(
    fontSize: fontSize,
    fontWeight: fontWeight,
    fontFamily: FontConstants.fontFamily,// add a fontfamily here
    color: color,
    letterSpacing: defaultTargetPlatform == TargetPlatform.iOS ? 0.2 : 0.0,
    height: 1.4, // better readability (Android + iOS)
  );
}

/// =========================
/// 🔹 SEMANTIC TEXT STYLES
/// =========================

// Headlines (Screen titles)
TextStyle getHeadlineStyle({required Color color}) {
  return _baseTextStyle(
    fontSize: FontSize.s20,
    fontWeight: FontWeightManager.bold,
    color: color,
  );
}

// Titles (Card / Section title)

TextStyle getTitleStyle({required Color color}) {
  return _baseTextStyle(
    fontSize: FontSize.s18,
    fontWeight: FontWeightManager.semiBold,
    color: color,
  );
}
// Subtitle
TextStyle getSubtitleStyle({required Color color}) {
  return _baseTextStyle(
    fontSize: FontSize.s16,
    fontWeight: FontWeightManager.medium,
    color: color,
  );
}

// Body text (most used)
TextStyle getBodyStyle({required Color color}) {
  return _baseTextStyle(
    fontSize: FontSize.s14,
    fontWeight: FontWeightManager.regular,
    color: color,
  );
}

// Caption / helper text
TextStyle getCaptionStyle({required Color color}) {
  return _baseTextStyle(
    fontSize: FontSize.s12,
    fontWeight: FontWeightManager.light,
    color: color,
  );
}

// Button text
TextStyle getButtonStyle({required Color color}) {
  return _baseTextStyle(
    fontSize: FontSize.s14,
    fontWeight: FontWeightManager.semiBold,
    color: color,
  );
}
/// =========================
/// 🔹 TEXTFIELD SEMANTIC STYLES (NEW ✅)
/// =========================

// Input text
TextStyle getInputTextStyle({required Color color}) {
  return _baseTextStyle(
    fontSize: FontSize.s14,
    fontWeight: FontWeightManager.regular,
    color: color,
  );
}

// Label text
TextStyle getLabelStyle({required Color color}) {
  return _baseTextStyle(
    fontSize: FontSize.s13,
    fontWeight: FontWeightManager.medium,
    color: color,
  );
}

// Hint text
TextStyle getHintStyle({required Color color}) {
  return _baseTextStyle(
    fontSize: FontSize.s13,
    fontWeight: FontWeightManager.regular,
    color: color.withOpacity(0.7),
  );
}

// Error text
TextStyle getErrorStyle({required Color color}) {
  return _baseTextStyle(
    fontSize: FontSize.s12,
    fontWeight: FontWeightManager.regular,
    color: color,
  );
}
