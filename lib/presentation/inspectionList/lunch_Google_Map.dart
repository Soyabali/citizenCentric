// import 'package:flutter/cupertino.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// Future<void> launchGoogleMaps(double laititude,double longitude) async {
//   double destinationLatitude= laititude;
//   double destinationLongitude = longitude;
//   final uri = Uri(
//       scheme: "google.navigation",
//       // host: '"0,0"',  {here we can put host}
//       queryParameters: {
//         'q': '$destinationLatitude, $destinationLongitude'
//       });
//   if (await canLaunchUrl(uri)) {
//     await launchUrl(uri);
//   } else {
//     debugPrint('An error occurred');
//   }
// }
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';

Future<void> launchGoogleMaps(double latitude, double longitude) async {
  Uri uri;

  if (Platform.isAndroid) {
    // ✅ Android navigation
    uri = Uri.parse(
      'google.navigation:q=$latitude,$longitude',
    );
  } else if (Platform.isIOS) {
    // ✅ iOS Google Maps
    uri = Uri.parse(
      'comgooglemaps://?q=$latitude,$longitude',
    );
  } else {
    return;
  }

  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } else {
    // 🌐 Fallback (works everywhere)
    final fallbackUri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude',
    );
    await launchUrl(fallbackUri, mode: LaunchMode.externalApplication);
  }
}
