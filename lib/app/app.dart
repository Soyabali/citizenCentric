import 'package:citizencentric/app/app_prefs.dart';
import 'package:citizencentric/presentation/resources/theme_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../presentation/resources/routes_manager.dart';
import 'di.dart';

class MyApp extends StatefulWidget {

  MyApp._internal(); // private named constructor
  int appState=0;
  static final MyApp instance = MyApp._internal();// single instance --singleton

  factory MyApp() => instance; // factort for the class instance

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  AppPreferences _appPreferences = instance<AppPreferences>();

  @override
  void didChangeDependencies() {
    _appPreferences.getLocal().then((locale) => {
      context.setLocale(locale)
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      // Application Theme
      debugShowCheckedModeBanner: false,
      // rooute
      onGenerateRoute: RouteGenerator.getRoute,
      // inittialRoute
      initialRoute: Routes.splashRoute,
     // theme
      theme: getApplicationTheme(),
    );
  }
}
