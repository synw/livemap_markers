import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:latlong/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'geo_marker.dart';
import '../controller.dart';
import '../widgets/widget.dart';

class WidgetMarker implements GeoMarkerContract {
  WidgetMarker(
      {@required this.name,
      @required this.point,
      this.width,
      this.height,
      @required this.markerWidgetBuilder,
      @required this.markersController}) {
    width = width ?? 35.0;
    height = height ?? 35.0;
  }

  final String name;
  final LatLng point;
  double width;
  double height;
  final WidgetBuilder markerWidgetBuilder;
  final MarkersController markersController;

  GeoMarkerType get type => GeoMarkerType.icon;

  Marker buildMarker() {
    return Marker(
      width: width,
      height: height,
      point: point,
      builder: (_) => WidgetMarkerWidget(
            name: name,
            point: point,
            markersController: markersController,
            markerWidgetBuilder: markerWidgetBuilder,
          ),
    );
  }
}
