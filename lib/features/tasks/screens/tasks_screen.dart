import 'package:flutter/material.dart';
import '../../../core/theme/os_colors.dart';
import '../../../core/utils/os_utils.dart';
import '../../../shared/data/mock_data.dart';
import '../../../shared/widgets/shared_widgets.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key, required this.activeIndex});

  final int activeIndex;

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  String? _selectedTaskId = MockData.tasks.first['id'];

  @override
  Widget build(BuildContext context) {
    if (widget.activeIndex == 1) {
      return ScrollableSection(
        children: [
          const SectionHeader(
            title: 'Notifications',
            subtitle: 'Mentions, deadline alerts and review requests.',
          ),
          for (final note in MockData.notifications) ...[
            StatusCard(
              icon: note['type'] == 'Deadline'
                  ? Icons.alarm_rounded
                  : Icons.mark_chat_unread_outlined,
              color: note['isRead'] == 'false' ? OsColors.blue : OsColors.slate,
              title: note['message']!,
              subtitle: '${note['type']} - ${note['time']}',
              trailing: note['isRead'] == 'false'
                  ? const BadgeLabel(label: 'New', color: OsColors.blue)
                  : null,
            ),
            const SizedBox(height: 12),
          ],
        ],
      );
    }

    final selected = MockData.tasks.firstWhere(
      (task) => task['id'] == _selectedTaskId,
      orElse: () => MockData.tasks.first,
    );
    final done = MockData.tasks
        .where((task) => task['status'] == 'Completed')
        .length;
    final overdue = MockData.tasks
        .where((task) => task['overdue'] == 'true')
        .length;

    return ScrollableSection(
      children: [
        const SectionHeader(
          title: 'Task command center',
          subtitle: 'Unified PMS and ticketing workload.',
        ),
        Row(
          children: [
            Expanded(
              child: MetricTile(
                label: 'Active',
                value: '${MockData.tasks.length - done}',
                color: OsColors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: MetricTile(
                label: 'Done',
                value: '$done',
                color: OsColors.green,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: MetricTile(
                label: 'Overdue',
                value: '$overdue',
                color: OsColors.red,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        GlassCard(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Capacity', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              ProgressBar(value: 0.72, color: OsColors.green),
              const SizedBox(height: 8),
              Text(
                '17 of 24 planned points committed this week.',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: OsColors.muted),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text('Kanban', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        for (final status in [
          'Pending',
          'In-Progress',
          'Review',
          'Blocked',
          'Completed',
        ]) ...[
          _KanbanList(
            status: status,
            selectedId: _selectedTaskId,
            onSelect: (id) => setState(() => _selectedTaskId = id),
          ),
          const SizedBox(height: 12),
        ],
        const SizedBox(height: 16),
        Text('Active details', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        GlassCard(
          padding: const EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      selected['title']!,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  BadgeLabel(
                    label: selected['status']!,
                    color: OsUtils.getStatusColor(selected['status']!),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Text(
                selected['description']!,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(height: 1.5),
              ),
              const SizedBox(height: 22),
              InfoRow(label: 'Project context', value: selected['context']!),
              InfoRow(
                label: 'Priority',
                value: selected['priority']!,
                trailing: BadgeLabel(
                  label: 'Points: ${selected['points']}',
                  color: OsColors.blue,
                ),
              ),
              InfoRow(
                label: 'Assignee',
                value: selected['assignee']!,
                trailing: Avatar(
                  name: selected['assignee']!,
                  color: OsColors.blue,
                  size: 28,
                ),
              ),
              InfoRow(
                label: 'Deadline',
                value: selected['due']!,
                trailing:
                    selected['overdue'] == 'true'
                        ? const Icon(
                          Icons.warning_amber_rounded,
                          color: OsColors.red,
                          size: 20,
                        )
                        : null,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _KanbanList extends StatelessWidget {
  const _KanbanList({
    required this.status,
    required this.selectedId,
    required this.onSelect,
  });

  final String status;
  final String? selectedId;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    final tasks = MockData.tasks.where((t) => t['status'] == status).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Row(
            children: [
              Text(status, style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(width: 8),
              BadgeLabel(label: '${tasks.length}', color: OsUtils.getStatusColor(status)),
            ],
          ),
        ),
        if (tasks.isEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 12),
            child: Text(
              'No tasks in this stage.',
              style: Theme.of(
                context,
              ).textTheme.labelSmall?.copyWith(color: OsColors.muted),
            ),
          )
        else
          for (final task in tasks) ...[
            _KanbanCard(
              task: task,
              isActive: task['id'] == selectedId,
              onTap: () => onSelect(task['id']!),
            ),
            const SizedBox(height: 8),
          ],
      ],
    );
  }
}

class _KanbanCard extends StatelessWidget {
  const _KanbanCard({
    required this.task,
    required this.isActive,
    required this.onTap,
  });

  final Map<String, String> task;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.white.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isActive ? OsColors.blue : Colors.transparent,
            width: 1.5,
          ),
          boxShadow:
              isActive
                  ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ]
                  : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    task['title']!,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                if (task['overdue'] == 'true')
                  const Icon(Icons.alarm_rounded, color: OsColors.red, size: 16),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(
                  task['source'] == 'PMS'
                      ? Icons.business_center_outlined
                      : Icons.confirmation_number_outlined,
                  size: 14,
                  color: OsColors.muted,
                ),
                const SizedBox(width: 6),
                Text(
                  task['source']!,
                  style: Theme.of(
                    context,
                  ).textTheme.labelSmall?.copyWith(color: OsColors.muted),
                ),
                const Spacer(),
                BadgeLabel(
                  label: task['priority']!,
                  color: OsUtils.getPriorityColor(task['priority']!),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
