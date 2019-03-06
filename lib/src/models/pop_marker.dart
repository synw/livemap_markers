import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:latlong/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import '../widgets/pop_marker.dart';
import 'geo_marker.dart';
import '../logger.dart';
import '../controller.dart';

class PopMarker implements GeoMarkerContract {
  PopMarker(
      {@required this.name,
      @required this.point,
      @required this.markersController,
      @required this.popWidget,
      @required this.onTap,
      @required this.isPoped});

  final String name;
  final LatLng point;

  final MarkersController markersController;
  final Widget popWidget;
  final GeoMarkerActionCallback onTap;
  bool isPoped;

  GeoMarkerType get type => GeoMarkerType.crud;

  Marker buildMarker() {
    return Marker(
        width: 200.0,
        height: 160.0,
        point: point,
        builder: (_) => PopMarkerWidget(
              isPoped: isPoped,
              name: name,
              onTap: onTap,
              point: point,
              popWidget: popWidget,
            ));
  }
}
