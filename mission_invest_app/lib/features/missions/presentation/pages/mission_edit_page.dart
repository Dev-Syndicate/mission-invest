import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/widgets/app_button.dart';

class MissionEditPage extends ConsumerWidget {
  final String missionId;

  const MissionEditPage({super.key, required this.missionId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Load mission data and populate form
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Mission')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Spacer(),
            AppButton(
              label: 'Save Changes',
              onPressed: () {
                // TODO: Implement save
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
