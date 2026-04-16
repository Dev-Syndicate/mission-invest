import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mission_invest_app/features/missions/data/models/mission_model.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../shared/widgets/app_loading.dart';
import '../../../../shared/widgets/app_error_widget.dart';
import '../../../missions/data/repositories/mission_repository.dart';
import '../widgets/milestone_share_card.dart';

class ShareMilestonePage extends ConsumerStatefulWidget {
  final String missionId;

  const ShareMilestonePage({super.key, required this.missionId});

  @override
  ConsumerState<ShareMilestonePage> createState() =>
      _ShareMilestonePageState();
}

class _ShareMilestonePageState extends ConsumerState<ShareMilestonePage> {
  final _screenshotController = ScreenshotController();
  bool _showAmounts = false;
  bool _isSharing = false;

  @override
  Widget build(BuildContext context) {
    final missionAsync = ref.watch(watchMissionProvider(widget.missionId));
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Share Milestone'),
      ),
      body: missionAsync.when(
        loading: () => const Center(child: AppLoading()),
        error: (error, _) => AppErrorWidget(
          message: 'Failed to load mission: $error',
          onRetry: () =>
              ref.invalidate(watchMissionProvider(widget.missionId)),
        ),
        data: (mission) {
          if (mission == null) {
            return const Center(child: Text('Mission not found'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Preview of the shareable card
                Center(
                  child: Screenshot(
                    controller: _screenshotController,
                    child: MilestoneShareCard(
                      goalName: mission.title,
                      progressPercent: mission.progressPercentage,
                      streakCount: mission.currentStreak,
                      showAmounts: _showAmounts,
                      savedAmount: mission.savedAmount,
                      targetAmount: mission.targetAmount,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Privacy toggle
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SwitchListTile(
                    title: const Text('Show amounts'),
                    subtitle: Text(
                      _showAmounts
                          ? 'Amounts will be visible on the shared card'
                          : 'Amounts are hidden for privacy',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withAlpha(153),
                      ),
                    ),
                    secondary: Icon(
                      _showAmounts
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: theme.colorScheme.primary,
                    ),
                    value: _showAmounts,
                    onChanged: (value) =>
                        setState(() => _showAmounts = value),
                  ),
                ),

                const SizedBox(height: 24),

                // Share button
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: _isSharing ? null : () => _shareCard(context),
                    icon: _isSharing
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.share),
                    label: Text(_isSharing ? 'Preparing...' : 'Share'),
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  'Your shared card will never include personal details.\n'
                  'Only goal name, progress %, and streak are shown.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withAlpha(120),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _shareCard(BuildContext context) async {
    setState(() => _isSharing = true);

    try {
      final Uint8List? imageBytes = await _screenshotController.capture(
        pixelRatio: 3.0,
      );

      if (imageBytes == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to capture screenshot')),
        );
        return;
      }

      // Write to a temp file for sharing.
      final tempDir = Directory.systemTemp;
      final file = File('${tempDir.path}/mission_milestone.png');
      await file.writeAsBytes(imageBytes);

      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'Check out my progress on Mission Invest!',
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Share failed: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _isSharing = false);
      }
    }
  }
}
