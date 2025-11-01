import 'package:dating_app/screens/add_profiles_screens.dart';
import 'package:dating_app/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: Column(
        children: [
          ListTile(
            title: const Text("Light Theme"),
            trailing: Radio(
              value: ThemeMode.light,
              groupValue: mode,
              onChanged: (v) {
                ref.read(themeModeProvider.notifier).state = v!;
              },
            ),
          ),
          ListTile(
            title: const Text("Dark Theme"),
            trailing: Radio(
              value: ThemeMode.dark,
              groupValue: mode,
              onChanged: (v) {
                ref.read(themeModeProvider.notifier).state = v!;
              },
            ),
          ),
          ListTile(
            title: const Text("System Default"),
            trailing: Radio(
              value: ThemeMode.system,
              groupValue: mode,
              onChanged: (v) {
                ref.read(themeModeProvider.notifier).state = v!;
              },
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await AddProfiles().insertSampleUsers();
        },
        tooltip: 'Save Settings',
        child: Icon(Icons.add),
      ),
    );
  }
}
