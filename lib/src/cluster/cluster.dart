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
    _previousZoom = liveMapController.zoom;
    _isClustered = liveMapController.zoom < clusteredZoomLevel;
    liveMapController.changeFeed.listen((change) {
      if (change.name == "zoom") {
        // rebuild the markers only if the change is needed and big enough
        num diff = _previousZoom - change.value;
        //print("ZOOM DIFF: $diff ($_previousZoom , ${change.value}");
        if ((diff < -0.9 || diff > 0.9)) {
          switch (_isClustered) {
            case true:
              if (change.value < clusteredZoomLevel) {
                return;
              }
              break;
            case false:
              if (change.value > clusteredZoomLevel) {
                return;
              }
          }
          //print(
          //    "CLUSTER ZOOM rebuild from cluster $name : ${change.value} / $diff");
          build(change.value);
          _previousZoom += diff;
        }
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
  double _previousZoom;
  bool _isClustered;

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
      _isClustered = true;
      await markersController.addToMap(geoMarker: geoMarker);
      _onMap.add(geoMarker);
    } else {
      _isClustered = false;
      await markersController.addMany(geoMarkers: geoMarkers);
      _onMap.addAll(geoMarkers);
    }
  }
}
