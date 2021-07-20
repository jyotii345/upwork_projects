/*
returns the flutter map to the home page and preserves the state
 */
import 'package:aggressor_adventures/classes/aggressor_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import "package:latlong2/latlong.dart";
import 'package:cached_network_image/cached_network_image.dart';

import 'globals_user_interface.dart';

class FlutterMapWidget {
  BuildContext context;

  bool hasLoaded = false;

  List<Marker> markerList = [];

  FlutterMapWidget(BuildContext context) {
    this.context = context;
  }

  Widget getMap() {
    //returns the widget that contains the flutter map
    try {
      return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: portrait ? MediaQuery.of(context).size.height / 5.5 : MediaQuery.of(context).size.width / 4.5,
        child:FlutterMap(
            options: new MapOptions(
              interactiveFlags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
              minZoom: 1.1,
              zoom: 1.1,
              bounds: LatLngBounds(LatLng(-80.0, -180.0), LatLng(80.0, 180.0)),
                boundsOptions: FitBoundsOptions(padding: EdgeInsets.all(8.0)),
            ),
            layers: [
              new TileLayerOptions(
                  urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c'],
                  tileProvider: CachedTileProvider()),
              MarkerLayerOptions(
                markers: markerList,
              ),
            ],
          ),
      );
    } catch (e) {
      return Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 7 + 4,
            color: AggressorColors.secondaryColor,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 7,
            child: Image.asset(
              "assets/bannerimage.png",
              fit: BoxFit.cover,
            ),
          )
        ],
      );
    }
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

class CachedTileProvider extends TileProvider {
  const CachedTileProvider();

  @override
  ImageProvider getImage(Coords<num> coords, TileLayerOptions options) {
    return CachedNetworkImageProvider(
      getTileUrl(coords, options),
      //Now you can set options that determine how the image gets cached via whichever plugin you use.
    );
  }
}
