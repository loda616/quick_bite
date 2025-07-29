import 'package:flutter/material.dart';
import '../../../l10n/generated/app_localizations.dart';
import 'form_text_field.dart';

class NameFieldsRow extends StatelessWidget {
  final AppLocalizations l10n;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;

  const NameFieldsRow({
    super.key,
    required this.l10n,
    required this.firstNameController,
    required this.lastNameController,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: FormTextField(
            l10n: l10n,
            controller: firstNameController,
            labelText: l10n.firstName,
            prefixIcon: Icons.person_outline,
            textInputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.words,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return l10n.required;
              }
              if (value.trim().length < 2) {
                return l10n.tooShort;
              }
              return null;
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: FormTextField(
            l10n: l10n,
            controller: lastNameController,
            labelText: l10n.lastName,
            prefixIcon: Icons.person_outline,
            textInputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.words,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return l10n.required;
              }
              if (value.trim().length < 2) {
                return l10n.tooShort;
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
}
