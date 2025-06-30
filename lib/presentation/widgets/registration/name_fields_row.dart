import 'package:flutter/material.dart';
import 'form_text_field.dart';

class NameFieldsRow extends StatelessWidget {
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;

  const NameFieldsRow({
    super.key,
    required this.firstNameController,
    required this.lastNameController,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: FormTextField(
            controller: firstNameController,
            labelText: 'First Name',
            prefixIcon: Icons.person_outline,
            textInputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.words,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Required';
              }
              if (value.trim().length < 2) {
                return 'Too short';
              }
              return null;
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: FormTextField(
            controller: lastNameController,
            labelText: 'Last Name',
            prefixIcon: Icons.person_outline,
            textInputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.words,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Required';
              }
              if (value.trim().length < 2) {
                return 'Too short';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
}