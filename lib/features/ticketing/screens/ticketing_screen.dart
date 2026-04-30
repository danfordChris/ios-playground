import 'package:flutter/material.dart';
import '../../../core/theme/os_colors.dart';
import '../../../core/utils/os_utils.dart';
import '../../../shared/data/mock_data.dart';
import '../../../shared/widgets/shared_widgets.dart';

class TicketingScreen extends StatelessWidget {
  const TicketingScreen({
    super.key,
    required this.activeIndex,
    required this.tickets,
    required this.onCreateTicket,
  });

  final int activeIndex;
  final List<Map<String, String>> tickets;
  final ValueChanged<Map<String, String>> onCreateTicket;

  @override
  Widget build(BuildContext context) {
    switch (activeIndex) {
      case 1:
        return _NewTicket(onSubmit: onCreateTicket);
      case 2:
        return _TicketKnowledgeBase();
      case 3:
        return _TicketSettings();
      default:
        return _TicketFeed(tickets: tickets);
    }
  }
}

class _TicketFeed extends StatelessWidget {
  const _TicketFeed({required this.tickets});

  final List<Map<String, String>> tickets;

  @override
  Widget build(BuildContext context) {
    return ScrollableSection(
      children: [
        const SectionHeader(
          title: 'Internal Support',
          subtitle: 'Track and manage organizational issues.',
        ),
        Row(
          children: [
            Expanded(
              child: MetricTile(
                label: 'Open',
                value: '${tickets.where((t) => t['status'] != 'Resolved').length}',
                color: OsColors.red,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: MetricTile(
                label: 'Resolved',
                value: '${tickets.where((t) => t['status'] == 'Resolved').length}',
                color: OsColors.green,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: MetricTile(
                label: 'SLA',
                value: '98%',
                color: OsColors.blue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        for (final ticket in tickets) ...[
          _TicketCard(ticket: ticket),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _NewTicket extends StatefulWidget {
  const _NewTicket({required this.onSubmit});

  final ValueChanged<Map<String, String>> onSubmit;

  @override
  State<_NewTicket> createState() => _NewTicketState();
}

class _NewTicketState extends State<_NewTicket> {
  final _title = TextEditingController();
  final _desc = TextEditingController();
  String _priority = 'Medium';
  String _category = 'IT';

  @override
  Widget build(BuildContext context) {
    return ScrollableSection(
      children: [
        const SectionHeader(
          title: 'Raise Ticket',
          subtitle: 'Report an issue to IT, HR or Facilities.',
        ),
        GlassCard(
          padding: const EdgeInsets.all(22),
          child: Column(
            children: [
              AppTextField(
                label: 'Issue Title',
                hint: 'Brief summary of the issue',
                icon: Icons.title_rounded,
                controller: _title,
              ),
              const SizedBox(height: 18),
              AppTextField(
                label: 'Description',
                hint: 'Detailed explanation...',
                icon: Icons.description_outlined,
                controller: _desc,
                maxLines: 4,
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: AppSelect(
                      label: 'Category',
                      value: _category,
                      options: const ['IT', 'HR', 'Facilities', 'Finance'],
                      onChanged: (v) => setState(() => _category = v),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: AppSelect(
                      label: 'Priority',
                      value: _priority,
                      options: const ['Low', 'Medium', 'High', 'Critical'],
                      onChanged: (v) => setState(() => _priority = v),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              FilledActionButton(
                label: 'Submit Ticket',
                icon: Icons.send_rounded,
                onPressed: () {
                  if (_title.text.isEmpty) return;
                  widget.onSubmit({
                    'id': 't-${DateTime.now().millisecondsSinceEpoch}',
                    'title': _title.text,
                    'description': _desc.text,
                    'priority': _priority,
                    'status': 'Open',
                    'category': _category,
                    'reporter': 'Erick M',
                    'assignee': '',
                  });
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('Ticket submitted!')));
                  _title.clear();
                  _desc.clear();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TicketKnowledgeBase extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScrollableSection(
      children: [
        const SectionHeader(
          title: 'Knowledge Base',
          subtitle: 'Self-service guides and documentation.',
        ),
        AppTextField(
          label: 'Search',
          hint: 'How do I...',
          icon: Icons.search_rounded,
          controller: TextEditingController(), // Just for UI
        ),
        const SizedBox(height: 22),
        for (final cat in ['IT Guides', 'HR Policies', 'Office Manuals']) ...[
          Text(cat, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          const StatusCard(
            icon: Icons.article_outlined,
            color: OsColors.blue,
            title: 'Common issues & solutions',
            subtitle: '12 articles • Updated 2d ago',
            trailing: Icon(Icons.chevron_right_rounded, color: OsColors.muted),
          ),
          const SizedBox(height: 16),
        ],
      ],
    );
  }
}

class _TicketSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScrollableSection(
      children: [
        const SectionHeader(
          title: 'Support Settings',
          subtitle: 'Manage your notification preferences.',
        ),
        const GlassCard(
          padding: EdgeInsets.all(18),
          child: Column(
            children: [
              InfoRow(
                label: 'Email Notifications',
                value: 'On ticket update',
                trailing: Icon(Icons.toggle_on_rounded, color: OsColors.blue, size: 24),
              ),
              Divider(color: OsColors.line, height: 24),
              InfoRow(
                label: 'Push Alerts',
                value: 'For High/Critical only',
                trailing: Icon(Icons.toggle_on_rounded, color: OsColors.blue, size: 24),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TicketCard extends StatelessWidget {
  const _TicketCard({required this.ticket});

  final Map<String, String> ticket;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              BadgeLabel(label: ticket['id']!, color: OsColors.slate),
              const Spacer(),
              BadgeLabel(
                label: ticket['status']!,
                color: OsUtils.getStatusColor(ticket['status']!),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(ticket['title']!, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 6),
          Text(
            ticket['description']!,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: OsColors.muted),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Icon(Icons.category_outlined, size: 14, color: OsColors.muted),
              const SizedBox(width: 6),
              Text(
                ticket['category']!,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(color: OsColors.muted),
              ),
              const Spacer(),
              BadgeLabel(
                label: ticket['priority']!,
                color: OsUtils.getPriorityColor(ticket['priority']!),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
