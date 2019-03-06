import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:latlong/latlong.dart';
import 'package:livemap/livemap.dart';
import '../controller.dart';
import '../models/geo_marker.dart';

class MarkersCluster {
  MarkersCluster(
      {@required this.name,
      @required this.geoMarkers,
      @required this.liveMapController,
      @required this.markersController,
      @required this.clusteredZoomLevel,
      @required this.clusterMarkerPosition}) {
    liveMapController.changeFeed.listen((change) {
      if (change.name == "zoom") {
        print("ZOOM ${change.value}");
        build(change.value);
      }
    });
  }

  final String name;
  final List<GeoMarker> geoMarkers;
  final MarkersController markersController;
  final LiveMapController liveMapController;
  final double clusteredZoomLevel;
  final LatLng clusterMarkerPosition;

  bool _isInitialized = false;
  var _onMap = <GeoMarker>[];

  init() async {
    _isInitialized = true;
    build(liveMapController.zoom);
  }

  build(double zoom) async {
    assert(_isInitialized);
    //print("BUILD ZOOM $zoom");
    GeoMarker geoMarker = GeoMarker(
      name: name,
      point: clusterMarkerPosition,
      type: GeoMarkerType.widget,
      width: 65.0,
      height: 65.0,
      markerWidgetBuilder: (_) {
        return GestureDetector(
            onTap: () {
              liveMapController.zoomIn();
              liveMapController.centerOnPoint(clusterMarkerPosition);
            },
            child: Stack(
              children: <Widget>[
                Icon(
                  Icons.fiber_manual_record,
                  size: 65.0,
                  color: Colors.blue,
                ),
                Padding(
                  child: Text(
                    "${geoMarkers.length}",
                    textScaleFactor: 1.5,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  padding: EdgeInsets.only(top: 20.0, left: 26.0),
                ),
              ],
            ));
      },
      markersController: markersController,
    );
    await markersController.removeMany(geoMarkers: _onMap);
    _onMap = [];
    if (zoom < clusteredZoomLevel) {
      await markersController.addToMap(geoMarker: geoMarker);
      _onMap.add(geoMarker);
    } else {
      await markersController.addMany(geoMarkers: geoMarkers);
      _onMap.addAll(geoMarkers);
    }
  }
}
