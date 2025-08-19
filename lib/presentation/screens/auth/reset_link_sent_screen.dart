import 'package:flutter/material.dart';
import '../../../l10n/generated/app_localizations.dart';
import 'login_screen.dart';

class ResetLinkSentScreen extends StatelessWidget {
  const ResetLinkSentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                const Image(
                  image: AssetImage('assets/images/QuickBite-logo.png'),
                ),
                const SizedBox(height: 40),

                // Success Icon
                Icon(
                  Icons.check_circle_outline,
                  size: 80,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                const SizedBox(height: 24),

                // Title
                Text(
                  l10n.resetLinkSent,
                  style: textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                const SizedBox(height: 12),

                // Description
                Text(
                  l10n.resetLinkSentDesc,
                  textAlign: TextAlign.center,
                  style: textTheme.bodyMedium?.copyWith(
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 40),

                // Back to Login Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                            (route) => false,
                      );
                    },
                    child: Text(
                      l10n.backToLogin,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}