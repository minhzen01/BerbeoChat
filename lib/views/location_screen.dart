import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({
    Key? key,
    required this.lati,
    required this.long
  }) : super(key: key);
  final double lati;
  final double long;

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  late GoogleMapController mapController;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    final marker = Marker(
      markerId: const MarkerId('Place position'),
      position: LatLng(widget.lati, widget.long),
      // icon: BitmapDescriptor.,
    );

    setState(() {
      markers[const MarkerId('Vị trí của tôi')] = marker;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: GoogleMap(
         mapType: MapType.normal,
         initialCameraPosition: CameraPosition(
             target: LatLng(widget.lati, widget.long),
             zoom: 15
         ),
        onMapCreated: _onMapCreated,
        markers: markers.values.toSet(),
      ),
    );
  }
}
