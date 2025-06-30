import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

class TermsCheckbox extends StatelessWidget {
  final bool accepted;
  final VoidCallback onToggle;

  const TermsCheckbox({
    super.key,
    required this.accepted,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
          value: accepted,
          onChanged: (value) => onToggle(),
          activeColor: AppTheme.primaryColor,
        ),
        Expanded(
          child: GestureDetector(
            onTap: onToggle,
            child: Padding(
              padding: const EdgeInsets.only(top: 12),
              child: RichText(
                text: const TextSpan(
                  text: 'I agree to the ',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 14,
                  ),
                  children: [
                    TextSpan(
                      text: 'Terms & Conditions',
                      style: TextStyle(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    TextSpan(text: ' and '),
                    TextSpan(
                      text: 'Privacy Policy',
                      style: TextStyle(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}