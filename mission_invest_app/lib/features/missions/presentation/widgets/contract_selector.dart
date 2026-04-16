import 'package:flutter/material.dart';

import '../../data/models/contract_model.dart';

/// Widget that lets the user pick a commit contract for their mission.
///
/// Displays 3 contract cards (half-pledge, consistency pact, speed pact) plus
/// a "No contract" option. The selected card is highlighted.
class ContractSelector extends StatelessWidget {
  final ContractType selected;
  final ValueChanged<ContractType> onSelected;

  const ContractSelector({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  static const _contracts = [
    ContractType.halfPledge,
    ContractType.consistencyPact,
    ContractType.speedPact,
    ContractType.none,
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _contracts.map((type) {
        final isSelected = selected == type;
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: _ContractCard(
            type: type,
            isSelected: isSelected,
            onTap: () => onSelected(type),
          ),
        );
      }).toList(),
    );
  }
}

class _ContractCard extends StatelessWidget {
  final ContractType type;
  final bool isSelected;
  final VoidCallback onTap;

  const _ContractCard({
    required this.type,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? primaryColor : theme.dividerColor,
          width: isSelected ? 2.0 : 1.0,
        ),
        color: isSelected
            ? primaryColor.withAlpha(20)
            : theme.colorScheme.surface,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Contract type icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected
                      ? primaryColor.withAlpha(30)
                      : theme.colorScheme.surfaceContainerHighest,
                ),
                child: Icon(
                  _contractIcon(type),
                  size: 20,
                  color: isSelected
                      ? primaryColor
                      : theme.colorScheme.onSurface.withAlpha(153),
                ),
              ),
              const SizedBox(width: 12),
              // Text content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      MissionContract.name(type),
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.w600,
                        color: isSelected ? primaryColor : null,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      MissionContract.description(type),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withAlpha(153),
                      ),
                    ),
                    if (type != ContractType.none) ...[
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            Icons.refresh,
                            size: 14,
                            color: theme.colorScheme.onSurface.withAlpha(102),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              'Recovery: ${MissionContract.recoveryCondition(type)}',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color:
                                    theme.colorScheme.onSurface.withAlpha(102),
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              // Selection indicator
              if (isSelected)
                Icon(Icons.check_circle, color: primaryColor, size: 22),
            ],
          ),
        ),
      ),
    );
  }

  IconData _contractIcon(ContractType type) {
    return switch (type) {
      ContractType.halfPledge => Icons.shield_outlined,
      ContractType.consistencyPact => Icons.bolt_outlined,
      ContractType.speedPact => Icons.speed_outlined,
      ContractType.none => Icons.block_outlined,
    };
  }
}
