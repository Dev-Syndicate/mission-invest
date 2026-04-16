import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../shared/widgets/app_loading.dart';
import '../../../../shared/widgets/app_error_widget.dart';
import '../../../missions/data/repositories/mission_repository.dart';
import '../widgets/certificate_widget.dart';

class CertificatePage extends ConsumerStatefulWidget {
  final String missionId;

  const CertificatePage({super.key, required this.missionId});

  @override
  ConsumerState<CertificatePage> createState() => _CertificatePageState();
}

class _CertificatePageState extends ConsumerState<CertificatePage> {
  final _screenshotController = ScreenshotController();
  bool _isSharing = false;

  @override
  Widget build(BuildContext context) {
    final missionAsync = ref.watch(watchMissionProvider(widget.missionId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Certificate'),
        actions: [
          IconButton(
            icon: _isSharing
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.share),
            onPressed: _isSharing ? null : () => _shareCertificate(context),
          ),
        ],
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

          final completionDate = mission.completedAt ?? DateTime.now();
          final daysTaken =
              completionDate.difference(mission.startDate).inDays;

          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Screenshot(
                controller: _screenshotController,
                child: CertificateWidget(
                  missionTitle: mission.title,
                  amountSaved: mission.savedAmount,
                  daysTaken: daysTaken < 0 ? 0 : daysTaken,
                  completedAt: completionDate,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _shareCertificate(BuildContext context) async {
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

      final tempDir = Directory.systemTemp;
      final file = File('${tempDir.path}/mission_certificate.png');
      await file.writeAsBytes(imageBytes);

      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'I completed my mission on Mission Invest!',
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
