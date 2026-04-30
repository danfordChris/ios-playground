import 'package:flutter/material.dart';
import '../../../core/theme/os_colors.dart';
import '../../../core/utils/os_utils.dart';
import '../../../shared/data/mock_data.dart';
import '../../../shared/widgets/shared_widgets.dart';

class ProjectsScreen extends StatelessWidget {
  const ProjectsScreen({super.key, required this.activeIndex});

  final int activeIndex;

  @override
  Widget build(BuildContext context) {
    switch (activeIndex) {
      case 1:
        return _ResourceAllocation();
      case 2:
        return _ProjectTargets();
      case 3:
        return _ClientDirectory();
      case 4:
        return _ProjectSettings();
      default:
        return _ProjectsHome();
    }
  }
}

class _ProjectsHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScrollableSection(
      children: [
        const SectionHeader(
          title: 'PMO Dashboard',
          subtitle: 'Active portfolio and health metrics.',
        ),
        Row(
          children: [
            Expanded(
              child: MetricTile(
                label: 'Active',
                value: '4',
                color: OsColors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: MetricTile(
                label: 'Revenue',
                value: r'$1.2M',
                color: OsColors.green,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: MetricTile(
                label: 'Utilization',
                value: '92%',
                color: OsColors.purple,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text('Portfolio', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        for (final project in MockData.projects) ...[
          _ProjectCard(project: project),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _ResourceAllocation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScrollableSection(
      children: [
        const SectionHeader(
          title: 'Resources',
          subtitle: 'Talent allocation and workload balancing.',
        ),
        for (final resource in MockData.resources) ...[
          StatusCard(
            icon: Icons.person_search_rounded,
            color: OsColors.blue,
            title: resource['name']!,
            subtitle: '${resource['role']} - ${resource['project']}',
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${(double.parse(resource['load']!) * 100).toInt()}%',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                const SizedBox(height: 4),
                SizedBox(
                  width: 48,
                  child: ProgressBar(
                    value: double.parse(resource['load']!),
                    color: double.parse(resource['load']!) > 0.8 ? OsColors.red : OsColors.blue,
                    height: 4,
                  ),
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

class _ProjectTargets extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScrollableSection(
      children: [
        const SectionHeader(
          title: 'Targets',
          subtitle: 'Quarterly KPIs and delivery progress.',
        ),
        for (final target in MockData.targets) ...[
          GlassCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        target['title']!,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    BadgeLabel(
                      label: target['status']!,
                      color: OsUtils.getTargetColor(target['status']!),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                ProgressBar(
                  value: double.parse(target['progress']!),
                  color: OsUtils.getTargetColor(target['status']!),
                ),
                const SizedBox(height: 10),
                Text(
                  target['value']!,
                  style: Theme.of(
                    context,
                  ).textTheme.labelSmall?.copyWith(color: OsColors.muted),
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

class _ClientDirectory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScrollableSection(
      children: [
        const SectionHeader(
          title: 'Clients',
          subtitle: 'Active accounts and industry partners.',
        ),
        for (final client in MockData.clients) ...[
          StatusCard(
            icon: Icons.domain_rounded,
            color: OsColors.slate,
            title: client['name']!,
            subtitle: '${client['industry']} - ${client['region']}',
            trailing: BadgeLabel(label: client['type']!, color: OsColors.blue),
          ),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _ProjectSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScrollableSection(
      children: [
        const SectionHeader(
          title: 'PMO Settings',
          subtitle: 'Methodology and framework controls.',
        ),
        const GlassCard(
          padding: EdgeInsets.all(18),
          child: Column(
            children: [
              InfoRow(
                label: 'Project Methodology',
                value: 'Agile/Scrum',
                trailing: Icon(Icons.settings_outlined, size: 18, color: OsColors.blue),
              ),
              Divider(color: OsColors.line, height: 24),
              InfoRow(
                label: 'Reporting Cycle',
                value: 'Weekly (Friday)',
                trailing: Icon(Icons.edit_calendar_outlined, size: 18, color: OsColors.blue),
              ),
              Divider(color: OsColors.line, height: 24),
              InfoRow(
                label: 'Resource Buffer',
                value: '15%',
                trailing: Icon(Icons.percent_rounded, size: 18, color: OsColors.blue),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProjectCard extends StatelessWidget {
  const _ProjectCard({required this.project});

  final Map<String, String> project;

  @override
  Widget build(BuildContext context) {
    final progress = double.parse(project['progress']!);
    return GlassCard(
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(project['name']!, style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 4),
                    Text(
                      project['client']!,
                      style: Theme.of(
                        context,
                      ).textTheme.labelSmall?.copyWith(color: OsColors.blue),
                    ),
                  ],
                ),
              ),
              BadgeLabel(
                label: project['status']!,
                color: OsUtils.getStatusColor(project['status']!),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            project['description']!,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.4),
          ),
          const SizedBox(height: 22),
          Row(
            children: [
              Text(
                '${(progress * 100).toInt()}% complete',
                style: Theme.of(
                  context,
                ).textTheme.labelMedium?.copyWith(color: OsColors.muted),
              ),
              const Spacer(),
              Text(
                project['timeline']!,
                style: Theme.of(
                  context,
                ).textTheme.labelSmall?.copyWith(color: OsColors.muted),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ProgressBar(value: progress, color: OsColors.blue),
          const SizedBox(height: 22),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _ProjectStat(label: 'Milestones', value: project['milestones']!),
              _ProjectStat(label: 'Tasks', value: project['tasks']!),
              _ProjectStat(label: 'Documents', value: project['documents']!),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProjectStat extends StatelessWidget {
  const _ProjectStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 2),
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.labelSmall?.copyWith(color: OsColors.muted, fontSize: 10),
        ),
      ],
    );
  }
}
