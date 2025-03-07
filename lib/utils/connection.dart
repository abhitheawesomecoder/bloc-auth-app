import 'package:connectivity_plus/connectivity_plus.dart';

class Connection {
  Connection._internal();

  static final Connection instance = Connection._internal();
  static List<ConnectivityResult> _connectionStatus = [];
  final Connectivity _connectivity = Connectivity();

  factory Connection() {
    return instance;
  }

  Future<void> initConnection() async {
    _connectionStatus = await _connectivity.checkConnectivity();
  }

  bool get isConnected {
    if (_connectionStatus.contains(ConnectivityResult.mobile) ||
        _connectionStatus.contains(ConnectivityResult.wifi)) {
      return true;
    } else {
      return false;
    }
  }
}
