import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vendo/models/location.dart';

class VendoMap extends StatefulWidget {
  const VendoMap({super.key});

  @override
  State<VendoMap> createState() => _VendoMapState();
}

class _VendoMapState extends State<VendoMap> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  final List<Location> _vmLocations = Location.getLocations();
  BitmapDescriptor _markerIcon = BitmapDescriptor.defaultMarker;
  Set<Marker> _markers = {};
  var _userCurrentLocation;


  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  void _addCustomIcon() {
    BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), "images/vendo_marker.png"
    ).then((icon) {
          setState(() {
            _markerIcon = icon;
            _markers = _vmLocations.map((location) =>
                Marker(
                    markerId: MarkerId(location.name),
                    position: LatLng(location.latitude, location.longitude),
                    infoWindow: InfoWindow(
                      title: location.name,
                      snippet: location.address,
                    ), // InfoWindow
                    icon: _markerIcon
                )
            ).toSet();
          });
      },
    );
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  Widget getNearestVm() {
    Position userCurrentLocation = _userCurrentLocation;

    for (var i = 0; i < _vmLocations.length; i++) {
      double distance = calculateDistance(
          userCurrentLocation.latitude,
          userCurrentLocation.longitude,
          _vmLocations[i].latitude,
          _vmLocations[i].longitude
      );
      setState(() {
        _vmLocations[i].distance = distance;
      });
    }
    setState(() {
      _vmLocations.sort((e1, e2) => e1.distance!.compareTo(e2.distance!));
    });
    return Column(
      children: [
        for (var i = 0; i < 3; i++)
          nearestVmContent(_vmLocations[i].name, _vmLocations[i].distance!,
              _vmLocations[i].latitude, _vmLocations[i].longitude, _goToVmLocation)
      ]
    );
  }

  Future<void> _getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) async {
      await Geolocator.requestPermission();
      debugPrint("ERROR $error");
    });
    var location = await Geolocator.getCurrentPosition();
    setState(() {
      _userCurrentLocation = location;
    });
    _goToCurrentLocation();
  }



  Future<void> _goToCurrentLocation() async {
    final GoogleMapController controller = await _controller.future;
    await controller
        .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target:
          LatLng(_userCurrentLocation.latitude, _userCurrentLocation.longitude),
      zoom: 14.4746,
    )));
  }

  Future<void> _goToVmLocation(double latitude, double longitude) async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(latitude, longitude),
            zoom: 18,
          )
        )
    );
  }

  @override
  void initState() {
    _addCustomIcon();
    super.initState();
    _getUserCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: _markers,
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToCurrentLocation,
        backgroundColor: const Color(0xFF314797),
        foregroundColor: Colors.white,
        child: const Icon(Icons.gps_fixed),
      ),
      bottomNavigationBar: Container(
        height: MediaQuery.of(context).size.height * 0.27,
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Terdekat dari anda',
                style: GoogleFonts.inter(
                    fontSize: 23, fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            _userCurrentLocation != null
                ? getNearestVm()
                : const SizedBox()
          ]
        ),
      ),
    );
  }
}

Widget nearestVmContent(String locationName, double distance,
    double latitude, double longitude,
    void Function(double, double) onContentTapped) {
  return GestureDetector(
    onTap: () {
      onContentTapped(latitude, longitude);
    },
    child: Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(locationName,
                  style: GoogleFonts.inter(fontSize: 17)),
              Text("${distance.toStringAsFixed(1)} km",
                  style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w500,
                      color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 10),
          const Divider()
        ],
      )
    )
  );
}




