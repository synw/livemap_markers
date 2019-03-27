import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:latlong/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:speech_bubble/speech_bubble.dart';
import '../widgets/pop_marker.dart';
import 'geo_marker.dart';
import '../logger.dart';
import '../controller.dart';

class BubbleMarker implements GeoMarkerContract {
  BubbleMarker(
      {@required this.name,
      @required this.point,
      @required this.markersController,
      @required this.onTap,
      @required this.isPoped,
      this.bubbleColor,
      this.popWidget}) {
    popWidget = popWidget ?? Text(name);
    bubbleColor = bubbleColor ?? Colors.green;
  }

  final String name;
  final LatLng point;
  final MarkersController markersController;
  final GeoMarkerActionCallback onTap;
  Color bubbleColor;
  Widget popWidget;
  bool isPoped;

  GeoMarkerType get type => GeoMarkerType.crud;

  Marker buildMarker() {
    return Marker(
        width: 200.0,
        height: 160.0,
        point: point,
        builder: (context) {
          return PopMarkerWidget(
            name: name,
            point: point,
            size: 40.0,
            isPoped: isPoped,
            popWidget: GestureDetector(
              child: SpeechBubble(
                child: popWidget,
                color: bubbleColor,
              ),
              onTap: () => onTap(context),
            ),
            onTap: (_) => markersController.togglePop(name: name),
          );
        });
  }
}
