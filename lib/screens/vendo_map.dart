import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vendo/models/category.dart';
import 'package:vendo/models/location.dart';

class VendoMap extends StatefulWidget {
  const VendoMap({super.key, this.vmLocation});

  final Location? vmLocation;
  @override
  State<VendoMap> createState() => _VendoMapState();
}

class _VendoMapState extends State<VendoMap> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  List<Location> _vmLocations = Location.getLocations();
  BitmapDescriptor _markerIcon = BitmapDescriptor.defaultMarker;
  List<Set<Marker>> _markers = [];
  int _selectedIndex = 0;
  Category _category = Category.all;
  var _userCurrentLocation;
  List<Widget> _nearestVmWidgets = [];

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
            _markers.add(_vmLocations.map((location) =>
                Marker(
                    markerId: MarkerId(location.name),
                    position: LatLng(location.latitude, location.longitude),
                    infoWindow: InfoWindow(
                      title: location.name,
                      snippet: location.address,
                    ), // InfoWindow
                    icon: _markerIcon
                )
            ).toSet());
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

  Widget getNearestVm([Category? category]) {
    List<Location> filteredVmLocations = [];
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
    filteredVmLocations = _vmLocations;
    if (category != null) {
      filteredVmLocations = _vmLocations.where((location) =>
      location.category == category).toList();
      setState(() {
        _markers.add(filteredVmLocations.map((location) =>
            Marker(
                markerId: MarkerId(location.name),
                position: LatLng(location.latitude, location.longitude),
                infoWindow: InfoWindow(
                  title: location.name,
                  snippet: location.address,
                ), // InfoWindow
                icon: _markerIcon
            )
        ).toSet());
      });
    }
    int loopLength = filteredVmLocations.length > 2
        ? 3
        : filteredVmLocations.length;

    return Column(
      children: [
        for (var i = 0; i < loopLength; i++)
          nearestVmContent(filteredVmLocations[i].name, filteredVmLocations[i].distance!,
              filteredVmLocations[i].latitude,
              filteredVmLocations[i].longitude, _goToVmLocation)
      ]
    );
  }

  Future<void> _getCurrentLocation() async {
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

  Future<void> _showDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                  surfaceTintColor: Theme.of(context).colorScheme.background,
                  actionsAlignment: MainAxisAlignment.spaceBetween,
                  title: Text('Kategori Lokasi',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onBackground
                      )),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RadioListTile<Category>(
                          title: Text('Semua Vending Machine',
                              style: GoogleFonts.inter(fontSize: 17)),
                          value: Category.all,
                          groupValue: _category,
                          onChanged: (Category? value) {
                            setState(() {
                              _category = value!;
                            });
                            setSelectedIndex(0);
                          }
                      ),
                      RadioListTile<Category>(
                          title: Text('Vending Machine Makanan dan Minuman',
                              style: GoogleFonts.inter(fontSize: 17)),
                          value: Category.foodOrBeverage,
                          groupValue: _category,
                          onChanged: (Category? value) {
                            setState(() {
                              _category = value!;
                            });
                            setSelectedIndex(1);
                          }
                      ),
                      RadioListTile<Category>(
                          title: Text('Vending Machine Fashion',
                              style: GoogleFonts.inter(fontSize: 17)),
                          value: Category.fashion,
                          groupValue: _category,
                          onChanged: (Category? value) {
                            setState(() {
                              _category = value!;
                            });
                            setSelectedIndex(2);
                          }
                      ),
                    ],
                  )
              );
            }
        );
      },
    );
  }
  
  void setSelectedIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    _addCustomIcon();
    super.initState();
    _getCurrentLocation().then((value) {
      setState(() {
        _nearestVmWidgets.add(getNearestVm());
        _nearestVmWidgets.add(getNearestVm(Category.foodOrBeverage));
        _nearestVmWidgets.add(getNearestVm(Category.fashion));
      });
      if (widget.vmLocation != null) {
        _goToVmLocation(widget.vmLocation!.latitude, widget.vmLocation!.longitude);
      } else {
        _goToCurrentLocation();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          GestureDetector(
            onTap: _showDialog,
            child: Container(
              width: 50,
              height: 50,
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: const BoxDecoration(color: Color(0xFF2A4399),
                  shape: BoxShape.circle),
              child: const Icon(Icons.tune, color: Colors.white),
            ),
          )
        ],
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: _markers.isEmpty ? {} : _markers.elementAt(_selectedIndex),
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
        color: Theme.of(context).colorScheme.onPrimary,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Terdekat dari anda',
                style: GoogleFonts.inter(
                    fontSize: 23, fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            _userCurrentLocation != null && _nearestVmWidgets.isNotEmpty
                ? _nearestVmWidgets.elementAt(_selectedIndex)
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
    behavior: HitTestBehavior.opaque,
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




