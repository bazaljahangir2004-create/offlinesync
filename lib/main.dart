import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'providers/sync_provider.dart';
import 'providers/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: OfflineSyncApp()));
}

class OfflineSyncApp extends ConsumerWidget {
  const OfflineSyncApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Activates the background listener that auto-syncs pending
    // reports whenever connectivity is restored.
    ref.watch(autoSyncListenerProvider);

    final authState = ref.watch(authStateProvider);

    return MaterialApp(
      title: 'OfflineSync',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF2E7D32),
        useMaterial3: true,
      ),
      home: authState.when(
        data: (user) => user != null ? const HomeScreen() : const LoginScreen(),
        loading: () =>
            const Scaffold(body: Center(child: CircularProgressIndicator())),
        error: (err, _) => Scaffold(
          body: Center(child: Text('Auth error: $err')),
        ),
      ),
    );
  }
}
