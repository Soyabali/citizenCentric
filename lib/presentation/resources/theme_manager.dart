import 'package:citizencentric/presentation/resources/font_manager.dart';
import 'package:citizencentric/presentation/resources/styles_manager.dart';
import 'package:citizencentric/presentation/resources/values_manager.dart';
import 'package:flutter/material.dart';
import 'color_manager.dart';

ThemeData getApplicationTheme() {
  return ThemeData(
    // main colors of the app
      primaryColor: ColorManager.primary,
      primaryColorLight: ColorManager.primaryOpacity70,
      primaryColorDark: ColorManager.darkPrimary,
      disabledColor: ColorManager.grey1, // will be used incase of disabled button for example
      hintColor: ColorManager.grey,

    // card view theme
      cardTheme: CardThemeData(
      color: ColorManager.white,
      shadowColor: ColorManager.grey,
      elevation: AppSize.s4),
    // App bar theme
    appBarTheme :AppBarTheme(
     centerTitle: true,
      color: ColorManager.primary,
      elevation: AppSize.s4,
      shadowColor: ColorManager.primaryOpacity70,
      titleTextStyle: getRegularStyle(
      color: ColorManager.white,
      fontSize: FontSize.s16
      ),
    ),
    // Button theme
    buttonTheme: ButtonThemeData(
        shape: StadiumBorder(),
        disabledColor: ColorManager.grey1,
        buttonColor: ColorManager.primary,
        splashColor: ColorManager.primaryOpacity70),

    // elevated button theme
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            textStyle: getRegularStyle(color: ColorManager.white),
            backgroundColor: ColorManager.primary,
            shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSize.s12)))),

    // Text theme
      textTheme: TextTheme(
          displayLarge: getSemiBoldStyle(color: ColorManager.darkGrey,fontSize: FontSize.s16),
          titleMedium: getMediumStyle(color: ColorManager.lightGrey,fontSize: FontSize.s14),
          bodySmall: getRegularStyle(color: ColorManager.grey1),
          bodyLarge: getRegularStyle(color: ColorManager.grey),
          displaySmall: getBoldStyle(color: ColorManager.primary, fontSize: FontSize.s16),
          headlineLarge: getRegularStyle(color: ColorManager.primary, fontSize: FontSize.s14),

      ),

    // input decoration theme (text form field)

  inputDecorationTheme: InputDecorationTheme(
  contentPadding: EdgeInsets.all(AppPadding.p8),
  // hint style
  hintStyle: getRegularStyle(color: ColorManager.grey1),

  // label style
  labelStyle: getMediumStyle(color: ColorManager.darkGrey),
  // error style
  errorStyle: getRegularStyle(color: ColorManager.error),

  // enabled border
  enabledBorder: OutlineInputBorder(
  borderSide:
  BorderSide(color: ColorManager.grey, width: AppSize.s1_5),
  borderRadius: BorderRadius.all(Radius.circular(AppSize.s8))),

  // focused border
  focusedBorder: OutlineInputBorder(
  borderSide:
  BorderSide(color: ColorManager.primary, width: AppSize.s1_5),
  borderRadius: BorderRadius.all(Radius.circular(AppSize.s8))),

  // error border
  errorBorder: OutlineInputBorder(
  borderSide:
  BorderSide(color: ColorManager.error, width: AppSize.s1_5),
  borderRadius: BorderRadius.all(Radius.circular(AppSize.s8))),
  // focused error border
  focusedErrorBorder: OutlineInputBorder(
  borderSide:
  BorderSide(color: ColorManager.primary, width: AppSize.s1_5),
  borderRadius: BorderRadius.all(Radius.circular(AppSize.s8))),
  )
  );

}

//    -----get application DarkTheme-----

ThemeData getDarkTheme() {
  return ThemeData(
    brightness: Brightness.dark,

    // Main colors
    primaryColor: ColorManager.darkPrimary,
    primaryColorLight: ColorManager.grey2,
    primaryColorDark: ColorManager.black,
    disabledColor: ColorManager.grey2,
    hintColor: ColorManager.grey1,

    scaffoldBackgroundColor: ColorManager.black,

    // Card Theme
    cardTheme: CardThemeData(
      color: ColorManager.darkBackground,
      shadowColor: ColorManager.black.withOpacity(0.4),
      elevation: AppSize.s2,
    ),

    // AppBar Theme
    appBarTheme: AppBarTheme(
      centerTitle: true,
      color: ColorManager.darkBackground,
      elevation: AppSize.s2,
      shadowColor: ColorManager.grey2,
      titleTextStyle: getRegularStyle(
        color: ColorManager.white,
        fontSize: FontSize.s16,
      ),
      iconTheme: IconThemeData(color: ColorManager.white),
    ),

    // Button Theme
    buttonTheme: ButtonThemeData(
      shape: const StadiumBorder(),
      disabledColor: ColorManager.grey2,
      buttonColor: ColorManager.darkPrimary,
      splashColor: ColorManager.grey1,
    ),

    // Elevated Button
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorManager.darkPrimary,
        textStyle: getRegularStyle(color: ColorManager.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSize.s12),
        ),
      ),
    ),

    // Text Theme
    textTheme: TextTheme(
      displayLarge:
      getSemiBoldStyle(color: ColorManager.white, fontSize: FontSize.s16),

      titleMedium:
      getMediumStyle(color: ColorManager.grey, fontSize: FontSize.s14),

      bodySmall: getRegularStyle(color: ColorManager.grey1),

      bodyLarge: getRegularStyle(color: ColorManager.grey2),

      displaySmall:
      getBoldStyle(color: ColorManager.darkPrimary, fontSize: FontSize.s16),

      headlineLarge:
      getRegularStyle(color: ColorManager.darkPrimary, fontSize: FontSize.s14),
    ),

    // Input Field Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: ColorManager.darkBackground.withOpacity(.7),

      contentPadding: const EdgeInsets.all(AppPadding.p8),

      hintStyle: getRegularStyle(color: ColorManager.grey1),
      labelStyle: getMediumStyle(color: ColorManager.grey2),
      errorStyle: getRegularStyle(color: ColorManager.error),

      // Borders
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: ColorManager.grey2),
        borderRadius: BorderRadius.circular(AppSize.s8),
      ),

      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: ColorManager.darkPrimary),
        borderRadius: BorderRadius.circular(AppSize.s8),
      ),

      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: ColorManager.error),
        borderRadius: BorderRadius.circular(AppSize.s8),
      ),

      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: ColorManager.darkPrimary),
        borderRadius: BorderRadius.circular(AppSize.s8),
      ),
    ),
  );
}
