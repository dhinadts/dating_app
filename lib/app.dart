import 'package:dating_app/screens/discover_screen.dart';
import 'package:dating_app/screens/profile.screen.dart';
import 'package:dating_app/screens/settings_screen.dart';
import 'package:dating_app/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'screens/auth_gate.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    return MaterialApp(
      title: 'Flutter Dating Template',
      theme: ThemeData(primarySwatch: Colors.pink),
      // home: const AuthGate(),
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData.dark(),
      themeMode: themeMode,
      // default route
      initialRoute: '/',

      routes: {
        '/': (context) => const AuthGate(),
        '/settings': (context) => const SettingsScreen(),
        // add more screens here later:
        '/discover': (context) => const DiscoverScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}
