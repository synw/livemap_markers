import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:latlong/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'geo_marker.dart';
import '../widgets/icon.dart';
import '../controller.dart';

class IconMarker implements GeoMarkerContract {
  IconMarker(
      {@required this.name,
      @required this.point,
      @required this.markersController,
      this.icon,
      this.onTap}) {
    onTap = onTap ?? (_) => null;
  }

  final String name;
  final LatLng point;
  final MarkersController markersController;
  Icon icon;
  GeoMarkerActionCallback onTap;

  GeoMarkerType get type => GeoMarkerType.icon;

  Marker buildMarker() {
    return Marker(
        width: 35.0,
        height: 35.0,
        point: point,
        builder: (context) => IconMarkerWidget(
              name: name,
              point: point,
              onTap: onTap,
              icon: icon,
            ));
  }
}
