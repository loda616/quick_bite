import 'package:flutter/material.dart';

import '../../../l10n/generated/app_localizations.dart';

class PasswordField extends StatelessWidget {
  final AppLocalizations l10n;
  final TextEditingController controller;
  final String labelText;
  final bool isVisible;
  final VoidCallback onVisibilityToggle;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final void Function(String)? onFieldSubmitted;

  const PasswordField({
    super.key,
    required this.l10n,
    required this.controller,
    required this.labelText,
    required this.isVisible,
    required this.onVisibilityToggle,
    this.textInputAction,
    this.validator,
    this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: const Icon(Icons.lock_outlined),
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: Icon(
            isVisible
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
          ),
          onPressed: onVisibilityToggle,
        ),
      ),
      obscureText: !isVisible,
      textInputAction: textInputAction,
      validator: validator,
      onFieldSubmitted: onFieldSubmitted,
    );
  }
}
