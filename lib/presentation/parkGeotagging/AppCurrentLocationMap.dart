import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AppCurrentLocationMap extends StatefulWidget {
  final double latitude;
  final double longitude;
  final String address;

  /// ✅ CALLBACK
  final Function(double lat, double lng, String address) onLocationChanged;

  const AppCurrentLocationMap({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.onLocationChanged
  });

  @override
  State<AppCurrentLocationMap> createState() => _AppCurrentLocationMapState();
}

class _AppCurrentLocationMapState extends State<AppCurrentLocationMap> {
  GoogleMapController? _mapController;
  BitmapDescriptor? _currentLocationIcon;
  LatLng? _centerLatLng; // 👈 picked location
  bool _isMoving = false;
  LatLng _lastCameraPosition = const LatLng(0, 0);


  Widget _centerMarker() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.only(bottom: 30), // 👈 little up
        child: Icon(
          Icons.location_pin,
          size: 45,
          color: Colors.red,
        ),
      ),
    );
  }

  Future<void> _onCameraIdle() async {
    try {
      final placemarks = await placemarkFromCoordinates(
        _lastCameraPosition.latitude,
        _lastCameraPosition.longitude,
      );

      final place = placemarks.first;
      final address =
          "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";

      /// ✅ SEND DATA BACK TO UI
      widget.onLocationChanged(
        _lastCameraPosition.latitude,
        _lastCameraPosition.longitude,
        address,
      );
    } catch (e) {
      debugPrint("Geocoding error: $e");
    }
  }



  @override
  void initState() {
    super.initState();
    _loadCurrentLocationMarker();
    _centerLatLng = LatLng(widget.latitude, widget.longitude);
  }
  //    'assets/images/park_marker2.png',
  /// ✅ Load asset marker safely
  Future<void> _loadCurrentLocationMarker() async {
    try {
      final icon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(
          devicePixelRatio: 1.0, // ✅ CRITICAL FIX for iOS
        ),
        'assets/images/location.png',
      );

      if (!mounted) return;

      setState(() {
        _currentLocationIcon = icon;
      });
    } catch (e) {
      debugPrint('❌ Marker load error: $e');
    }
  }
  /// 🔍 Zoom In
  Future<void> _zoomIn() async {
    final zoom = await _mapController?.getZoomLevel() ?? 16;
    _mapController?.animateCamera(CameraUpdate.zoomTo(zoom + 1));
  }

  /// 🔍 Zoom Out
  Future<void> _zoomOut() async {
    final zoom = await _mapController?.getZoomLevel() ?? 16;
    _mapController?.animateCamera(CameraUpdate.zoomTo(zoom - 1));
  }

  Widget _zoomButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      elevation: 4,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 40,
          height: 40,
          child: Icon(icon),
        ),
      ),
    );
  }

  // move the current location function
  Future<void> _moveToCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        debugPrint("❌ Location services disabled");
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          debugPrint("❌ Location permission denied");
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        debugPrint("❌ Location permission permanently denied");
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final latLng = LatLng(position.latitude, position.longitude);

      _mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: latLng,
            zoom: 17,
          ),
        ),
      );

      // keep camera state updated
      _lastCameraPosition = latLng;
    } catch (e) {
      debugPrint("❌ Current location error: $e");
    }
  }


  @override
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) {
              _mapController = controller;
            },
            initialCameraPosition: CameraPosition(
              target: LatLng(widget.latitude, widget.longitude),
              zoom: 15,
            ),

            rotateGesturesEnabled: true,
            tiltGesturesEnabled: true,
            scrollGesturesEnabled: true,
            zoomGesturesEnabled: true,

            gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
              Factory<OneSequenceGestureRecognizer>(
                    () => EagerGestureRecognizer(),
              ),
            },

            onCameraMove: (position) {
              _lastCameraPosition = position.target;
            },
            onCameraIdle: _onCameraIdle,

            zoomControlsEnabled: false,
          ),

          // GoogleMap(
          //   onMapCreated: (controller) {
          //     _mapController = controller;
          //   },
          //   initialCameraPosition: CameraPosition(
          //     target: LatLng(widget.latitude, widget.longitude),
          //     zoom: 15,
          //   ),
          //   onCameraMove: (position) {
          //     _lastCameraPosition = position.target;
          //   },
          //   onCameraIdle: _onCameraIdle,
          //   zoomControlsEnabled: false,
          // ),

          /// 📍 STATIC CENTER MARKER
          _centerMarker(),

          /// 🔍 ZOOM BUTTONS
          Positioned(
            right: 12,
            bottom: 40,
            child: Column(
              children: [
                _zoomButton(icon: Icons.add, onTap: _zoomIn),
                const SizedBox(height: 8),
                _zoomButton(icon: Icons.remove, onTap: _zoomOut),
                // const SizedBox(height: 8),
                // _zoomButton(
                //   icon: Icons.my_location,
                //   onTap: _moveToCurrentLocation,
                // ),

              ],
            ),
          ),
        ],
      ),
    );

  }
}

// class AppCurrentLocationMap extends StatefulWidget {
//   final double latitude;
//   final double longitude;
//   final String address;
//
//   const AppCurrentLocationMap({
//     super.key,
//     required this.latitude,
//     required this.longitude,
//     required this.address,
//   });
//
//   @override
//   State<AppCurrentLocationMap> createState() => _AppCurrentLocationMapState();
// }
//
// class _AppCurrentLocationMapState extends State<AppCurrentLocationMap> {
//   GoogleMapController? _mapController;
//   BitmapDescriptor? _currentLocationIcon;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadCurrentLocationMarker();
//   }
//   //    'assets/images/park_marker2.png',
//   /// ✅ Load asset marker safely
//   Future<void> _loadCurrentLocationMarker() async {
//     try {
//       final icon = await BitmapDescriptor.fromAssetImage(
//         const ImageConfiguration(
//           devicePixelRatio: 1.0, // ✅ CRITICAL FIX for iOS
//         ),
//         'assets/images/location.png',
//       );
//
//       if (!mounted) return;
//
//       setState(() {
//         _currentLocationIcon = icon;
//       });
//     } catch (e) {
//       debugPrint('❌ Marker load error: $e');
//     }
//   }
//   /// 🔍 Zoom In
//   Future<void> _zoomIn() async {
//     final zoom = await _mapController?.getZoomLevel() ?? 16;
//     _mapController?.animateCamera(CameraUpdate.zoomTo(zoom + 1));
//   }
//
//   /// 🔍 Zoom Out
//   Future<void> _zoomOut() async {
//     final zoom = await _mapController?.getZoomLevel() ?? 16;
//     _mapController?.animateCamera(CameraUpdate.zoomTo(zoom - 1));
//   }
//
//   Widget _zoomButton({
//     required IconData icon,
//     required VoidCallback onTap,
//   }) {
//     return Material(
//       elevation: 4,
//       shape: const CircleBorder(),
//       child: InkWell(
//         customBorder: const CircleBorder(),
//         onTap: onTap,
//         child: SizedBox(
//           width: 40,
//           height: 40,
//           child: Icon(icon),
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (_currentLocationIcon == null) {
//       return const SizedBox(
//         height: 250,
//         child: Center(child: CircularProgressIndicator()),
//       );
//     }
//
//     final LatLng currentLatLng =
//     LatLng(widget.latitude, widget.longitude);
//
//     return SizedBox(
//       height: 250,
//       child: Stack(
//         children: [
//           GoogleMap(
//             onMapCreated: (controller) {
//               _mapController = controller;
//             },
//             initialCameraPosition: CameraPosition(
//               target: currentLatLng,
//               zoom: 14,
//             ),
//             markers: {
//               Marker(
//                 markerId: const MarkerId('current_location'),
//                 position: currentLatLng,
//                 icon: _currentLocationIcon!,
//                 infoWindow: InfoWindow(
//                   title: 'Your Current Location',
//                   snippet: widget.address,
//                 ),
//               ),
//             },
//             myLocationEnabled: false,
//             myLocationButtonEnabled: false,
//             zoomControlsEnabled: false,
//           ),
//
//           /// 🔍 Zoom buttons (Android + iOS)
//           Positioned(
//             right: 12,
//             bottom: 40,
//             child: Column(
//               children: [
//                 _zoomButton(icon: Icons.add, onTap: _zoomIn),
//                 const SizedBox(height: 8),
//                 _zoomButton(icon: Icons.remove, onTap: _zoomOut),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }