import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:sqlcool/sqlcool.dart';
import 'package:latlong/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import '../controller.dart';
import '../models/crud_marker.dart';
import '../models/bubble_marker.dart';
import '../models/pop_marker.dart';
import '../models/icon_marker.dart';
import '../models/widget_marker.dart';

typedef void GeoMarkerActionCallback(BuildContext context);

enum GeoMarkerType { crud, bubble, pop, icon, widget }

abstract class GeoMarkerContract {
  GeoMarkerContract({@required this.type});

  final GeoMarkerType type;

  Marker buildMarker();
}

class GeoMarker {
  GeoMarker(
      {@required this.type,
      @required this.name,
      @required this.markersController,
      @required this.point,
      this.popWidget,
      this.markerWidgetBuilder,
      this.isPoped = false,
      this.database,
      this.icon,
      this.width,
      this.height,
      this.onTap}) {
    onTap ??= (_) => null;
    if ((type == GeoMarkerType.pop) && popWidget == null)
      throw ArgumentError.notNull("GeoMarker: a pop widget is required");
    if ((type == GeoMarkerType.crud) && database == null)
      throw ArgumentError.notNull("GeoMarker: a database is required");
    if ((type == GeoMarkerType.icon) && icon == null)
      throw ArgumentError.notNull("GeoMarker: an icon is required");
    if ((type == GeoMarkerType.widget) && markerWidgetBuilder == null)
      throw ArgumentError.notNull(
          "GeoMarker: a markerWidgetBuilder is required");
    switch (type) {
      case GeoMarkerType.crud:
        subMarker = CrudMarker(
            database: database,
            name: name,
            point: point,
            isPoped: isPoped,
            markersController: markersController);
        break;
      case GeoMarkerType.bubble:
        subMarker = BubbleMarker(
            name: name,
            point: point,
            markersController: markersController,
            isPoped: isPoped,
            popWidget: popWidget,
            onTap: onTap);
        break;
      case GeoMarkerType.pop:
        subMarker = PopMarker(
            name: name,
            point: point,
            isPoped: isPoped,
            markersController: markersController,
            popWidget: popWidget,
            onTap: onTap);
        break;
      case GeoMarkerType.icon:
        subMarker = IconMarker(
            name: name,
            point: point,
            icon: icon,
            markersController: markersController,
            onTap: onTap);
        break;
      case GeoMarkerType.widget:
        subMarker = WidgetMarker(
            name: name,
            point: point,
            width: width,
            height: height,
            markerWidgetBuilder: markerWidgetBuilder,
            markersController: markersController);
        break;
    }
  }

  final GeoMarkerType type;
  final String name;
  final LatLng point;
  final MarkersController markersController;
  Db database;
  Widget popWidget;
  dynamic subMarker;
  Icon icon;
  double width;
  double height;
  GeoMarkerActionCallback onTap;
  WidgetBuilder markerWidgetBuilder;

  bool isPoped;

  buildMarker() => subMarker.buildMarker();
}
