import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kWifiOnlySyncKey = 'wifi_only_sync';

/// Persists and exposes the "only sync on Wi-Fi" preference.
/// Defaults to false (sync on any connection) so the app behaves
/// the same as before for anyone who never opens settings.
class WifiOnlySyncNotifier extends AsyncNotifier<bool> {
  @override
  Future<bool> build() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kWifiOnlySyncKey) ?? false;
  }

  Future<void> setValue(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kWifiOnlySyncKey, value);
    state = AsyncValue.data(value);
  }
}

final wifiOnlySyncProvider = AsyncNotifierProvider<WifiOnlySyncNotifier, bool>(
  WifiOnlySyncNotifier.new,
);
