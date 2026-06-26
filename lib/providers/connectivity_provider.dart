import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Streams true/false for "is the device currently online".
/// connectivity_plus reports the active connection type(s); we treat
/// "none" as offline and anything else (wifi, mobile, ethernet) as online.
final isOnlineProvider = StreamProvider<bool>((ref) {
  return Connectivity().onConnectivityChanged.map(
        (results) => !results.contains(ConnectivityResult.none),
      );
});
