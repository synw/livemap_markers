import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:latlong/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geopoint_sql/geopoint_sql.dart' as sql;
import 'package:sqlcool/sqlcool.dart';
import '../widgets/pop_marker.dart';
import 'package:geopoint/geopoint.dart';
import 'geo_marker.dart';
import '../logger.dart';
import '../controller.dart';

class CrudMarker implements GeoMarkerContract {
  CrudMarker(
      {@required this.database,
      @required this.name,
      @required this.markersController,
      @required this.isPoped,
      this.geoPoint,
      this.point});

  final Db database;
  final String name;
  final MarkersController markersController;
  LatLng point;
  bool isPoped;
  GeoPoint geoPoint;

  GeoMarkerType get type => GeoMarkerType.crud;

  Future<void> save() async {
    geoPoint = await sql
        .saveGeoPoint(
            verbose: true,
            database: database,
            geoPoint: GeoPoint.fromLatLng(name: name, point: point))
        .catchError((e) {
      log.error("Can not save marker", err: e);
    });
  }

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
            popWidget: Row(children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.edit,
                  size: 50.0,
                  color: Colors.blueGrey,
                ),
                onPressed: () => null,
              ),
              IconButton(
                icon: Icon(
                  Icons.delete,
                  size: 50.0,
                  color: Colors.red,
                ),
                onPressed: () async {
                  if (geoPoint == null) {
                    log.errorScreen(
                        "Trying to delete geoMarker: the id is null",
                        context: context);
                    return;
                  }
                  markersController.removeFromMap(name: name);
                  await database
                      .delete(table: "geopoint", where: "id=${geoPoint.id}")
                      .catchError((e) {
                    log.errorScreen("Can not delete geoMarker",
                        err: e, context: context);
                  });
                },
              ),
            ]),
            onTap: (_) {
              markersController.togglePop(name: name);
            },
          );
        });
  }
}
