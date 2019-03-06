import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:latlong/latlong.dart';
import '../controller.dart';

class WidgetMarkerWidget extends StatelessWidget {
  WidgetMarkerWidget(
      {Key key,
      @required this.name,
      @required this.point,
      @required this.markerWidgetBuilder,
      @required this.markersController})
      : super(key: key);

  final String name;
  final LatLng point;
  final WidgetBuilder markerWidgetBuilder;
  final MarkersController markersController;

  @override
  Widget build(BuildContext context) {
    return markerWidgetBuilder(context);
  }
}
