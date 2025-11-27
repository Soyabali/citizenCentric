
import 'package:citizencentric/presentation/resources/strings_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../app/di.dart';
import '../change_password/change_password.dart';
import '../firebase/auth/auth.dart';
import '../firebase/firebasehome.dart';
import '../firebase/firebaselogin.dart';
import '../forgot_password/forgot_password.dart';
import '../formdatastore/formdatastore.dart';
import '../login/login.dart';
import '../main/main_view.dart';
import '../onboarding/onboarding.dart';
import '../register/register.dart';
import '../splash/splash.dart';
import '../store_details/store_details.dart';

class Routes {

  static const String splashRoute = "/";
  static const String onBoardingRoute = "/onBoarding";
  static const String loginRoute = "/login";
  static const String registerRoute = "/register";
  static const String forgotPasswordRoute = "/forgotPassword";
  static const String mainRoute = "/main";
  static const String changePasswordRoute = "/changePassword";
  static const String storeDetailsRoute = "/storeDetails";
  static const String firebaseHome = "/firebaseHome";
  static const String formDataStore = "/formDataStore";
}
class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case Routes.splashRoute:
        return MaterialPageRoute(builder: (_) => SplashView());
      case Routes.loginRoute:
        initLoginModule();// depenence injection
        return MaterialPageRoute(builder: (_) => LoginView());
      case Routes.onBoardingRoute:
        return MaterialPageRoute(builder: (_) => OnBoardingView());
      case Routes.registerRoute:
        return MaterialPageRoute(builder: (_) => RegisterView());
      case Routes.forgotPasswordRoute:
        return MaterialPageRoute(builder: (_) => ForgotPasswordView());
      case Routes.mainRoute:
        initHomeModule();
        return MaterialPageRoute(builder: (_) => MainView());
      case Routes.storeDetailsRoute:
        return MaterialPageRoute(builder: (_) => StoreDetailsView());
        // ChangePassword
      case Routes.changePasswordRoute:
        initChangePasswordModule();
        return MaterialPageRoute(builder: (_) => ChangePassword());
        // firebase
      case Routes.firebaseHome:
        initFirebaseModule();
        return MaterialPageRoute(builder: (_) => FirebaseHome());
      case Routes.formDataStore:
        return MaterialPageRoute(builder: (_) => FormDataStore());
      default:
        return unDefinedRoute();
    }
  }
  static Route<dynamic> unDefinedRoute() {
    return MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(
            title: Text(AppStrings.noRouteFound).tr(),
          ),
          body: Center(child: Text(AppStrings.noRouteFound).tr()),
        ));
  }
}