import 'package:flutter/material.dart';
import '../../core/enum/workspace.dart';
import '../../core/model/user_session.dart';
import '../../core/theme/os_colors.dart';
import '../../features/meals/screens/meals_screen.dart';
import '../../features/projects/screens/projects_screen.dart';
import '../../features/tasks/screens/tasks_screen.dart';
import '../../features/ticketing/screens/ticketing_screen.dart';
import '../../features/users/screens/users_screen.dart';
import 'shared_widgets.dart';

class ModuleShell extends StatelessWidget {
  const ModuleShell({
    super.key,
    required this.user,
    required this.workspace,
    required this.activeIndex,
    required this.tickets,
    required this.currentUserName,
    required this.currentRole,
    required this.onBackToLauncher,
    required this.onLogout,
    required this.onTabChanged,
    required this.onCreateTicket,
    required this.onUpdateTicket,
  });

  final UserSession user;
  final Workspace workspace;
  final int activeIndex;
  final List<Map<String, String>> tickets;
  final String currentUserName;
  final String currentRole;
  final VoidCallback onBackToLauncher;
  final VoidCallback onLogout;
  final ValueChanged<int> onTabChanged;
  final ValueChanged<Map<String, String>> onCreateTicket;
  final ValueChanged<Map<String, String>> onUpdateTicket;

  @override
  Widget build(BuildContext context) {
    final tabs = _tabsFor(workspace);
    return MeshScaffold(
      child: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 14, 18, 8),
                  child: Row(
                    children: [
                      IconButton.filledTonal(
                        onPressed: onBackToLauncher,
                        icon: const Icon(Icons.grid_view_rounded),
                        tooltip: 'Launcher',
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _titleFor(workspace),
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      ),
                      Avatar(name: user.name, color: OsColors.blue, size: 38),
                    ],
                  ),
                ),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: ScaleTransition(
                          scale: Tween<double>(begin: 0.95, end: 1.0).animate(
                            CurvedAnimation(
                              parent: animation,
                              curve: Curves.easeOut,
                            ),
                          ),
                          child: child,
                        ),
                      );
                    },
                    child: Padding(
                      key: ValueKey(
                        '${workspace.name}-$activeIndex-${tickets.length}',
                      ),
                      padding: const EdgeInsets.fromLTRB(18, 10, 18, 110),
                      child: _contentFor(workspace, activeIndex),
                    ),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Dock(
                  items: tabs,
                  activeIndex: activeIndex,
                  onTap: onTabChanged,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _contentFor(Workspace workspace, int index) {
    switch (workspace) {
      case Workspace.meals:
        return MealsScreen(activeIndex: index);
      case Workspace.projects:
        return ProjectsScreen(activeIndex: index);
      case Workspace.tasks:
        return TasksScreen(activeIndex: index);
      case Workspace.users:
        return UsersScreen(activeIndex: index);
      case Workspace.ticketing:
        return TicketingScreen(
          activeIndex: index,
          tickets: tickets,
          currentUserName: currentUserName,
          currentRole: currentRole,
          onCreateTicket: onCreateTicket,
          onUpdateTicket: onUpdateTicket,
        );
      case Workspace.launcher:
        return const SizedBox.shrink();
    }
  }

  List<DockItem> _tabsFor(Workspace workspace) {
    switch (workspace) {
      case Workspace.meals:
        return const [
          DockItem('Home', Icons.home_outlined),
          DockItem('Selections', Icons.restaurant_menu_outlined),
          DockItem('Plan', Icons.history_rounded),
          DockItem('Library', Icons.menu_book_outlined),
          DockItem('Team', Icons.groups_outlined),
          DockItem('Settings', Icons.settings_outlined),
        ];
      case Workspace.projects:
        return const [
          DockItem('Dashboard', Icons.analytics_outlined),
          DockItem('Resources', Icons.people_outline_rounded),
          DockItem('Targets', Icons.track_changes_rounded),
          DockItem('Clients', Icons.domain_rounded),
          DockItem('Admin', Icons.settings_outlined),
        ];
      case Workspace.tasks:
        return const [
          DockItem('Kanban', Icons.grid_view_rounded),
          DockItem('Activity', Icons.notifications_none_rounded),
          DockItem('Archive', Icons.inventory_2_outlined),
          DockItem('Filters', Icons.tune_rounded),
        ];
      case Workspace.users:
        return const [
          DockItem('Directory', Icons.badge_outlined),
          DockItem('Roles', Icons.admin_panel_settings_outlined),
          DockItem('Security', Icons.lock_outline_rounded),
          DockItem('Audit', Icons.history_rounded),
        ];
      case Workspace.ticketing:
        return const [
          DockItem('All', Icons.confirmation_number_outlined),
          DockItem('Open', Icons.error_outline_rounded),
          DockItem('Resolved', Icons.check_circle_outline_rounded),
          DockItem('New', Icons.add_circle_outline_rounded),
        ];
      default:
        return [];
    }
  }

  String _titleFor(Workspace workspace) {
    switch (workspace) {
      case Workspace.meals:
        return 'iPF Meals';
      case Workspace.projects:
        return 'Project Hub';
      case Workspace.tasks:
        return 'My Tasks';
      case Workspace.users:
        return 'System Users';
      case Workspace.ticketing:
        return 'Ticketing';
      default:
        return 'Workspace';
    }
  }
}
