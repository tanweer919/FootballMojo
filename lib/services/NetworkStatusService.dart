import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:developer' as developer;

enum NetworkStatus { Online, Offline }

class NetworkStatusService {
  final StreamController<NetworkStatus> networkStatusController =
      StreamController<NetworkStatus>.broadcast();
  StreamSubscription? _connectivitySubscription;
  NetworkStatus? _lastStatus;
  bool _isDisposed = false;

  NetworkStatusService() {
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      developer.log('Initializing NetworkStatusService');
      await _checkInitialStatus();
      _setupConnectivityListener();
      developer.log('NetworkStatusService initialized successfully');
    } catch (e, stackTrace) {
      developer.log(
        'Error initializing NetworkStatusService',
        error: e,
        stackTrace: stackTrace,
      );
      // Set initial status to offline if initialization fails
      if (!_isDisposed) {
        networkStatusController.add(NetworkStatus.Offline);
        _lastStatus = NetworkStatus.Offline;
      }
    }
  }

  void _setupConnectivityListener() {
    _connectivitySubscription?.cancel();
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen(
      (List<ConnectivityResult> resultList) async {
        try {
          final status = await _getNetworkStatus(resultList);
          if (status != _lastStatus && !_isDisposed) {
            developer.log('Network status changed to: $status');
            networkStatusController.add(status);
            _lastStatus = status;
          }
        } catch (e, stackTrace) {
          developer.log(
            'Error processing connectivity change',
            error: e,
            stackTrace: stackTrace,
          );
        }
      },
      onError: (error, stackTrace) {
        developer.log(
          'Error in connectivity listener',
          error: error,
          stackTrace: stackTrace,
        );
      },
    );
  }

  void dispose() {
    if (!_isDisposed) {
      developer.log('Disposing NetworkStatusService');
      _isDisposed = true;
      _connectivitySubscription?.cancel();
      if (!networkStatusController.isClosed) {
        networkStatusController.close();
      }
    }
  }

  Future<void> _checkInitialStatus() async {
    try {
      final initialResultList = await Connectivity().checkConnectivity();
      final status = await _getNetworkStatus(initialResultList);
      if (status != _lastStatus && !_isDisposed) {
        developer.log('Initial network status: $status');
        networkStatusController.add(status);
        _lastStatus = status;
      }
    } catch (e, stackTrace) {
      developer.log(
        'Error checking initial network status',
        error: e,
        stackTrace: stackTrace,
      );
      if (!_isDisposed) {
        networkStatusController.add(NetworkStatus.Offline);
        _lastStatus = NetworkStatus.Offline;
      }
    }
  }

  Future<NetworkStatus> _getNetworkStatus(
      List<ConnectivityResult> resultList) async {
    try {
      if (resultList.isEmpty || resultList.contains(ConnectivityResult.none)) {
        if (resultList.length > 1 &&
            resultList.any((r) => r != ConnectivityResult.none)) {
          if (resultList.any((r) =>
              r == ConnectivityResult.mobile ||
              r == ConnectivityResult.wifi ||
              r == ConnectivityResult.ethernet ||
              r == ConnectivityResult.vpn)) {
            return NetworkStatus.Online;
          }
        }
        return NetworkStatus.Offline;
      } else if (resultList.any((r) =>
          r == ConnectivityResult.mobile ||
          r == ConnectivityResult.wifi ||
          r == ConnectivityResult.ethernet ||
          r == ConnectivityResult.vpn)) {
        return NetworkStatus.Online;
      }
      return NetworkStatus.Offline;
    } catch (e, stackTrace) {
      developer.log(
        'Error determining network status',
        error: e,
        stackTrace: stackTrace,
      );
      return NetworkStatus.Offline;
    }
  }
}
