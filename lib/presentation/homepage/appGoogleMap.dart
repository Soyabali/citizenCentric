import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../domain/model/park_model.dart';
import 'package:flutter/gestures.dart';

class AppGoogleMap extends StatefulWidget {
  final List<ParkModel> parks;
  final Function(GoogleMapController) onMapCreated;
  final LatLng? currentLocation; // 👈 ADD

  const AppGoogleMap({
    super.key,
    required this.parks,
    required this.onMapCreated,
    this.currentLocation,
  });

  @override
  State<AppGoogleMap> createState() => _AppGoogleMapState();
}

class _AppGoogleMapState extends State<AppGoogleMap> {
  GoogleMapController? _mapController;

  BitmapDescriptor? _parkMarkerIcon;
  BitmapDescriptor? _currentLocationIcon;

  ParkModel? _selectedPark;


  Widget _greenInfoPopup() {
    if (_selectedPark == null) return const SizedBox();

    return Positioned(
      top: 10,
      left: 20,
      right: 20,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedPark = null; // 👈 dismiss popup
          });
        },
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF03DAC5),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [

                /// ✅ Park Name (safe)
                Text(
                  'Park Name : ${_selectedPark!.sParkName}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    height: 1.3,
                  ),
                ),

                const SizedBox(height: 4),

                /// ✅ Agency Name (safe)
                Text(
                  'Agency Name : ${_selectedPark!.sAgencyName}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    height: 1.3,
                  ),
                ),

                const SizedBox(height: 6),

                /// ✅ Distance Row (MOST IMPORTANT FIX)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.directions_walk_outlined,
                      size: 20,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 6),

                    /// 🔥 Expanded prevents RIGHT OVERFLOW
                    Expanded(
                      child: Text(
                        'Park Distance : ${_selectedPark!.sParkDist}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // geta currentLocation
  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location service is enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    // Check permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return;
    }
    // Get current position
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // Move camera to current location
    _mapController?.animateCamera(
      CameraUpdate.newLatLng(
        LatLng(position.latitude, position.longitude),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadMarkers();
    _getCurrentLocation();
  }

  /// ✅ Load BOTH markers safely (Android + iOS)
  Future<void> _loadMarkers() async {
    _parkMarkerIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(devicePixelRatio: 1.0),
      'assets/images/park_marker2.png',
    );
    //   'assets/images/ic_user_location.png',
    _currentLocationIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(devicePixelRatio: 1.0),
      'assets/images/location.png',
    );

    if (mounted) setState(() {});
  }

  /// 🔹 Zoom In
  Future<void> _zoomIn() async {
    final zoom = await _mapController?.getZoomLevel() ?? 14;
    _mapController?.animateCamera(CameraUpdate.zoomTo(zoom + 1));
  }

  /// 🔹 Zoom Out
  Future<void> _zoomOut() async {
    final zoom = await _mapController?.getZoomLevel() ?? 14;
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

  /// ✅ Build ALL markers
  Set<Marker> _buildMarkers() {
    final Set<Marker> markers = {};

    for (final park in widget.parks) {
      markers.add(
        Marker(
          markerId: MarkerId('park_${park.iParkId}'),
          position: LatLng(park.fLatitude, park.fLongitude),
          icon: _parkMarkerIcon!,
          onTap: () {
            setState(() {
              _selectedPark = park; // 👈 OPEN CUSTOM POPUP
            });
          },
        ),
      );
    }

    if (widget.currentLocation != null && _currentLocationIcon != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('current_location'),
          position: widget.currentLocation!,
          icon: _currentLocationIcon!,
          onTap: () {
            setState(() {
              _selectedPark = null;
            });
          },
        ),
      );
    }

    return markers;
  }

  @override
  @override
  Widget build(BuildContext context) {
    if (widget.parks.isEmpty ||
        _parkMarkerIcon == null ||
        _currentLocationIcon == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final LatLng center = widget.currentLocation ??
        LatLng(
          widget.parks.first.fLatitude,
          widget.parks.first.fLongitude,
        );

    return Expanded(
      child: Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) {
              _mapController = controller;
              widget.onMapCreated(controller);
            },
            onTap: (LatLng position) {
              setState(() {
                _selectedPark = null; // 👈 DISMISS POPUP
              });
            },
            initialCameraPosition: CameraPosition(
              target: center,
              zoom: 14,
            ),
            markers: _buildMarkers(),
           // myLocationEnabled: false,
            //myLocationButtonEnabled: false,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: false,
            gestureRecognizers: {
              Factory<OneSequenceGestureRecognizer>(
                    () => EagerGestureRecognizer(),
              ),
            },
          ),

          _greenInfoPopup(),

          Positioned(
            right: 12,
            bottom: 50,
            child: Column(
              children: [
                _zoomButton(icon: Icons.add, onTap: _zoomIn),
                const SizedBox(height: 4),
                _zoomButton(icon: Icons.remove, onTap: _zoomOut),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
