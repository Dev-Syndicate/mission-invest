import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/display_mode.dart';
import '../../../../core/theme/theme_provider.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(selectedThemeNameProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          const _SectionHeader(title: 'Appearance'),
          ListTile(
            leading: const Icon(Icons.palette_outlined),
            title: const Text('Theme'),
            subtitle: Text(currentTheme.toUpperCase()),
            onTap: () => _showThemePicker(context, ref, currentTheme),
          ),
          _DisplayModeTile(ref: ref),
          const Divider(),
          const _SectionHeader(title: 'Account'),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Sign Out'),
            onTap: () {
              // TODO: Implement sign out
            },
          ),
        ],
      ),
    );
  }

  void _showThemePicker(
    BuildContext context,
    WidgetRef ref,
    String current,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Choose Theme',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            for (final theme in ['dark', 'light', 'gaming', 'pastel'])
              RadioListTile<String>(
                title: Text(theme[0].toUpperCase() + theme.substring(1)),
                value: theme,
                groupValue: current,
                onChanged: (v) {
                  if (v != null) {
                    ref.read(selectedThemeNameProvider.notifier).setTheme(v);
                  }
                  Navigator.pop(context);
                },
              ),
          ],
        ),
      ),
    );
  }
}

class _DisplayModeTile extends StatelessWidget {
  final WidgetRef ref;

  const _DisplayModeTile({required this.ref});

  @override
  Widget build(BuildContext context) {
    final mode = ref.watch(displayModeProvider);
    final isWin = mode == DisplayMode.win;

    return ListTile(
      leading: Icon(isWin ? Icons.celebration : Icons.self_improvement),
      title: const Text('Display Mode'),
      subtitle: Text(isWin ? 'Win Mode' : 'Focus Mode'),
      trailing: Switch(
        value: isWin,
        onChanged: (_) => ref.read(displayModeProvider.notifier).toggle(),
      ),
      onTap: () => ref.read(displayModeProvider.notifier).toggle(),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}
