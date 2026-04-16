import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/models/contract_model.dart';

/// A small badge/icon for mission cards that shows the contract status.
///
/// - Green glow: contract active
/// - Amber glow: in recovery
/// - Grey: expired/breached
/// - Hidden when no contract
class ContractStatusBadge extends StatelessWidget {
  final ContractType contractType;
  final ContractStatus contractStatus;
  final double size;

  const ContractStatusBadge({
    super.key,
    required this.contractType,
    required this.contractStatus,
    this.size = 28,
  });

  @override
  Widget build(BuildContext context) {
    if (contractType == ContractType.none ||
        contractStatus == ContractStatus.none) {
      return const SizedBox.shrink();
    }

    final color = _statusColor(contractStatus);
    final icon = _contractIcon(contractType);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withAlpha(30),
        border: Border.all(color: color.withAlpha(127), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: color.withAlpha(76),
            blurRadius: 6,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Icon(
        icon,
        size: size * 0.55,
        color: color,
      ),
    );
  }

  Color _statusColor(ContractStatus status) {
    return switch (status) {
      ContractStatus.active => AppColors.success,
      ContractStatus.inRecovery => AppColors.warning,
      ContractStatus.fulfilled => AppColors.badgeGold,
      ContractStatus.breached => Colors.grey,
      ContractStatus.none => Colors.grey,
    };
  }

  IconData _contractIcon(ContractType type) {
    return switch (type) {
      ContractType.halfPledge => Icons.shield,
      ContractType.consistencyPact => Icons.bolt,
      ContractType.speedPact => Icons.speed,
      ContractType.none => Icons.block,
    };
  }
}
