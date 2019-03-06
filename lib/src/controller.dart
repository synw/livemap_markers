import 'package:flutter/foundation.dart';
import 'package:sqlcool/sqlcool.dart';
import 'package:livemap/livemap.dart';
import 'state/map.dart';
import 'models/geo_marker.dart';

class MarkersController {
  MarkersController({@required this.liveMapController, @required this.db})
      : assert(liveMapController != null),
        assert(db != null) {
    _markersMapState = MarkersMapState(
        db: db, liveMapController: liveMapController, markersController: this);
  }

  final LiveMapController liveMapController;
  final Db db;

  MarkersMapState _markersMapState;

  Future<void> addToMap({@required GeoMarker geoMarker}) =>
      _markersMapState.addToMap(geoMarker: geoMarker);
  Future<void> removeFromMap({@required String name}) =>
      _markersMapState.removeFromMap(name: name);
  Future<void> addMany({@required List<GeoMarker> geoMarkers}) =>
      _markersMapState.addMany(geoMarkers: geoMarkers);
  Future<void> removeMany({@required List<GeoMarker> geoMarkers}) =>
      _markersMapState.removeMany(geoMarkers: geoMarkers);

  Future<void> togglePop({@required String name}) =>
      _markersMapState.togglePop(name: name);

  bool isOnMap(String name) => _markersMapState.isOnMap(name);
}
