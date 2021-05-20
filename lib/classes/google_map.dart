import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapWidget {
  BuildContext context;

  Completer<GoogleMapController> _controller = Completer(); //object for asyn map loading

  static const LatLng _center = const LatLng(0, 0);

  bool hasLoaded = false;

  GoogleMapWidget(BuildContext context) {
    this.context = context;
  }

  Widget getMap() {
    return SizedBox(
      width: MediaQuery.of(context).size.width, // or use fixed size like 200
      height: MediaQuery.of(context).size.height / 5,
      child: GoogleMap(
        rotateGesturesEnabled: false,
        tiltGesturesEnabled: false,
        mapType: MapType.normal,
        onMapCreated: (GoogleMapController controller) {
          if (!hasLoaded) {
            _controller.complete();
            hasLoaded = true;
          }
        },
        initialCameraPosition: CameraPosition(
          target: _center,
        ),
      ),
    );
  }
}
