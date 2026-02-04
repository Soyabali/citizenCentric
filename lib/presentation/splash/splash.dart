
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../app/app_prefs.dart';
import '../../app/di.dart';
import '../../data/repo/verifyAppVersion.dart';
import '../commponent/generalFunction.dart';
import '../homepage/homepage.dart';
import '../login/login.dart';
import '../resources/app_text_style.dart';
import '../resources/assets_manager.dart';
import '../resources/color_manager.dart';
import '../resources/routes_manager.dart';

// class SplashView extends StatefulWidget {
//   const SplashView({super.key});
//
//   @override
//   State<SplashView> createState() => _SplaceState();
// }
//
// class _SplaceState extends State<SplashView> {
//
//   bool activeConnection = false;
//   String T = "";
//   Future checkUserConnection() async {
//     try {
//       final result = await InternetAddress.lookup('google.com');
//       if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
//         setState(() {
//           activeConnection = true;
//           T = "Turn off the data and repress again";
//           versionAliCall();
//           //displayToast(T);
//         });
//       }
//     } on SocketException catch (_) {
//       setState(() {
//         activeConnection = false;
//         T = "Turn On the data and repress again";
//         displayToast(T);
//       });
//     }
//   }
//
//   //url
//   void _launchGooglePlayStore() async {
//     const url = 'https://apps.apple.com/app/6739492787'; // Replace <YOUR_APP_ID> with your app's package name
//     if (await canLaunch(url)) {
//       await launch(url);
//     } else {
//       throw 'Could not launch $url';
//     }
//   }
//
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     checkUserConnection();
//     super.initState();
//   }
//   versionAliCall() async {
//     // API call
//     final loginMap =
//     await VerifyAppVersionRepo().verifyAppVersion(context, '13');
//
//     // SAFE read (can be null)
//     final String? msg = loginMap['Msg']?.toString();
//     final String? iVersion = loginMap['iVersion']?.toString();
//
//     print("---version : $iVersion");
//     print("-----loginMap--: $loginMap");
//
//     // App version check
//     if (iVersion == "1") {
//       AppPreferences _appPreferences = instance<AppPreferences>();
//
//       final userData = await _appPreferences.getLoginUserData();
//       final String? token = await _appPreferences.getUserToken();
//
//       // ✅ SAFE userId read
//       final String? userId = userData?['userId']?.toString();
//
//       print("-------userId---- $userId");
//
//       // ✅ Correct null + empty check
//       if (token != null && token.isNotEmpty) {
//         // Go to Home
//         Navigator.pushAndRemoveUntil(
//           context,
//           MaterialPageRoute(builder: (_) => Homepage()),
//               (route) => false,
//         );
//       } else {
//         // Go to Login
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (_) => const LoginView()),
//         );
//       }
//     } else {
//       // New version dialog
//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: const Text('New Version Available'),
//             content: const Text(
//               'Download the latest version of the app from the App Store.',
//             ),
//             actions: [
//               TextButton(
//                 onPressed: _launchGooglePlayStore,
//                 child: const Text('Download'),
//               ),
//             ],
//           );
//         },
//       );
//
//       if (msg != null) {
//         displayToast(msg);
//       }
//     }
//   }
//
//
//   // versionAliCall() async{
//   //   /// TODO HERE YOU SHOULD CHANGE APP VERSION FLUTTER VERSION MIN 3 DIGIT SUCH AS 1.0.0
//   //   /// HERE YOU PASS variable _appVersion
//   //   var loginMap = await VerifyAppVersionRepo().verifyAppVersion(context,'13');
//   //   var msg = "${loginMap['Msg']}";
//   //   var iVersion = "${loginMap['iVersion']}";
//   //   print("---version :  $iVersion");
//   //   print("-----118--: $loginMap");
//   //   // dep
//   //   var ver ="13";
//   //
//   //   if(iVersion=="1"){
//   //     // to check token is store or not
//   //     AppPreferences _appPreferences = instance<AppPreferences>();
//   //     final userData = await _appPreferences.getLoginUserData();
//   //     final token = await _appPreferences.getUserToken();
//   //
//   //    // "iUserId": "${userData?['userId']}",
//   //   var userId = "${userData?['userId']}";
//   //   print("-------82----xxx--$userId");
//   //
//   //     if(userId!=null && userId!=''){
//   //
//   //       Navigator.pushAndRemoveUntil(
//   //         context,
//   //         MaterialPageRoute(builder: (context) => Homepage()),
//   //             (Route<dynamic> route) => false, // This condition removes all previous routes
//   //       );
//   //     }else{
//   //       Navigator.pushReplacement(
//   //         context,
//   //         MaterialPageRoute(builder: (context) =>  const LoginView()),
//   //       );
//   //     }
//   //     // displayToast(msg);
//   //   }else{
//   //     showDialog(context: context,
//   //       builder: (BuildContext context) {
//   //         return AlertDialog(
//   //           title: const Text('New Version Available'),
//   //           content: const Text('Download the latest version of the app from the App Store.'),
//   //           actions: <Widget>[
//   //             TextButton(
//   //               onPressed: () {
//   //                 _launchGooglePlayStore(); // Close the dialog
//   //               },
//   //               child: const Text('Download'),
//   //             ),
//   //
//   //           ],
//   //         );
//   //       },
//   //     );
//   //     displayToast(msg);
//   //     //print('----F---');
//   //   }
//   // }
//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: SplaceScreen(),
//     );
//   }
// }
//
// class SplaceScreen extends StatelessWidget {
//
//   const SplaceScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//         debugShowCheckedModeBanner: false,
//         home:Stack(
//           fit: StackFit.expand,
//           clipBehavior: Clip.hardEdge,
//           alignment: Alignment.bottomRight,
//           children: [
//             Container(
//                 child: Stack(
//                   alignment: Alignment.center,
//                   children: [
//                     Positioned(
//                       child: Text('Noida Park',
//                         style:AppTextStyle.font30penSansExtraboldWhiteTextStyle,
//                       ),
//                     )
//                   ],
//                 )
//             )
//
//           ],
//         )
//     );
//   }
//
// }

// class SplashView extends StatefulWidget {
//
//   @override
//   _SplashViewState createState() => _SplashViewState();
// }
//
// class _SplashViewState extends State<SplashView> {
//
//   bool activeConnection = false;
//   String T = "";
//   Future checkUserConnection() async {
//     try {
//       final result = await InternetAddress.lookup('google.com');
//       if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
//         setState(() {
//           activeConnection = true;
//           T = "Turn off the data and repress again";
//           versionAliCall();
//           //displayToast(T);
//         });
//       }
//     } on SocketException catch (_) {
//       setState(() {
//         activeConnection = false;
//         T = "Turn On the data and repress again";
//        // displayToast(T);
//       });
//     }
//   }
//
// //url
//   void _launchGooglePlayStore() async {
//     const url = 'https://apps.apple.com/app/6739492787'; // Replace <YOUR_APP_ID> with your app's package name
//     if (await canLaunch(url)) {
//       await launch(url);
//     } else {
//       throw 'Could not launch $url';
//     }
//   }
//
//
//   // api version
//   versionAliCall() async{
//     /// TODO HERE YOU SHOULD CHANGE APP VERSION FLUTTER VERSION MIN 3 DIGIT SUCH AS 1.0.0
//     /// HERE YOU PASS variable _appVersion
//     var loginMap = await VerifyAppVersionRepo().verifyAppVersion(context,'1');
//     var msg = "${loginMap['Msg']}";
//     var iVersion = "${loginMap['iVersion']}";
//     print("---version :  $iVersion");
//     print("-----118--: $loginMap");
//     // dep
//     var ver ="13";
//
//     if(iVersion=="1"){
//       // to check token is store or not
//       // SharedPreferences prefs = await SharedPreferences.getInstance();
//       // var sContactNo = prefs.getString('sContactNo');
//       // print("------162---ContactNo---$sContactNo");
//       AppPreferences _appPreferences = instance<AppPreferences>();
//
//       final token = await _appPreferences.getUserToken();
//       print('Token  27 : $token');
//
//       if(token!=null && token!=''){
//
//         Navigator.pushReplacementNamed(context, Routes.homePage);
//
//         // Navigator.pushAndRemoveUntil(
//         //   context,
//         //   MaterialPageRoute(builder: (context) => ComplaintHomePage()),
//         //       (Route<dynamic> route) => false, // This condition removes all previous routes
//         // );
//       }else{
//
//         Navigator.pushReplacementNamed(context, Routes.loginRoute);
//
//         // Navigator.pushReplacement(
//         //   context,
//         //   MaterialPageRoute(builder: (context) =>  const LoginScreen_2()),
//         // );
//       }
//       // displayToast(msg);
//     }else{
//       showDialog(context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: const Text('New Version Available'),
//             content: const Text('Download the latest version of the app from the App Store.'),
//             actions: <Widget>[
//               TextButton(
//                 onPressed: () {
//                   _launchGooglePlayStore(); // Close the dialog
//                 },
//                 child: const Text('Download'),
//               ),
//
//             ],
//           );
//         },
//       );
//       displayToast(msg);
//       //print('----F---');
//     }
//   }
//
//
//
//
//
//
//
//
//
//   Timer? _timer;
//
//   AppPreferences _appPreferences = instance<AppPreferences>();
//
//   _startDelay() {
//     _timer = Timer(Duration(seconds: 2), _goNext);
//   }
//
//   _goNext_2() {
//     Navigator.pushReplacementNamed(context, Routes.onBoardingRoute);
//   }
//   _goNext() async {
//     _appPreferences.isUserLoggedIn().then((isUserLoggedIn) =>
//     {
//       if (isUserLoggedIn)
//         {
//           Navigator.pushReplacementNamed(context, Routes.homePage)
//         }
//       else
//         {
//           _appPreferences.isOnBoardingScreenViewed()
//               .then((isOnBoardingScreenViewed) =>
//           {
//             if (isOnBoardingScreenViewed)
//               {
//                 Navigator.pushReplacementNamed(context, Routes.loginRoute)
//               }
//             else
//               {
//                 Navigator.pushReplacementNamed(context, Routes.onBoardingRoute)
//               }
//           })
//         }
//     });
//   }
//   @override
//   void initState() {
//     super.initState();
//    // _startDelay();
//     checkUserConnection();
//   }
//
//   @override
//   void dispose() {
//     _timer?.cancel();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: ColorManager.primary,
//       body: Center(
//         child: Image(
//           image: AssetImage(ImageAssets.splashLogo),
//         ),
//       ),
//     );
//   }
// }




class SplashView extends StatefulWidget {

  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {

  Timer? _timer;

  AppPreferences _appPreferences = instance<AppPreferences>();

  _startDelay() {
    _timer = Timer(Duration(seconds: 2), _goNext);
  }


  _goNext_2() {
    Navigator.pushReplacementNamed(context, Routes.onBoardingRoute);
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
  versionAliCall() async{
    /// TODO HERE YOU SHOULD CHANGE APP VERSION FLUTTER VERSION MIN 3 DIGIT SUCH AS 1.0.0
    /// HERE YOU PASS variable _appVersion
    var loginMap = await VerifyAppVersionRepo().verifyAppVersion(context,'13');
    var msg = "${loginMap['Msg']}";
    var iVersion = "${loginMap['iVersion']}";
    print("---version :  $iVersion");
    print("-----118--: $loginMap");
    // dep
    var ver ="13";

    if(iVersion=="1"){
      _startDelay();
      // // to check token is store or not
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // var sContactNo = prefs.getString('sContactNo');
      // print("------162---ContactNo---$sContactNo");
      // if(sContactNo!=null && sContactNo!=''){
      //
      //   Navigator.pushAndRemoveUntil(
      //     context,
      //     MaterialPageRoute(builder: (context) => ComplaintHomePage()),
      //         (Route<dynamic> route) => false, // This condition removes all previous routes
      //   );
      }else{
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(builder: (context) =>  const LoginScreen_2()),
        // );

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

      //displayToast(msg);
      //print('----F---');
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