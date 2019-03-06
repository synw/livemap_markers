import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:latlong/latlong.dart';
import '../models/geo_marker.dart';

class IconMarkerWidget extends StatelessWidget {
  IconMarkerWidget(
      {Key key,
      @required this.name,
      @required this.point,
      @required this.icon,
      @required this.onTap})
      : assert(name != null),
        assert(point != null),
        super(key: key);

  final String name;
  final LatLng point;
  final GeoMarkerActionCallback onTap;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: icon,
      onPressed: () => onTap(context),
    );
  }
}
