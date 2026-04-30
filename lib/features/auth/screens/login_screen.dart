import 'package:flutter/material.dart';
import '../../../core/theme/os_colors.dart';
import '../../../shared/widgets/shared_widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.onLogin});

  final VoidCallback onLogin;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _email = TextEditingController(
    text: 'erick@ipfsoftwares.com',
  );
  final TextEditingController _password = TextEditingController(
    text: 'password',
  );
  bool _loading = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_email.text.trim().isEmpty || _password.text.isEmpty) return;
    setState(() => _loading = true);
    await Future<void>.delayed(const Duration(milliseconds: 550));
    if (mounted) widget.onLogin();
  }

  @override
  Widget build(BuildContext context) {
    return MeshScaffold(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: GlassCard(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const GradientIcon(icon: Icons.lock_outline_rounded, size: 68),
                const SizedBox(height: 22),
                Text(
                  'IpfOS',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'Sign in to access your workspaces',
                  textAlign: TextAlign.center,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: OsColors.muted),
                ),
                const SizedBox(height: 28),
                AppTextField(
                  label: 'Email Address',
                  hint: 'name@company.com',
                  icon: Icons.mail_outline_rounded,
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 18),
                AppTextField(
                  label: 'Password',
                  hint: 'password',
                  icon: Icons.lock_outline_rounded,
                  controller: _password,
                  obscureText: true,
                  trailingLabel: 'Forgot password?',
                ),
                const SizedBox(height: 24),
                FilledActionButton(
                  label: _loading ? 'Authenticating...' : 'Sign In',
                  icon: _loading ? null : Icons.arrow_forward_rounded,
                  onPressed: _loading ? null : _submit,
                ),
                const SizedBox(height: 22),
                Text(
                  'Protected by Company SSO. Need help? Contact IT Support.',
                  textAlign: TextAlign.center,
                  style: Theme.of(
                    context,
                  ).textTheme.labelSmall?.copyWith(color: OsColors.muted),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
