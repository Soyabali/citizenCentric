
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapScreen extends StatefulWidget {
  const GoogleMapScreen({super.key});

  @override
  State<GoogleMapScreen> createState() => _MyAppState();
}

class _MyAppState extends State<GoogleMapScreen> {
  late GoogleMapController mapController;
  Set<Marker> markers = {};

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    setState(() {
      markers.add(Marker(
        markerId: MarkerId('marker1'),
        position: LatLng(28.6562,77.2410),
        infoWindow: InfoWindow(title: 'Lat Kila'),
      ));
    });
  }

  // this a variable PolyLine And PolyGone
  Set<Polyline> polylines = {
    Polyline(
      polylineId: PolylineId('route1'),
      points: [
        LatLng(37.7749, -122.4194),
        LatLng(37.8051, -122.4300),
        LatLng(37.8070, -122.4093),
      ],
      color: Colors.red,
      width: 2,
    ),
  };

  Set<Polygon> polygons = {
    Polygon(
      polygonId: PolygonId('area1'),
      points: [
        LatLng(37.7749, -122.4194),
        LatLng(37.8051, -122.4300),
        LatLng(37.8070, -122.4093),
      ],
      fillColor: Colors.green.withOpacity(0.3),
      strokeColor: Colors.green,
      strokeWidth: 2,
    ),
  };


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.green[700],
      ),
      home: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: const Text('Maps Sample App'),
            elevation: 2,
          ),
          body: ListView(
            children: [
              // basic GoogleMap Code

              // Container(
              //   height: MediaQuery.of(context).size.height,
              //   child: GoogleMap(
              //     initialCameraPosition: CameraPosition(
              //       target: LatLng(37.7749, -122.4194), // San Francisco coordinates
              //       zoom: 12,
              //     ),
              //   ),
              // )
              // -------basic GoogleMap code end-----.

              //  -----Add a Marker on a Location ---code.

              Container(
                height: MediaQuery.of(context).size.height,
                child: GoogleMap(
                  mapType: MapType.normal,// mapType
                 onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                      target: LatLng(28.6562,77.2410),
                  zoom: 12,
                  ),
                  markers: markers,
                ),
              )

              //  ---------end Marker code----

              //  to draw PolyLine and PolyGone on a Google map code.
              // Container(
              //   height: MediaQuery.of(context).size.height,
              //   child: GoogleMap(
              //     // map type
              //     mapType: MapType.normal,
              //     myLocationEnabled: true,
              //     initialCameraPosition: CameraPosition(
              //       target: LatLng(37.7749,-122.4194),
              //       zoom: 13,
              //     ),
              //     polylines: polylines,
              //     polygons: polygons,
              //   ),
              // )
            ],
          )
      ),
    );
  }
}
