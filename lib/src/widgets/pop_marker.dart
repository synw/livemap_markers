import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:latlong/latlong.dart';
import '../models/geo_marker.dart';

class PopMarkerWidget extends StatelessWidget {
  PopMarkerWidget(
      {@required this.name,
      @required this.point,
      this.size,
      this.isPoped = false,
      @required this.popWidget,
      @required this.onTap});

  final String name;
  final LatLng point;
  final double size;
  final bool isPoped;
  final GeoMarkerActionCallback onTap;
  final Widget popWidget;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        isPoped
            ? GestureDetector(
                child: popWidget,
                onTap: () => onTap(context),
              )
            : Text(""),
        IconButton(
          icon: Icon(
            Icons.location_on,
            size: size,
          ),
          onPressed: () {
            print("ON TAP POP MARKER $name");
            onTap(context);
          },
        ),
      ],
    );
  }
}
