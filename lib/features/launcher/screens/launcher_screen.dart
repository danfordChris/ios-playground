import 'package:flutter/material.dart';
import '../../../core/enum/workspace.dart';
import '../../../core/model/user_session.dart';
import '../../../core/theme/os_colors.dart';
import '../../../shared/widgets/shared_widgets.dart';
import '../models/launcher_app.dart';
import '../widgets/launcher_card.dart';

class LauncherScreen extends StatelessWidget {
  const LauncherScreen({
    super.key,
    required this.user,
    required this.onLogout,
    required this.onOpenWorkspace,
  });

  final UserSession user;
  final VoidCallback onLogout;
  final ValueChanged<Workspace> onOpenWorkspace;

  @override
  Widget build(BuildContext context) {
    final apps = <LauncherApp>[
      LauncherApp(
        workspace: Workspace.meals,
        name: 'iPF Meals',
        description: 'Daily menu and dietary preferences',
        icon: Icons.local_cafe_outlined,
        color: OsColors.orange,
      ),
      LauncherApp(
        workspace: Workspace.projects,
        name: 'PMO',
        description: 'Portfolio, resources and PMO',
        icon: Icons.business_center_outlined,
        color: OsColors.blue,
      ),
      LauncherApp(
        workspace: Workspace.tasks,
        name: 'My Tasks',
        description: 'Track your active assignments',
        icon: Icons.check_box_outlined,
        color: OsColors.green,
      ),
      LauncherApp(
        workspace: Workspace.users,
        name: 'User Management',
        description: 'Directory, roles and security',
        icon: Icons.groups_2_outlined,
        color: OsColors.purple,
      ),
      LauncherApp(
        workspace: Workspace.ticketing,
        name: 'Ticketing',
        description: 'Internal support and issue tracking',
        icon: Icons.confirmation_number_outlined,
        color: OsColors.red,
      ),
    ];

    return MeshScaffold(
      child: SafeArea(
        child: Stack(
          children: [
            ListView(
              padding: const EdgeInsets.fromLTRB(22, 18, 22, 118),
              children: [
                Row(
                  children: [
                    const BrandMark(),
                    const SizedBox(width: 12),
                    Text(
                      'IpfOS',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          _clockLabel(),
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Text(
                          'Wednesday, April 29',
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: OsColors.muted,
                                letterSpacing: 0.6,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 46),
                Text(
                  'Welcome back, ${user.name.split(' ').first}!',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                const SizedBox(height: 10),
                Text(
                  'Select a workspace to begin your workflow.',
                  textAlign: TextAlign.center,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: OsColors.muted),
                ),
                const SizedBox(height: 32),
                for (final app in apps) ...[
                  LauncherCard(
                    app: app,
                    onTap: () => onOpenWorkspace(app.workspace),
                  ),
                  const SizedBox(height: 16),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _clockLabel() {
    final now = DateTime.now();
    final hour = now.hour.toString().padLeft(2, '0');
    final minute = now.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
