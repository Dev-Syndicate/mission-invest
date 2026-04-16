import 'package:flutter/material.dart';

class AmountInputField extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const AmountInputField({
    super.key,
    required this.controller,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: TextInputType.number,
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        prefixText: '\u20B9 ',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 24,
        ),
      ),
    );
  }
}
