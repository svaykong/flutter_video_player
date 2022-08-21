import 'package:connectivity_plus/connectivity_plus.dart';

import 'log_extension.dart';

Future<bool> checkInternetConnect() async {
  ConnectivityResult connectivityResult = await Connectivity().checkConnectivity();
  if (connectivityResult == ConnectivityResult.mobile) {
    "I am connected to a mobile network.".log();
    return true;
  } else if (connectivityResult == ConnectivityResult.wifi) {
    "I am connected to a wifi network.".log();
    return true;
  } else {
    return false;
  }
}
