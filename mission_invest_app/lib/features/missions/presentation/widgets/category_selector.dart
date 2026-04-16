import 'package:flutter/material.dart';

class CategorySelector extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onSelected;

  const CategorySelector({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  static const _categories = {
    'trip': ('Trip / Vacation', Icons.flight),
    'gadget': ('Gadget', Icons.laptop),
    'vehicle': ('Vehicle', Icons.directions_car),
    'emergency': ('Emergency Fund', Icons.savings),
    'course': ('Course / Upskilling', Icons.school),
    'gift': ('Gift', Icons.card_giftcard),
    'custom': ('Custom', Icons.edit),
  };

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _categories.entries.map((entry) {
        final isSelected = selected == entry.key;
        return ChoiceChip(
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(entry.value.$2, size: 16),
              const SizedBox(width: 4),
              Text(entry.value.$1),
            ],
          ),
          selected: isSelected,
          onSelected: (_) => onSelected(entry.key),
        );
      }).toList(),
    );
  }
}
