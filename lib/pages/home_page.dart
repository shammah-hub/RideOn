import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../global/global_var.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final Completer<GoogleMapController> googleMapCompleterController = Completer<GoogleMapController>();
  GoogleMapController? controllerGoogleMap;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
          myLocationButtonEnabled: true,
          initialCameraPosition: googlePlexInitialPosition,
        onMapCreated: (GoogleMapController mapController){
          controllerGoogleMap = mapController;
          googleMapCompleterController.complete(controllerGoogleMap);

        },
      ),
    );
  }
}
