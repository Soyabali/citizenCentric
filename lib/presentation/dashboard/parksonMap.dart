import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/gestures.dart';
import '../../domain/model/parksonmapModel.dart';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';

class ParkSonMap extends StatefulWidget {
  final List<ParksonmapModel> parks;
  final Function(GoogleMapController) onMapCreated;
  final LatLng? currentLocation;
  final ParksonmapModel? selectedPark;

  const ParkSonMap({
    super.key,
    required this.parks,
    required this.onMapCreated,
    this.currentLocation,
    this.selectedPark
  });

  @override
  State<ParkSonMap> createState() => _ParkSonMapState();
}

class _ParkSonMapState extends State<ParkSonMap> {

  GoogleMapController? _mapController;
  ParksonmapModel? _selectedPark;
  Set<Marker> _markers = {};

  // --------------------------------------------------
  // 🎯 CUSTOM POPUP (SAFE – NO OVERFLOW)
  // --------------------------------------------------
  Widget _greenInfoPopup() {
    if (_selectedPark == null) return const SizedBox();

    final Color popupColor =
    _getPopupColorByDivision(_selectedPark!.divisionName);

    return Positioned(
      top: 12, // 👈 always visible, safe area
      left: 16,
      right: 16,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          // ✅ dismiss popup on tap
          setState(() {
            _selectedPark = null;
          });
        },
        child: Material(
          elevation: 6,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: popupColor,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Park Name : ${_selectedPark!.parkName}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Agency Name : ${_selectedPark!.agencyName}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --------------------------------------------------
  // 🧠 INIT
  // --------------------------------------------------
  @override
  void initState() {
    super.initState();
    _loadMarkers();
  }

  @override
  void didUpdateWidget(covariant ParkSonMap oldWidget) {
    super.didUpdateWidget(oldWidget);

    // 🔴 CLEAR POPUP WHEN SEARCH CLEARED
    if (widget.selectedPark == null &&
        oldWidget.selectedPark != null) {
      setState(() {
        _selectedPark = null;
      });
    }

    // 🟢 FOCUS WHEN NEW PARK SELECTED
    if (widget.selectedPark != null &&
        widget.selectedPark != oldWidget.selectedPark) {
      _focusOnPark(widget.selectedPark!);
    }

    if (oldWidget.parks != widget.parks) {
      _loadMarkers();
    }
  }

  // open GreenFocus
  Future<void> _focusOnPark(ParksonmapModel park) async {
    if (_mapController == null) return;

    await _mapController!.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(park.latitude, park.longitude),
          zoom: 16,
        ),
      ),
    );

    setState(() {
      _selectedPark = park; // 👈 OPEN GREEN POPUP
    });
  }
  // --------------------------------------------------
// 🎨 DIVISION → POPUP COLOR
// --------------------------------------------------
  Color _getPopupColorByDivision(String divisionName) {
    switch (divisionName.trim().toLowerCase()) {
      case 'division 1':
        return  const Color(0xFFFFA000); // yellow
      case 'division 2':
        return const Color(0xFFd93124); // purple
      case 'division 3':
        return const Color(0xFF3E5AFC); // blue
      default:
        return const Color(0xFF03DAC5); // default teal
    }
  }
  // --------------------------------------------------
  // 🎨 DIVISION → MARKER ICON
  // --------------------------------------------------
  Future<BitmapDescriptor> _getMarkerIconByDivision(
      String divisionName,
      ) async {
    try {
      String assetPath;

      switch (divisionName.trim().toLowerCase()) {
        case 'division 1':
          assetPath = 'assets/images/park_yellow.png';
          break;
        case 'division 2':
          assetPath = 'assets/images/park_purpel.png';
          break;
        case 'division 3':
          assetPath = 'assets/images/park_blue.png';
          break;
        default:
          return BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen,
          );
      }

      final ByteData data = await rootBundle.load(assetPath);
      final ui.Codec codec = await ui.instantiateImageCodec(
        data.buffer.asUint8List(),
        targetWidth: 96, // 👈 iOS safe size
      );
      final ui.FrameInfo fi = await codec.getNextFrame();
      final ByteData? bytes =
      await fi.image.toByteData(format: ui.ImageByteFormat.png);

      if (bytes == null) {
        throw Exception("Image bytes null");
      }

      return BitmapDescriptor.fromBytes(bytes.buffer.asUint8List());
    } catch (e) {
      // 🔥 iOS fallback (IMPORTANT)
      debugPrint('Marker icon load failed: $e');

      return BitmapDescriptor.defaultMarkerWithHue(
        divisionName.contains('1')
            ? BitmapDescriptor.hueYellow
            : divisionName.contains('2')
            ? BitmapDescriptor.hueViolet
            : BitmapDescriptor.hueAzure,
      );
    }
  }

  // --------------------------------------------------
  // 📍 LOAD MARKERS (SAFE)
  // --------------------------------------------------
  Future<void> _loadMarkers() async {
    Set<Marker> tempMarkers = {};

    for (final park in widget.parks) {
      if (park.latitude == 0 || park.longitude == 0) continue;

      final icon = await _getMarkerIconByDivision(park.divisionName);

      tempMarkers.add(
        Marker(
          markerId: MarkerId('park_${park.uid}',
          ),
          // markerId: MarkerId(
          //   '${park.latitude}_${park.longitude}_${park.divisionName}',
          // ),
          position: LatLng(park.latitude, park.longitude),
          icon: icon,
          onTap: () async {
            if (_mapController == null) return;

            // 1️⃣ Move camera slightly ABOVE marker
            await _mapController!.animateCamera(
              CameraUpdate.newLatLng(
                LatLng(
                  park.latitude + 0.0015, // 👈 vertical offset (15–20dp feeling)
                  park.longitude,
                ),
              ),
            );

            // 2️⃣ Then show popup
            setState(() {
              _selectedPark = park;
            });
            // if (_mapController == null) return;
          },
        ),
      );
    }

    if (mounted) {
      setState(() {
        _markers = tempMarkers;
        _selectedPark = null;
      });
    }
  }

  // --------------------------------------------------
  // 🔍 ZOOM CONTROLS
  // --------------------------------------------------
  Future<void> _zoomIn() async {
    final zoom = await _mapController?.getZoomLevel() ?? 14;
    _mapController?.animateCamera(CameraUpdate.zoomTo(zoom + 1));
  }

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

  // --------------------------------------------------
  // 🗺️ UI
  // --------------------------------------------------
  @override
  Widget build(BuildContext context) {
    if (widget.parks.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    final LatLng center = widget.currentLocation ??
        LatLng(
          widget.parks.first.latitude,
          widget.parks.first.longitude,
        );

    return Expanded(
      child: Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) {
              _mapController = controller;
              widget.onMapCreated(controller);
            },
            onTap: (_) {
              setState(() {
                _selectedPark = null;
              });
            },
            initialCameraPosition: CameraPosition(
              target: center,
              zoom: 12,
            ),
            markers: _markers,
            myLocationEnabled: false,
            myLocationButtonEnabled: false,
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
