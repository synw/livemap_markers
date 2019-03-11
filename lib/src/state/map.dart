import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:livemap/livemap.dart';
import 'package:sqlcool/sqlcool.dart';
import '../models/geo_marker.dart';
import '../logger.dart';

class MarkersMapState {
  MarkersMapState(
      {@required this.liveMapController,
      @required this.db,
      @required this.markersController});

  final LiveMapController liveMapController;
  var markersController;
  final Db db;

  Map<String, GeoMarker> _visibleGeoMarkers = {};

  bool isOnMap(String name) => _visibleGeoMarkers.containsKey(name);

  Future<void> addMany({@required List<GeoMarker> geoMarkers}) async {
    Map<String, Marker> mk = {};
    geoMarkers.forEach((m) {
      mk[m.name] = m.buildMarker();
      _visibleGeoMarkers[m.name] = m;
    });
    //print("ADD MANY MARKERS");
    liveMapController.addMarkers(markers: mk);
  }

  Future<void> removeMany({@required List<GeoMarker> geoMarkers}) async {
    var names = <String>[];
    geoMarkers.forEach((geoMarker) {
      names.add(geoMarker.name);
    });
    liveMapController.removeMarkers(names: names);
  }

  Future<void> addToMap({@required GeoMarker geoMarker}) async {
    Marker marker = geoMarker.subMarker.buildMarker();
    //print("ADD MARKER");
    await liveMapController.addMarker(name: geoMarker.name, marker: marker);
    _visibleGeoMarkers[geoMarker.name] = geoMarker;
  }

  Future<void> removeFromMap({@required String name}) async {
    await liveMapController.removeMarker(name: name);
    var res = _visibleGeoMarkers.remove(name);
    if (res == null)
      log.warning(
          "MarkersController.removeMarker : marker $name not found in map");
  }

  Future<void> togglePop({@required String name}) async {
    if (!_visibleGeoMarkers.containsKey(name)) {
      log.warning("Toggle pop marker: marker $name is not on the map");
      return;
    }
    GeoMarker subMarker = _visibleGeoMarkers[name];
    subMarker.subMarker.isPoped = !subMarker.subMarker.isPoped;
    await liveMapController.removeMarker(name: name);
    await liveMapController.addMarker(
        name: name, marker: subMarker.subMarker.buildMarker());
    _visibleGeoMarkers[name] = subMarker;
  }
}
