import 'package:err/err.dart';

var log = ErrRouter(
    errorRoute: [ErrRoute.console, ErrRoute.screen],
    infoRoute: [ErrRoute.screen]);
