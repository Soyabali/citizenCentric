
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../domain/model/parkModel.dart';


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

