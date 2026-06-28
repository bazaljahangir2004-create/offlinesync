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

    // Also attempt a sync right when the app starts, in case there
    // are pending reports left over from a previous offline session
    // and we're already online now.
    ref.listen(authStateProvider, (previous, next) {
      if (next.value != null) {
        ref.read(syncServiceProvider).syncAllPending();
      }
    });

    return MaterialApp(
      title: 'OfflineSync',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF1F8A5C),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF7F8F6),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
        ),
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
