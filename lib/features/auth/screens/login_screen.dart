import 'package:flutter/material.dart';
import 'package:ipf_flutter_starter_pack/ipf_flutter_starter_pack.dart';
import '../../../core/model/user_session.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/theme/os_colors.dart';
import '../../../shared/widgets/shared_widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.onLogin});

  final ValueChanged<UserSession> onLogin;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _email = TextEditingController(
    text: 'agathamkenge16@gmail.com',
  );
  final TextEditingController _password = TextEditingController(
    text: 'Agatha123',
  );
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final email = _email.text.trim();
    final password = _password.text;

    if (email.isEmpty || password.isEmpty) {
      _showError('Please enter email and password');
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final user = await AuthService.instance.login(
        email: email,
        password: password,
      );

      if (mounted) {
        widget.onLogin(user);
      }
    } on Exception catch (e) {
      if (mounted) {
        setState(() => _error = e.toString().replaceAll('Exception: ', ''));
        _showError(_error ?? 'Login failed');
      }
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  void _showError(String message) {
    Scenery.showError(message);
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
                IgnorePointer(
                  ignoring: _loading,
                  child: Opacity(
                    opacity: _loading ? 0.6 : 1.0,
                    child: AppTextField(
                      label: 'Email Address',
                      hint: 'name@company.com',
                      icon: Icons.mail_outline_rounded,
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                IgnorePointer(
                  ignoring: _loading,
                  child: Opacity(
                    opacity: _loading ? 0.6 : 1.0,
                    child: AppTextField(
                      label: 'Password',
                      hint: 'password',
                      icon: Icons.lock_outline_rounded,
                      controller: _password,
                      obscureText: true,
                      trailingLabel: 'Forgot password?',
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                FilledActionButton(
                  label: _loading ? 'Authenticating...' : 'Sign In',
                  icon: _loading ? null : Icons.arrow_forward_rounded,
                  onPressed: _loading ? null : _submit,
                ),
                const SizedBox(height: 22),
                Text(
                  'Protected by Company API. For demo, use test credentials.',
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
