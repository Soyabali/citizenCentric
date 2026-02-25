import 'package:citizencentric/presentation/resources/styles_manager.dart';
import 'package:citizencentric/presentation/resources/values_manager.dart';
import 'package:flutter/material.dart';
import 'color_manager.dart';

ThemeData getApplicationTheme() {
  return ThemeData(
    // =====================
    // 🌈 Colors
    // =====================
    primaryColor: ColorManager.primary,
    primaryColorLight: ColorManager.primaryOpacity70,
    primaryColorDark: ColorManager.darkPrimary,
    disabledColor: ColorManager.grey1,
    hintColor: ColorManager.grey,

    // =====================
    // 🧱 Scaffold
    // =====================
    scaffoldBackgroundColor: ColorManager.white,

    // =====================
    // 🃏 Card Theme
    // =====================
    cardTheme: CardThemeData(
      color: ColorManager.white,
      shadowColor: ColorManager.grey,
      elevation: AppSize.s4,
    ),

    // =====================
    // 📱 AppBar Theme
    // =====================
    appBarTheme: AppBarTheme(
      centerTitle: true,
      backgroundColor: ColorManager.primary,
      elevation: AppSize.s4,
      shadowColor: ColorManager.primaryOpacity70,
      titleTextStyle: getTitleStyle(color: ColorManager.white),
      iconTheme: const IconThemeData(color: Colors.white),
    ),

    // =====================
    // 🔘 Buttons
    // =====================
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorManager.primary,
        textStyle: getButtonStyle(color: Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSize.s12),
        ),
      ),
    ),

    // =====================
    // 🅰 Text Theme (Semantic Mapping)
    // =====================
    textTheme: TextTheme(
      headlineLarge: getHeadlineStyle(color: ColorManager.darkGrey),
      titleLarge: getTitleStyle(color: ColorManager.darkGrey),
      titleMedium: getSubtitleStyle(color: ColorManager.darkGrey),
      bodyLarge: getBodyStyle(color: ColorManager.grey),
      bodyMedium: getBodyStyle(color: ColorManager.grey1),
      bodySmall: getCaptionStyle(color: ColorManager.grey1),
      labelLarge: getButtonStyle(color: ColorManager.white),
    ),

    // =====================
    // ✏️ Input Fields
    // =====================
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(AppPadding.p8),

      hintStyle: getCaptionStyle(color: ColorManager.grey1),
      labelStyle: getBodyStyle(color: ColorManager.darkGrey),
      errorStyle: getCaptionStyle(color: ColorManager.error),

      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: ColorManager.grey, width: AppSize.s1_5),
        borderRadius: BorderRadius.circular(AppSize.s8),
      ),

      focusedBorder: OutlineInputBorder(
        borderSide:
        BorderSide(color: ColorManager.primary, width: AppSize.s1_5),
        borderRadius: BorderRadius.circular(AppSize.s8),
      ),

      errorBorder: OutlineInputBorder(
        borderSide:
        BorderSide(color: ColorManager.error, width: AppSize.s1_5),
        borderRadius: BorderRadius.circular(AppSize.s8),
      ),

      focusedErrorBorder: OutlineInputBorder(
        borderSide:
        BorderSide(color: ColorManager.primary, width: AppSize.s1_5),
        borderRadius: BorderRadius.circular(AppSize.s8),
      ),
    ),
  );
}
//    -----get application DarkTheme-----

ThemeData getDarkTheme() {

  return ThemeData(
    brightness: Brightness.dark,
    primaryColor: ColorManager.darkPrimary,
    scaffoldBackgroundColor: ColorManager.black,
    disabledColor: ColorManager.grey2,
    hintColor: ColorManager.grey1,

    // Card
    cardTheme: CardThemeData(
      color: ColorManager.darkBackground,
      elevation: AppSize.s2,
    ),

    // AppBar
    appBarTheme: AppBarTheme(
      centerTitle: true,
      backgroundColor: ColorManager.darkBackground,
      titleTextStyle: getTitleStyle(color: Colors.white),
      iconTheme: const IconThemeData(color: Colors.white),
    ),

    // Buttons
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorManager.darkPrimary,
        textStyle: getButtonStyle(color: Colors.white),
      ),
    ),

    // Text Theme
    textTheme: TextTheme(
      headlineLarge: getHeadlineStyle(color: Colors.white),
      titleLarge: getTitleStyle(color: Colors.white),
      titleMedium: getSubtitleStyle(color: ColorManager.grey2),
      bodyLarge: getBodyStyle(color: ColorManager.grey2),
      bodyMedium: getBodyStyle(color: ColorManager.grey1),
      bodySmall: getCaptionStyle(color: ColorManager.grey1),
      labelLarge: getButtonStyle(color: Colors.white),
    ),

    // Input Fields
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: ColorManager.darkBackground.withOpacity(.7),

      hintStyle: getCaptionStyle(color: ColorManager.grey1),
      labelStyle: getBodyStyle(color: ColorManager.grey2),
      errorStyle: getCaptionStyle(color: ColorManager.error),

      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: ColorManager.grey2),
        borderRadius: BorderRadius.circular(AppSize.s8),
      ),

      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: ColorManager.darkPrimary),
        borderRadius: BorderRadius.circular(AppSize.s8),
      ),
    ),
  );
}
