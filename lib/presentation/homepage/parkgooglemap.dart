import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../domain/model/parkModel.dart';
import 'appGoogleMap.dart';

class AppGoogleMap extends StatelessWidget {
  final List<ParkLocation> parks;
  final double zoom;
  final double height;
  final EdgeInsets padding;
  final Function(GoogleMapController) onMapCreated;

  const AppGoogleMap({
    super.key,
    required this.parks,
    required this.onMapCreated,
    this.zoom = 12.0,
    this.height = 250,
    this.padding = const EdgeInsets.only(
      left: 12,
      right: 12,
      bottom: 10,
    ),
  });

  @override
  Widget build(BuildContext context) {
    final LatLng center = LatLng(
      parks.first.latitude,
      parks.first.longitude,
    );

    final Set<Marker> markers = parks.map((park) {
      return Marker(
        markerId: MarkerId(park.parkId.toString()),
        position: LatLng(park.latitude, park.longitude),
        infoWindow: InfoWindow(
          title: park.parkName,
          snippet: park.address,
        ),
      );
    }).toSet();

    return Padding(
      padding: padding,
      child: SizedBox(
        height: height,
        child: GoogleMap(
          onMapCreated: onMapCreated,
          initialCameraPosition: CameraPosition(
            target: center,
            zoom: zoom,
          ),
          markers: markers,
          zoomControlsEnabled: true,
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
        ),
      ),
    );
  }
}

// class AppGoogleMap extends StatelessWidget {
//   final LatLng center;
//   final double zoom;
//   final Set<Marker> markers; // ✅ ADD THIS
//   final Function(GoogleMapController) onMapCreated;
//   final double height;
//   final EdgeInsets padding;
//
//   const AppGoogleMap({
//     super.key,
//     required this.center,
//     required this.onMapCreated,
//     required this.markers, // ✅ ADD THIS
//     this.zoom = 11.0,
//     this.height = 250,
//     this.padding = const EdgeInsets.only(
//       left: 12,
//       right: 12,
//       bottom: 10,
//     ),
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: padding,
//       child: SizedBox(
//         height: height,
//         child: GoogleMap(
//           onMapCreated: onMapCreated,
//           initialCameraPosition: CameraPosition(
//             target: center,
//             zoom: zoom,
//           ),
//           markers: markers, // ✅ PASS HERE
//           zoomControlsEnabled: true,
//           myLocationEnabled: true,
//           myLocationButtonEnabled: true,
//         ),
//       ),
//     );
//   }
// }

// class ParkGoogleMap extends StatefulWidget {
//   const ParkGoogleMap({Key? key}) : super(key: key);
//
//   @override
//   State<ParkGoogleMap> createState() => _ParkGoogleMapState();
// }
//
// class _ParkGoogleMapState extends State<ParkGoogleMap> {
//   GoogleMapController? mapController;
//
//   final LatLng _center = const LatLng(28.601987, 77.356147);
//   final Set<Marker> _markers = {};
//
//   @override
//   void initState() {
//     super.initState();
//     _loadMarkers();
//   }
//
//   void _loadMarkers() {
//     _markers.add(
//       const Marker(
//         markerId: MarkerId('noida_park'),
//         position: LatLng(28.601987, 77.356147),
//         infoWindow: InfoWindow(
//           title: 'Abadi Park',
//           snippet: 'Sector 132, Noida',
//         ),
//       ),
//     );
//     setState(() {});
//   }
//
//   void _onMapCreated(GoogleMapController controller) {
//     mapController = controller;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AppGoogleMap(
//       center: _center,
//       markers: _markers,
//       onMapCreated: _onMapCreated,
//     );
//   }
// }


// class ParkGoogleMap extends StatefulWidget {
//   const ParkGoogleMap({Key? key}) : super(key: key);
//
//   @override
//   State<ParkGoogleMap> createState() => _ParkGoogleMapState();
// }
//
// class _ParkGoogleMapState extends State<ParkGoogleMap> {
//   GoogleMapController? _mapController;
//
//   final Set<Marker> _markers = {};
//
//   // Initial camera (Noida)
//   static const LatLng _initialPosition =
//   LatLng(28.601987, 77.356147);
//
//   @override
//   void initState() {
//     super.initState();
//     _loadMarkers();
//   }
//
//   void _loadMarkers() {
//     for (var park in dummyNoidaParks) {
//       _markers.add(
//         Marker(
//           markerId: MarkerId(park.name),
//           position: LatLng(park.latitude, park.longitude),
//           infoWindow: InfoWindow(
//             title: park.name,
//             snippet: park.address,
//           ),
//           icon: BitmapDescriptor.defaultMarkerWithHue(
//             BitmapDescriptor.hueGreen,
//           ),
//         ),
//       );
//     }
//     setState(() {});
//   }
//
//   void _onMapCreated(GoogleMapController controller) {
//     _mapController = controller;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Noida Parks"),
//       ),
//       body: GoogleMap(
//         onMapCreated: _onMapCreated,
//         initialCameraPosition: const CameraPosition(
//           target: _initialPosition,
//           zoom: 13,
//         ),
//         markers: _markers,
//         myLocationEnabled: true,
//         zoomControlsEnabled: true,
//       ),
//     );
//   }
// }

// class ParkGoogleMap extends StatefulWidget {
//
//   const ParkGoogleMap({
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   State<ParkGoogleMap> createState() => _TempleGoogleMapState();
// }
//
// class _TempleGoogleMapState extends State<ParkGoogleMap> {
//
//   GoogleMapController? mapController;
//
//
//   //final LatLng _center = const LatLng(45.521563, -122.677433);
//   var locationName="Noida Sec 62";
//   var sLocationAddress="  Noida sec 62 Block B plot no 322";
//   double fLatitude = 28.5355;
//   double fLongitude = 77.3910;
//
//
//  late LatLng _center;
//   final Set<Marker> _markers = {};
//   LatLng? _currentMapPosition;
//   dynamic? lat,long;
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeMap();
//   }
//
//   @override
//   void didUpdateWidget(ParkGoogleMap oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (oldWidget.fLatitude != fLatitude || oldWidget.fLongitude != fLongitude) {
//       _initializeMap();
//     }
//   }
//
//   void _initializeMap() {
//     _center = LatLng(45.521563, -122.677433);
//     _currentMapPosition = _center;
//     _clearMarkers();
//     _addMarker();
//     _moveCamera();
//   }
//
//   @override
//   void dispose() {
//     mapController?.dispose();
//     super.dispose();
//   }
//
//   void _clearMarkers() {
//     setState(() {
//       _markers.clear();
//     });
//   }
//   //
//   void _addMarker() async {
//     if (_currentMapPosition != null) {
//       final Uint8List markerIcon = await _createCustomMarkerBitmap(
//         locationName,
//         sLocationAddress,
//       );
//       setState(() {
//         _markers.add(Marker(
//           markerId: MarkerId(_currentMapPosition.toString()),
//           position: _currentMapPosition!,
//           icon: BitmapDescriptor.fromBytes(markerIcon),
//         ));
//       });
//     }
//   }
//
//   void _onCameraMove(CameraPosition position) {
//     _currentMapPosition = position.target;
//   }
//
//   void _onMapCreated(GoogleMapController controller) {
//     mapController = controller;
//     _moveCamera();
//   }
//
//   void _moveCamera() {
//     mapController?.animateCamera(CameraUpdate.newLatLng(_center));
//   }
//
//   Future<Uint8List> _createCustomMarkerBitmap(String title, String snippet) async {
//     final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
//     final Canvas canvas = Canvas(pictureRecorder);
//     final Paint paint = Paint()..color = Colors.white;
//
//     // TextPainter to measure the text size
//
//     final TextPainter titleTextPainter = TextPainter(
//       textDirection: TextDirection.ltr,
//       text: TextSpan(
//         text: title,
//         style: const TextStyle(
//           fontSize: 25.0,
//           color: Colors.black,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//     );
//
//     final TextPainter snippetTextPainter = TextPainter(
//       textDirection: TextDirection.ltr,
//       text: TextSpan(
//         text: snippet,
//         style: const TextStyle(
//           fontSize: 25.0,
//           color: Colors.black,
//         ),
//       ),
//     );
//
//     // Layout the text to get the size
//     titleTextPainter.layout(minWidth: 0, maxWidth: double.infinity);
//     snippetTextPainter.layout(minWidth: 0, maxWidth: double.infinity);
//
//     // Calculate the width and height based on text size
//     final double width = (titleTextPainter.width > snippetTextPainter.width
//         ? titleTextPainter.width
//         : snippetTextPainter.width) + 20.0;
//     final double height = titleTextPainter.height + snippetTextPainter.height + 40.0;
//
//     // Draw rounded rectangle
//     canvas.drawRRect(
//       RRect.fromRectAndRadius(
//         Rect.fromLTWH(0.0, 0.0, width, height),
//         Radius.circular(10.0),
//       ),
//       paint,
//     );
//
//     const double iconSize = 100.0;
//     final Paint markerPaint = Paint()..color = Colors.red;
//
//     // Draw the marker path
//     final Path markerPath = Path()
//       ..moveTo(width / 2 - iconSize / 2, height)
//       ..lineTo(width / 2, height + iconSize / 2)
//       ..lineTo(width / 2 + iconSize / 2, height)
//       ..close();
//     canvas.drawPath(markerPath, markerPaint);
//
//     // Draw title
//     titleTextPainter.paint(
//       canvas,
//       Offset(10.0, 10.0),
//     );
//
//     // Draw snippet
//     snippetTextPainter.paint(
//       canvas,
//       Offset(10.0, titleTextPainter.height + 20.0),
//     );
//
//     // Convert canvas to image
//     final ui.Image markerAsImage = await pictureRecorder.endRecording().toImage(
//       width.toInt(),
//       height.toInt() + (iconSize / 2).toInt(),
//     );
//
//     final ByteData? byteData = await markerAsImage.toByteData(
//       format: ui.ImageByteFormat.png,
//     );
//
//     return byteData!.buffer.asUint8List();
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: Text(locationName),
//       ),
//       //appBar: getAppBarBack(context,"${widget.locationName}"),
//       body: Stack(
//         children: <Widget>[
//           GoogleMap(
//             onMapCreated: _onMapCreated,
//             initialCameraPosition: CameraPosition(
//               target: _center,
//               zoom: 15.0,
//             ),
//             markers: _markers,
//             onCameraMove: _onCameraMove,
//           ),
//           // Positioned(
//           //   bottom: 16.0,
//           //   left: 16.0,
//           //   child: FloatingActionButton(
//           //     onPressed: _moveCamera,
//           //     child: GestureDetector(
//           //       onTap: (){
//           //         setState(() {
//           //           lat = double.parse('${fLatitude}');
//           //           long = double.parse('${fLongitude}');
//           //           print('---215--$lat');
//           //           print('---216--$long');
//           //           launchGoogleMaps(lat!, long!);
//           //         });
//           //         setState(() {
//           //
//           //         });
//           //       },
//           //       // child: Icon(Icons.my_location)
//           //       child: Container(
//           //           height: 25,
//           //           width: 25,
//           //           decoration: BoxDecoration(
//           //             borderRadius: BorderRadius.circular(5),
//           //           ),
//           //           child: Image.asset('assets/images/direction.jpeg',
//           //             height: 25,
//           //             width: 25,
//           //             fit: BoxFit.fill,
//           //           )
//           //       ),
//           //
//           //     ),
//           //   ),
//           // ),
//         ],
//       ),
//     );
//   }
// }

// void navigateToTempleGoogleMap(
//     BuildContext context,
//     double fLatitude,
//     double fLongitude,
//     String locationName,
//     String sLocationAddress,
//     ) {
//   Navigator.push(
//     context,
//     MaterialPageRoute(
//       builder: (context) => ParkGoogleMap(
//         fLatitude: fLatitude,
//         fLongitude: fLongitude,
//         locationName: locationName,
//         sLocationAddress: sLocationAddress,
//       ),
//     ),
//   );
// }




// class ParkGoogleMap extends StatefulWidget {
//
//   final double fLatitude;
//   final double fLongitude;
//   final String locationName;
//   final String sLocationAddress;
//
//   const ParkGoogleMap({
//     Key? key,
//     required this.fLatitude,
//     required this.fLongitude,
//     required this.locationName,
//     required this.sLocationAddress,
//   }) : super(key: key);
//
//   @override
//   State<ParkGoogleMap> createState() => _TempleGoogleMapState();
// }
//
// class _TempleGoogleMapState extends State<ParkGoogleMap> {
//
//   GoogleMapController? mapController;
//
//   late LatLng _center;
//   final Set<Marker> _markers = {};
//   LatLng? _currentMapPosition;
//   dynamic? lat,long;
//
//   @override
//   void initState() {
//     print('-----41----${widget.fLatitude}');
//     print('-----41---${widget.fLongitude}');
//     super.initState();
//     _initializeMap();
//   }
//
//   @override
//   void didUpdateWidget(ParkGoogleMap oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (oldWidget.fLatitude != widget.fLatitude || oldWidget.fLongitude != widget.fLongitude) {
//       _initializeMap();
//     }
//   }
//
//   void _initializeMap() {
//     _center = LatLng(widget.fLatitude, widget.fLongitude);
//     _currentMapPosition = _center;
//     _clearMarkers();
//     _addMarker();
//     _moveCamera();
//   }
//
//   @override
//   void dispose() {
//     mapController?.dispose();
//     super.dispose();
//   }
//
//   void _clearMarkers() {
//     setState(() {
//       _markers.clear();
//     });
//   }
//   //
//   void _addMarker() async {
//     if (_currentMapPosition != null) {
//       final Uint8List markerIcon = await _createCustomMarkerBitmap(
//         widget.locationName,
//         widget.sLocationAddress,
//       );
//       setState(() {
//         _markers.add(Marker(
//           markerId: MarkerId(_currentMapPosition.toString()),
//           position: _currentMapPosition!,
//           icon: BitmapDescriptor.fromBytes(markerIcon),
//         ));
//       });
//     }
//   }
//
//   void _onCameraMove(CameraPosition position) {
//     _currentMapPosition = position.target;
//   }
//
//   void _onMapCreated(GoogleMapController controller) {
//     mapController = controller;
//     _moveCamera();
//   }
//
//   void _moveCamera() {
//     mapController?.animateCamera(CameraUpdate.newLatLng(_center));
//   }
//
//   Future<Uint8List> _createCustomMarkerBitmap(String title, String snippet) async {
//     final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
//     final Canvas canvas = Canvas(pictureRecorder);
//     final Paint paint = Paint()..color = Colors.white;
//
//     // TextPainter to measure the text size
//
//     final TextPainter titleTextPainter = TextPainter(
//       textDirection: TextDirection.ltr,
//       text: TextSpan(
//         text: title,
//         style: const TextStyle(
//           fontSize: 25.0,
//           color: Colors.black,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//     );
//
//     final TextPainter snippetTextPainter = TextPainter(
//       textDirection: TextDirection.ltr,
//       text: TextSpan(
//         text: snippet,
//         style: const TextStyle(
//           fontSize: 25.0,
//           color: Colors.black,
//         ),
//       ),
//     );
//
//     // Layout the text to get the size
//     titleTextPainter.layout(minWidth: 0, maxWidth: double.infinity);
//     snippetTextPainter.layout(minWidth: 0, maxWidth: double.infinity);
//
//     // Calculate the width and height based on text size
//     final double width = (titleTextPainter.width > snippetTextPainter.width
//         ? titleTextPainter.width
//         : snippetTextPainter.width) + 20.0;
//     final double height = titleTextPainter.height + snippetTextPainter.height + 40.0;
//
//     // Draw rounded rectangle
//     canvas.drawRRect(
//       RRect.fromRectAndRadius(
//         Rect.fromLTWH(0.0, 0.0, width, height),
//         Radius.circular(10.0),
//       ),
//       paint,
//     );
//
//     const double iconSize = 100.0;
//     final Paint markerPaint = Paint()..color = Colors.red;
//
//     // Draw the marker path
//     final Path markerPath = Path()
//       ..moveTo(width / 2 - iconSize / 2, height)
//       ..lineTo(width / 2, height + iconSize / 2)
//       ..lineTo(width / 2 + iconSize / 2, height)
//       ..close();
//     canvas.drawPath(markerPath, markerPaint);
//
//     // Draw title
//     titleTextPainter.paint(
//       canvas,
//       Offset(10.0, 10.0),
//     );
//
//     // Draw snippet
//     snippetTextPainter.paint(
//       canvas,
//       Offset(10.0, titleTextPainter.height + 20.0),
//     );
//
//     // Convert canvas to image
//     final ui.Image markerAsImage = await pictureRecorder.endRecording().toImage(
//       width.toInt(),
//       height.toInt() + (iconSize / 2).toInt(),
//     );
//
//     final ByteData? byteData = await markerAsImage.toByteData(
//       format: ui.ImageByteFormat.png,
//     );
//
//     return byteData!.buffer.asUint8List();
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//        title: Text(widget.locationName),
//       ),
//       //appBar: getAppBarBack(context,"${widget.locationName}"),
//       body: Stack(
//         children: <Widget>[
//           GoogleMap(
//             onMapCreated: _onMapCreated,
//             initialCameraPosition: CameraPosition(
//               target: _center,
//               zoom: 15.0,
//             ),
//             markers: _markers,
//             onCameraMove: _onCameraMove,
//           ),
//           // Positioned(
//           //   bottom: 16.0,
//           //   left: 16.0,
//           //   child: FloatingActionButton(
//           //     onPressed: _moveCamera,
//           //     child: GestureDetector(
//           //       onTap: (){
//           //         setState(() {
//           //           lat = double.parse('${widget.fLatitude}');
//           //           long = double.parse('${widget.fLongitude}');
//           //           print('---215--$lat');
//           //           print('---216--$long');
//           //           launchGoogleMaps(lat!, long!);
//           //         });
//           //         setState(() {
//           //
//           //         });
//           //       },
//           //       // child: Icon(Icons.my_location)
//           //       child: Container(
//           //           height: 25,
//           //           width: 25,
//           //           decoration: BoxDecoration(
//           //             borderRadius: BorderRadius.circular(5),
//           //           ),
//           //           child: Image.asset('assets/images/direction.jpeg',
//           //             height: 25,
//           //             width: 25,
//           //             fit: BoxFit.fill,
//           //           )
//           //       ),
//           //
//           //     ),
//           //   ),
//           // ),
//         ],
//       ),
//     );
//   }
// }
//
// void navigateToTempleGoogleMap(
//     BuildContext context,
//     double fLatitude,
//     double fLongitude,
//     String locationName,
//     String sLocationAddress,
//     ) {
//   Navigator.push(
//     context,
//     MaterialPageRoute(
//       builder: (context) => ParkGoogleMap(
//         fLatitude: fLatitude,
//         fLongitude: fLongitude,
//         locationName: locationName,
//         sLocationAddress: sLocationAddress,
//       ),
//     ),
//   );
// }

