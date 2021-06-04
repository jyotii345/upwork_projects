/*
returns the flutter map to the home page and preserves the state
 */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

class FlutterMapWidget {
  BuildContext context;

  bool hasLoaded = false;

  List<Marker> markerList = [];

  FlutterMapWidget(BuildContext context) {
    this.context = context;
  }

  Widget getMap() {
    //returns the widget that contains the flutter map
    return SizedBox(
      width: MediaQuery.of(context).size.width, // or use fixed size like 200
      height: MediaQuery.of(context).size.height / 5.5,
      child: FlutterMap(
        options: new MapOptions(
          interactiveFlags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
          //TODO follow offline guide to cache world tiles
          minZoom: 0,
          zoom: 1.0,
          bounds: LatLngBounds(LatLng(-80.0, -180.0), LatLng(80.0, 180.0)),
        ),
        layers: [
          new TileLayerOptions(
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: ['a', 'b', 'c']),
          MarkerLayerOptions(
            markers: markerList,
          ),
        ],
      ),
    );
  }

  void addMarker(var lat, var long, size) {
    //adds a marker to the map at a specific location
    markerList.add(Marker(
      width: size,
      height: size,
      point: new LatLng(lat, long),
      builder: (ctx) => new Container(
        child: Image.asset("assets/redflag.png"),
      ),
    ));
  }
}
