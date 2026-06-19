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

  List<LauncherApp> _apps() {
    return [
      LauncherApp(
        workspace: Workspace.meals,
        name: 'iPF Meals',
        description: 'Daily menu and dietary preferences',
        icon: Icons.restaurant_menu_rounded,
        color: OsColors.orange,
        assetPath: 'assets/launcher/meal_plan.svg',
        badgeLabel: 'COMING SOON',
        badgeIcon: Icons.lock_outline_rounded,
      ),
      LauncherApp(
        workspace: Workspace.projects,
        name: 'PMO',
        description: 'Portfolio, resources and PMO',
        icon: Icons.layers_rounded,
        color: OsColors.blue,
        assetPath: 'assets/launcher/asset_management.svg',
      ),
      LauncherApp(
        workspace: Workspace.tasks,
        name: 'My Tasks',
        description: 'Track your active assignments',
        icon: Icons.task_alt_rounded,
        color: OsColors.green,
        assetPath: 'assets/launcher/tasks.svg',
      ),
      LauncherApp(
        workspace: Workspace.users,
        name: 'My Workplace',
        // name: 'User Management',
        description: 'Directory, roles and security',
        icon: Icons.groups_rounded,
        color: OsColors.purple,
        assetPath: 'assets/launcher/leave_management.svg',
      ),
      LauncherApp(
        workspace: Workspace.ticketing,
        name: 'Ticketing',
        description: 'Internal support and issue tracking',
        icon: Icons.confirmation_number_rounded,
        color: OsColors.red,
        assetPath: 'assets/launcher/ticketing.svg',
        badgeLabel: 'COMING SOON',
        badgeIcon: Icons.lock_outline_rounded,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final apps = _apps();

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
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.1,
                  ),
                  itemCount: apps.length,
                  itemBuilder: (context, index) {
                    final app = apps[index];
                    return LauncherCard(
                      app: app,
                      onTap: () => onOpenWorkspace(app.workspace),
                    );
                  },
                ),
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
