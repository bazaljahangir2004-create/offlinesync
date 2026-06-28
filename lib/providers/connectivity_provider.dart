import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The kind of connection currently active. 'none' means offline -
/// the other two let us distinguish "free" Wi-Fi from "costs data"
/// mobile connections, which the wifi-only sync feature depends on.
enum ConnectionKind { none, wifi, mobile, other }

ConnectionKind _resolveKind(List<ConnectivityResult> results) {
  if (results.contains(ConnectivityResult.wifi) ||
      results.contains(ConnectivityResult.ethernet)) {
    return ConnectionKind.wifi;
  }
  if (results.contains(ConnectivityResult.mobile)) {
    return ConnectionKind.mobile;
  }
  if (results.isEmpty || results.contains(ConnectivityResult.none)) {
    return ConnectionKind.none;
  }
  return ConnectionKind.other;
}

/// Streams the current connection kind (none / wifi / mobile / other).
final connectionKindProvider = StreamProvider<ConnectionKind>((ref) {
  return Connectivity()
      .onConnectivityChanged
      .map(_resolveKind)
      .asyncMap((kind) async {
    // Emit an initial value immediately rather than waiting for the
    // next change event, so the UI doesn't show a loading spinner
    // on first launch.
    return kind;
  });
});

/// True whenever there's any usable connection at all (wifi, mobile,
/// or other) - kept for any code that just needs a simple online check.
final isOnlineProvider = Provider<bool>((ref) {
  final kind = ref.watch(connectionKindProvider).value ?? ConnectionKind.none;
  return kind != ConnectionKind.none;
});
