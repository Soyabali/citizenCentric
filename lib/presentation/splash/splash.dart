
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../app/app_prefs.dart';
import '../../app/di.dart';
import '../../data/repo/verifyAppVersion.dart';
import '../resources/assets_manager.dart';
import '../resources/color_manager.dart';
import '../resources/routes_manager.dart';

class SplashView extends StatefulWidget {

  const SplashView({super.key});


  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {

  Timer? _timer;

  final AppPreferences _appPreferences = instance<AppPreferences>();

  _startDelay() {
    _timer = Timer(Duration(seconds: 2), _goNext);
  }

  _goNext() async {
    _appPreferences.isUserLoggedIn().then((isUserLoggedIn) =>
    {
      if (isUserLoggedIn)
        {
          Navigator.pushReplacementNamed(context, Routes.homePage)
        }
      else
        {
          _appPreferences.isOnBoardingScreenViewed()
              .then((isOnBoardingScreenViewed) =>
          {
            if (isOnBoardingScreenViewed)
              {
                Navigator.pushReplacementNamed(context, Routes.loginRoute)
              }
            else
              {
                Navigator.pushReplacementNamed(context, Routes.onBoardingRoute)
              }
          })
        }
    });
  }

  /// call a version api
  versionAliCall() async {
    /// TODO HERE YOU SHOULD CHANGE APP VERSION FLUTTER VERSION MIN 3 DIGIT SUCH AS 1.0.0
    /// HERE YOU PASS variable _appVersion
    var loginMap = await VerifyAppVersionRepo().verifyAppVersion(context,'1');
    var iVersion = "${loginMap['iVersion']}";

    if(iVersion=="1"){
      _startDelay();
    }else{
      showDialog(context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('New Version Available'),
              content: const Text('Download the latest version of the app from the App Store.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    _launchGooglePlayStore(); // Close the dialog
                  },
                  child: const Text('Download'),
                ),

              ],
            );
      });
      // displayToast(msg);
    }
    }

    // launch gogle play store
  void _launchGooglePlayStore() async {
    const url = 'https://apps.apple.com/app/6739492787'; // Replace <YOUR_APP_ID> with your app's package name
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }


  @override
  void initState() {
    super.initState();
   // _startDelay();
    versionAliCall();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.primary,
      body: Center(
        child: Image(
          image: AssetImage(ImageAssets.splashLogo),
        ),
      ),
    );
  }
}