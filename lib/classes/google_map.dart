import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class GoogleMapWidget {
  BuildContext context;

  bool hasLoaded = false;

  GoogleMapWidget(BuildContext context) {
    this.context = context;
  }

  Widget getMap() {
    return SizedBox(
      width: MediaQuery.of(context).size.width, // or use fixed size like 200
      height: MediaQuery.of(context).size.height / 5.5,
      child: FlutterMap(
          options: new MapOptions(
            interactiveFlags: InteractiveFlag.pinchZoom | InteractiveFlag.drag, //TODO follow offline guide to cache world tiles
            minZoom: 0,
            zoom: 0.5,
          ),

          layers: [
            new TileLayerOptions(
                urlTemplate:
                    "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c']),
          ],),
      //     // new MarkerLayerOptions(
      //     //   markers: [
      //     //     new Marker(
      //     //       width: 80.0,
      //     //       height: 80.0,
      //     //       point: new LatLng(51.5, -0.09),
      //     //       builder: (ctx) =>
      //     //       new Container(
      //     //         child: new FlutterLogo(),
      //     //       ),
      //     //     ),
      //     //   ],
      //     // ),
      //   ],
      // ),
    );
  }
}
