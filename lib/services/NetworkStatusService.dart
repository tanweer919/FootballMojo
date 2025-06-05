import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

enum NetworkStatus { Online, Offline }

class NetworkStatusService {
  StreamController<NetworkStatus> networkStatusController =
  StreamController<NetworkStatus>();

  // Keep track of the last status to avoid unnecessary updates if the status hasn't changed.
  // Though ConnectivityPlus might already handle this, it's a good practice for custom streams.
  NetworkStatus? _lastStatus; // Explicitly nullable

  NetworkStatusService() {
    // Immediately check the initial status
    _checkInitialStatus();
    Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> resultList) {
       // onConnectivityChanged can emit a list of results, handle the first one or iterate if needed.
      _getNetworkStatus(resultList).then((status) {
        if (status != _lastStatus) {
          networkStatusController.add(status);
          _lastStatus = status;
        }
      });
    });
  }

  Future<void> _checkInitialStatus() async {
    List<ConnectivityResult> initialResultList = await (Connectivity().checkConnectivity());
     _getNetworkStatus(initialResultList).then((status) {
        if (status != _lastStatus) {
          networkStatusController.add(status);
          _lastStatus = status;
        }
      });
  }

  Future<NetworkStatus> _getNetworkStatus(List<ConnectivityResult> resultList) async {
    // If the list is empty or contains ConnectivityResult.none, consider it offline.
    // Otherwise, if it contains mobile, wifi, ethernet, vpn, or other known connected states, consider it online.
    if (resultList.isEmpty || resultList.contains(ConnectivityResult.none)) {
      // Additional check: sometimes .none is reported briefly during network switches.
      // If multiple results are present, and one is not .none, it might still be online.
      // For simplicity here, if .none is present anywhere, or list is empty, treat as offline.
      // More sophisticated logic could be applied if needed based on specific platform behaviors.
      if (resultList.length > 1 && resultList.any((r) => r != ConnectivityResult.none)) {
         // If there's a mix, and one of them is a connected type, prefer Online.
         // This handles cases where, for example, both mobile and wifi might be briefly reported during a switch,
         // or if .none is reported alongside an active connection type.
        if (resultList.any((r) => r == ConnectivityResult.mobile || r == ConnectivityResult.wifi || r == ConnectivityResult.ethernet || r == ConnectivityResult.vpn)) {
          return NetworkStatus.Online;
        }
      }
      return NetworkStatus.Offline;
    } else if (resultList.any((r) => r == ConnectivityResult.mobile || r == ConnectivityResult.wifi || r == ConnectivityResult.ethernet || r == ConnectivityResult.vpn)) {
      return NetworkStatus.Online;
    }
    // Default to offline for unknown or unhandled states like .bluetooth or .other,
    // unless the app specifically uses them for data.
    return NetworkStatus.Offline;
  }
}