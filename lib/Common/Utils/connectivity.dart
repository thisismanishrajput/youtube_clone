import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  StreamController<ConnectivityResult> connectionStatusController = StreamController<ConnectivityResult>();
  ConnectivityService() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      print(result);
      connectionStatusController.add(result);
    });
  }
}
