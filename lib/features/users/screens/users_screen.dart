import 'package:flutter/material.dart';
import '../../../core/theme/os_colors.dart';
import '../../../core/utils/os_utils.dart';
import '../../../shared/data/mock_data.dart';
import '../../../shared/widgets/shared_widgets.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key, required this.activeIndex});

  final int activeIndex;

  @override
  Widget build(BuildContext context) {
    switch (activeIndex) {
      case 1:
        return _RolesManagement();
      case 2:
        return _SecuritySettings();
      case 3:
        return _AuditLogs();
      default:
        return _UserDirectory();
    }
  }
}

class _UserDirectory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScrollableSection(
      children: [
        const SectionHeader(
          title: 'User Directory',
          subtitle: 'Active employees and organizational structure.',
        ),
        Row(
          children: [
            Expanded(
              child: MetricTile(
                label: 'Total Users',
                value: '42',
                color: OsColors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: MetricTile(
                label: 'Active Now',
                value: '18',
                color: OsColors.green,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        for (final user in MockData.users) ...[
          StatusCard(
            icon: Icons.person_outline_rounded,
            color: OsUtils.getStatusColor(user['status']!),
            title: '${user['firstName']} ${user['lastName']}',
            subtitle: '${user['jobTitle']} • ${user['department']}',
            trailing: BadgeLabel(
              label: user['status']!,
              color: OsUtils.getStatusColor(user['status']!),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _RolesManagement extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScrollableSection(
      children: [
        const SectionHeader(
          title: 'Roles & Permissions',
          subtitle: 'Access control and functional authorization.',
        ),
        for (final role in MockData.roles) ...[
          GlassCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        role['name']!,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    BadgeLabel(label: role['type']!, color: OsColors.blue),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  role['description']!,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: OsColors.muted),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children:
                      role['permissions']!.split(',').map((permission) {
                        return BadgeLabel(
                          label: permission.trim(),
                          color: OsColors.slate,
                        );
                      }).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _SecuritySettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScrollableSection(
      children: [
        const SectionHeader(
          title: 'Security',
          subtitle: 'System-wide protection and auth policies.',
        ),
        const GlassCard(
          padding: EdgeInsets.all(18),
          child: Column(
            children: [
              InfoRow(
                label: 'SSO Provider',
                value: 'Okta Enterprise',
                trailing: Icon(Icons.verified_user_rounded, color: OsColors.green, size: 20),
              ),
              Divider(color: OsColors.line, height: 24),
              InfoRow(
                label: 'MFA Policy',
                value: 'Mandatory for all',
                trailing: Icon(Icons.shield_outlined, color: OsColors.blue, size: 20),
              ),
              Divider(color: OsColors.line, height: 24),
              InfoRow(
                label: 'Session Timeout',
                value: '4 Hours',
                trailing: Icon(Icons.timer_outlined, color: OsColors.muted, size: 20),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AuditLogs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScrollableSection(
      children: [
        const SectionHeader(
          title: 'Audit Logs',
          subtitle: 'Immutable record of critical system actions.',
        ),
        for (final log in MockData.auditLogs) ...[
          StatusCard(
            icon: Icons.history_edu_rounded,
            color: OsColors.slate,
            title: log['action']!,
            subtitle: '${log['details']} • ${log['module']}',
            trailing: Text(
              log['time']!,
              style: Theme.of(
                context,
              ).textTheme.labelSmall?.copyWith(color: OsColors.muted),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}
