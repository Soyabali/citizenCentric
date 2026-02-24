import 'package:citizencentric/app/app_prefs.dart';
import 'package:citizencentric/presentation/resources/theme_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../presentation/resources/routes_manager.dart';
import '../presentation/riverpod/main_view_controller..dart';
import 'di.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class MyApp extends ConsumerStatefulWidget {

  MyApp._internal(); // private named constructor
  int appState=0;
  static final MyApp instance = MyApp._internal();// single instance --singleton

  factory MyApp() => instance; // factort for the class instance

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {

  final AppPreferences _appPreferences = instance<AppPreferences>();
  final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

  @override
  void didChangeDependencies() {
    _appPreferences.getLocal().then((locale) => {
      context.setLocale(locale)
    });
    super.didChangeDependencies();
  }

  void setupPushNotifications() async {
    final fcm = FirebaseMessaging.instance;
    // here you pick a token and send a notification befafe of token
    final token = await fcm.getToken();
  }

  @override
  void initState() {
    super.initState();
    //setupPushNotifications();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = ref.watch(appThemeProvider);// lisen them state with provider
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      // Application Theme
      debugShowCheckedModeBanner: false,
      navigatorObservers: [routeObserver],
      // 🔴 THIS LINE FIXES YOUR ERROR
      builder: EasyLoading.init(),
      // rooute
      onGenerateRoute: RouteGenerator.getRoute,
      // inittialRoute
      initialRoute: Routes.splashRoute,
      // theme
      //theme: getApplicationTheme(),
      theme: isDarkTheme ? getDarkTheme() : getApplicationTheme(),
    );
  }
}
