import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../core/theme/os_colors.dart';
import '../../../core/utils/os_utils.dart';
import '../../../shared/data/mock_data.dart';
import '../../../shared/widgets/shared_widgets.dart';

class TicketingScreen extends StatefulWidget {
  const TicketingScreen({
    super.key,
    required this.activeIndex,
    required this.tickets,
    required this.currentUserName,
    required this.currentRole,
    required this.onCreateTicket,
    required this.onUpdateTicket,
  });

  final int activeIndex;
  final List<Map<String, String>> tickets;
  final String currentUserName;
  final String currentRole;
  final ValueChanged<Map<String, String>> onCreateTicket;
  final ValueChanged<Map<String, String>> onUpdateTicket;

  @override
  State<TicketingScreen> createState() => _TicketingScreenState();
}

class _TicketingScreenState extends State<TicketingScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String _priority = 'Medium';
  String _category = 'Bug';
  String _department = 'Operations';
  String _priorityFilter = 'All';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.activeIndex == 3) {
      return _TicketComposer(
        titleController: _titleController,
        descriptionController: _descriptionController,
        priority: _priority,
        category: _category,
        department: _department,
        onPriorityChanged: (value) => setState(() => _priority = value),
        onCategoryChanged: (value) => setState(() => _category = value),
        onDepartmentChanged: (value) => setState(() => _department = value),
        onSubmit: _createTicket,
      );
    }

    return _TicketListView(
      title: _listTitleFor(widget.activeIndex),
      subtitle: _listSubtitleFor(widget.activeIndex),
      summaryTickets: _visibleTickets(),
      tickets: _filteredTickets(),
      searchController: _searchController,
      priorityFilter: _priorityFilter,
      onPriorityFilterChanged: (value) {
        setState(() => _priorityFilter = value);
      },
      emptyLabel: _emptyLabelFor(widget.activeIndex),
      currentUserName: widget.currentUserName,
      currentRole: widget.currentRole,
      onTicketTap: _openTicketDetails,
    );
  }

  void _onSearchChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  bool get _canSeeAllTickets => _isPrivilegedRole(widget.currentRole);

  bool _isPrivilegedRole(String role) {
    final normalized = role.toLowerCase();
    return normalized.contains('admin') ||
        normalized.contains('manager') ||
        normalized.contains('hr');
  }

  bool _matchesCurrentUser(Map<String, String> ticket) {
    final reporter = ticket['reporterName'] ?? ticket['reporter'] ?? '';
    final assignee = ticket['assigneeName'] ?? ticket['assignee'] ?? '';
    return reporter == widget.currentUserName ||
        assignee == widget.currentUserName;
  }

  List<Map<String, String>> _visibleTickets() {
    if (_canSeeAllTickets) {
      return widget.tickets;
    }

    return widget.tickets.where(_matchesCurrentUser).toList();
  }

  List<Map<String, String>> _tabTickets() {
    return _visibleTickets().where((ticket) {
      final status = ticket['status'] ?? '';
      return switch (widget.activeIndex) {
        0 => true,
        1 => status == 'Open' || status == 'In Progress',
        2 => status == 'Resolved' || status == 'Closed',
        _ => true,
      };
    }).toList();
  }

  List<Map<String, String>> _filteredTickets() {
    final query = _searchController.text.trim().toLowerCase();
    final priorityFilter = _priorityFilter;

    return _tabTickets().where((ticket) {
      final matchesQuery = query.isEmpty
          ? true
          : [
              ticket['id'],
              ticket['title'],
              ticket['description'],
              ticket['category'],
              ticket['department'],
              ticket['reporterName'] ?? ticket['reporter'],
              ticket['assigneeName'] ?? ticket['assignee'],
              ticket['relatedItem'],
            ].whereType<String>().join(' ').toLowerCase().contains(query);

      final matchesPriority =
          priorityFilter == 'All' || ticket['priority'] == priorityFilter;

      return matchesQuery && matchesPriority;
    }).toList();
  }

  String _listTitleFor(int index) {
    return switch (index) {
      0 => 'All Tickets',
      1 => 'Open Issues',
      2 => 'Resolved Tickets',
      _ => 'Ticketing',
    };
  }

  String _listSubtitleFor(int index) {
    return switch (index) {
      0 => 'Track, filter and open support requests in one place.',
      1 => 'Items that still need triage or active work.',
      2 => 'Requests that are completed, accepted or closed.',
      _ => 'Track, filter and open support requests in one place.',
    };
  }

  String _emptyLabelFor(int index) {
    return switch (index) {
      0 => 'No tickets found in the current view.',
      1 => 'No open issues found.',
      2 => 'No resolved tickets found.',
      _ => 'No tickets found.',
    };
  }

  Future<void> _createTicket() async {
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();
    if (title.isEmpty || description.isEmpty) {
      return;
    }

    final now = DateTime.now().toUtc();
    final iso = now.toIso8601String();
    final slaTarget = _slaTargetForPriority(_priority);
    final createdActivity = [
      {
        'id': 'a-${now.microsecondsSinceEpoch}',
        'timestamp': _formatActivityTime(iso),
        'user': widget.currentUserName,
        'action': 'Created ticket',
        'details': 'Ticket filed from the mobile app.',
      },
    ];

    widget.onCreateTicket({
      'id': 't-${DateTime.now().millisecondsSinceEpoch}',
      'title': title,
      'description': description,
      'priority': _priority,
      'status': 'Open',
      'category': _category,
      'department': _department,
      'visibility': _department == 'HR' || _category == 'HR Issue'
          ? 'Restricted HR Ticket'
          : 'Standard',
      'slaStatus': 'On Track',
      'slaTarget': slaTarget,
      'slaDue': _formatDueDate(now, _priority),
      'reporter': widget.currentUserName,
      'reporterId': 'u-mobile',
      'reporterName': widget.currentUserName,
      'assigneeId': '',
      'assigneeName': 'Unassigned',
      'createdAt': iso,
      'updatedAt': iso,
      'commentsJson': jsonEncode(const []),
      'activitiesJson': jsonEncode(createdActivity),
    });

    _titleController.clear();
    _descriptionController.clear();
    _priority = 'Medium';
    _category = 'Bug';
    _department = 'Operations';
    setState(() {});

    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Ticket created.')));
    }
  }

  Future<void> _openTicketDetails(Map<String, String> ticket) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (_) {
        return _TicketDetailsSheet(
          ticket: ticket,
          currentUserName: widget.currentUserName,
          currentRole: widget.currentRole,
          onSave: widget.onUpdateTicket,
        );
      },
    );
  }
}

class _TicketListView extends StatelessWidget {
  const _TicketListView({
    required this.title,
    required this.subtitle,
    required this.summaryTickets,
    required this.tickets,
    required this.searchController,
    required this.priorityFilter,
    required this.onPriorityFilterChanged,
    required this.emptyLabel,
    required this.currentUserName,
    required this.currentRole,
    required this.onTicketTap,
  });

  final String title;
  final String subtitle;
  final List<Map<String, String>> summaryTickets;
  final List<Map<String, String>> tickets;
  final TextEditingController searchController;
  final String priorityFilter;
  final ValueChanged<String> onPriorityFilterChanged;
  final String emptyLabel;
  final String currentUserName;
  final String currentRole;
  final ValueChanged<Map<String, String>> onTicketTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final isWide = width >= 720;
        final maxContentWidth = isWide ? 980.0 : width;
        final cardWidth = isWide ? (maxContentWidth - 16) / 2 : maxContentWidth;

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: width,
                maxWidth: maxContentWidth,
              ),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SectionHeader(
                      title: title,
                      subtitle: subtitle,
                      action: BadgeLabel(
                        label: currentRole,
                        color: OsColors.blue,
                      ),
                    ),
                    GlassCard(
                      padding: const EdgeInsets.all(18),
                      radius: 28,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              IconBubble(
                                icon: Icons.confirmation_number_outlined,
                                color: OsColors.blue,
                                size: 50,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Ticket overview',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleLarge,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Source-aligned workflow with search, priority filtering and live ticket detail.',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(color: OsColors.muted),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _MetricRow(
                            maxWidth: maxContentWidth,
                            visibleTickets: summaryTickets,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      label: 'Search Tickets',
                      hint:
                          'Search by title, id, reporter, assignee or department',
                      icon: Icons.search_rounded,
                      controller: searchController,
                      trailingLabel: '${tickets.length}',
                    ),
                    const SizedBox(height: 14),
                    _PriorityFilterRow(
                      priorityFilter: priorityFilter,
                      onChanged: onPriorityFilterChanged,
                    ),
                    const SizedBox(height: 18),
                    if (tickets.isEmpty)
                      GlassCard(
                        padding: const EdgeInsets.all(24),
                        radius: 26,
                        child: Column(
                          children: [
                            const Icon(
                              Icons.confirmation_number_outlined,
                              size: 42,
                              color: OsColors.muted,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              emptyLabel,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Adjust the search or filters to reveal the current ticket register.',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: OsColors.muted),
                            ),
                          ],
                        ),
                      )
                    else if (isWide)
                      Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: [
                          for (final ticket in tickets)
                            SizedBox(
                              width: cardWidth,
                              child: _TicketCard(
                                ticket: ticket,
                                onTap: () => onTicketTap(ticket),
                                currentUserName: currentUserName,
                              ),
                            ),
                        ],
                      )
                    else
                      Column(
                        children: [
                          for (final ticket in tickets) ...[
                            _TicketCard(
                              ticket: ticket,
                              onTap: () => onTicketTap(ticket),
                              currentUserName: currentUserName,
                            ),
                            const SizedBox(height: 14),
                          ],
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _MetricRow extends StatelessWidget {
  const _MetricRow({required this.maxWidth, required this.visibleTickets});

  final double maxWidth;
  final List<Map<String, String>> visibleTickets;

  @override
  Widget build(BuildContext context) {
    final metricWidth = maxWidth >= 720
        ? (maxWidth - 48) / 4
        : (maxWidth - 24) / 2;

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        SizedBox(
          width: metricWidth,
          child: _MetricCard(
            label: 'Open',
            value: '${_openCount(visibleTickets)}',
            icon: Icons.error_outline_rounded,
            color: OsColors.orange,
          ),
        ),
        SizedBox(
          width: metricWidth,
          child: _MetricCard(
            label: 'Resolved',
            value: '${_resolvedCount(visibleTickets)}',
            icon: Icons.check_circle_outline_rounded,
            color: OsColors.green,
          ),
        ),
        SizedBox(
          width: metricWidth,
          child: _MetricCard(
            label: 'SLA Risk',
            value: '${_slaRiskCount(visibleTickets)}',
            icon: Icons.schedule_rounded,
            color: OsColors.blue,
          ),
        ),
        SizedBox(
          width: metricWidth,
          child: _MetricCard(
            label: 'Visible',
            value: '${visibleTickets.length}',
            icon: Icons.visibility_outlined,
            color: OsColors.purple,
          ),
        ),
      ],
    );
  }

  int _openCount(List<Map<String, String>> tickets) {
    return tickets.where((ticket) {
      final status = ticket['status'] ?? '';
      return status == 'Open' || status == 'In Progress';
    }).length;
  }

  int _resolvedCount(List<Map<String, String>> tickets) {
    return tickets.where((ticket) {
      final status = ticket['status'] ?? '';
      return status == 'Resolved' || status == 'Closed';
    }).length;
  }

  int _slaRiskCount(List<Map<String, String>> tickets) {
    return tickets.where((ticket) {
      final slaStatus = ticket['slaStatus'] ?? '';
      return slaStatus == 'At Risk' ||
          slaStatus == 'Overdue' ||
          slaStatus == 'Escalated';
    }).length;
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      radius: 24,
      child: Row(
        children: [
          IconBubble(icon: icon, color: color, size: 40),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(
                    context,
                  ).textTheme.labelSmall?.copyWith(color: OsColors.muted),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(color: color, fontSize: 22),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PriorityFilterRow extends StatelessWidget {
  const _PriorityFilterRow({
    required this.priorityFilter,
    required this.onChanged,
  });

  final String priorityFilter;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final options = const ['All', 'Critical', 'High', 'Medium', 'Low'];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          Text(
            'Priority',
            style: Theme.of(
              context,
            ).textTheme.labelMedium?.copyWith(color: OsColors.slate),
          ),
          const SizedBox(width: 12),
          for (final option in options) ...[
            _FilterPill(
              label: option,
              selected: priorityFilter == option,
              onTap: () => onChanged(option),
            ),
            const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }
}

class _FilterPill extends StatelessWidget {
  const _FilterPill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? OsColors.black : Colors.white.withValues(alpha: 0.55),
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: selected
                  ? OsColors.black
                  : Colors.white.withValues(alpha: 0.7),
            ),
          ),
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: selected ? Colors.white : OsColors.slate,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}

class _TicketCard extends StatelessWidget {
  const _TicketCard({
    required this.ticket,
    required this.onTap,
    required this.currentUserName,
  });

  final Map<String, String> ticket;
  final VoidCallback onTap;
  final String currentUserName;

  @override
  Widget build(BuildContext context) {
    final status = ticket['status'] ?? '';
    final priority = ticket['priority'] ?? '';
    final department = ticket['department'] ?? 'General';
    final visibility = ticket['visibility'] ?? 'Standard';
    final createdAt = _formatShortDate(ticket['createdAt']);
    final reporter = ticket['reporterName'] ?? ticket['reporter'] ?? '';
    final assignee = ticket['assigneeName']?.isNotEmpty == true
        ? ticket['assigneeName']!
        : 'Unassigned';
    final commentCount = _ticketCommentsFor(ticket).length;
    final statusColor = OsUtils.getStatusColor(status);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(28),
        child: GlassCard(
          padding: const EdgeInsets.all(18),
          radius: 28,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              border: Border(
                left: BorderSide(
                  color: statusColor.withValues(alpha: 0.65),
                  width: 4,
                ),
              ),
            ),
            padding: const EdgeInsets.only(left: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    BadgeLabel(label: status, color: statusColor),
                    const SizedBox(width: 8),
                    BadgeLabel(
                      label: priority,
                      color: OsUtils.getPriorityColor(priority),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.arrow_forward_rounded,
                      color: OsColors.blue.withValues(alpha: 0.9),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  ticket['title'] ?? '',
                  style: Theme.of(context).textTheme.titleLarge,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  ticket['description'] ?? '',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: OsColors.muted,
                    height: 1.45,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    BadgeLabel(label: department, color: OsColors.blue),
                    BadgeLabel(label: visibility, color: OsColors.purple),
                    BadgeLabel(
                      label: '$commentCount notes',
                      color: OsColors.green,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _MetaBlock(label: 'Reporter', value: reporter),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _MetaBlock(label: 'Assigned', value: assignee),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _MetaBlock(label: 'Created', value: createdAt),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _MetaBlock(
                        label: 'Ticket ID',
                        value: ticket['id'] ?? '',
                      ),
                    ),
                  ],
                ),
                if (_isOwnedByCurrentUser(ticket, currentUserName)) ...[
                  const SizedBox(height: 14),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: BadgeLabel(
                      label: 'Your ticket',
                      color: OsColors.orange,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _isOwnedByCurrentUser(
    Map<String, String> ticket,
    String currentUserName,
  ) {
    final reporter = ticket['reporterName'] ?? ticket['reporter'] ?? '';
    final assignee = ticket['assigneeName'] ?? ticket['assignee'] ?? '';
    return reporter == currentUserName || assignee == currentUserName;
  }
}

class _MetaBlock extends StatelessWidget {
  const _MetaBlock({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.42),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(color: OsColors.muted),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: OsColors.ink,
            ),
          ),
        ],
      ),
    );
  }
}

class _TicketComposer extends StatelessWidget {
  const _TicketComposer({
    required this.titleController,
    required this.descriptionController,
    required this.priority,
    required this.category,
    required this.department,
    required this.onPriorityChanged,
    required this.onCategoryChanged,
    required this.onDepartmentChanged,
    required this.onSubmit,
  });

  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final String priority;
  final String category;
  final String department;
  final ValueChanged<String> onPriorityChanged;
  final ValueChanged<String> onCategoryChanged;
  final ValueChanged<String> onDepartmentChanged;
  final Future<void> Function() onSubmit;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 760;
        final optionsWidth = wide
            ? (constraints.maxWidth - 16) / 2
            : constraints.maxWidth;

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeader(
                title: 'Create Ticket',
                subtitle:
                    'Capture a support request with category, department and priority.',
              ),
              GlassCard(
                padding: const EdgeInsets.all(20),
                radius: 28,
                child: Column(
                  children: [
                    AppTextField(
                      label: 'Title',
                      hint: 'Brief summary of the issue',
                      icon: Icons.title_rounded,
                      controller: titleController,
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      label: 'Description',
                      hint:
                          'Add the context, impact and what you need resolved.',
                      icon: Icons.description_outlined,
                      controller: descriptionController,
                      maxLines: 4,
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: [
                        SizedBox(
                          width: optionsWidth,
                          child: AppSelect(
                            label: 'Priority',
                            value: priority,
                            options: const [
                              'Low',
                              'Medium',
                              'High',
                              'Critical',
                            ],
                            onChanged: onPriorityChanged,
                          ),
                        ),
                        SizedBox(
                          width: optionsWidth,
                          child: AppSelect(
                            label: 'Category',
                            value: category,
                            options: const [
                              'Bug',
                              'Feature Request',
                              'Enhancement',
                              'Infrastructure Issue',
                              'HR Issue',
                              'Process Improvement',
                              'General Support',
                            ],
                            onChanged: onCategoryChanged,
                          ),
                        ),
                        SizedBox(
                          width: optionsWidth,
                          child: AppSelect(
                            label: 'Department',
                            value: department,
                            options: MockData.mockDepartments,
                            onChanged: onDepartmentChanged,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'HR issues are routed as restricted tickets by default.',
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(color: OsColors.muted),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    FilledActionButton(
                      label: 'Create Ticket',
                      icon: Icons.send_rounded,
                      onPressed: onSubmit,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TicketDetailsSheet extends StatefulWidget {
  const _TicketDetailsSheet({
    required this.ticket,
    required this.currentUserName,
    required this.currentRole,
    required this.onSave,
  });

  final Map<String, String> ticket;
  final String currentUserName;
  final String currentRole;
  final ValueChanged<Map<String, String>> onSave;

  @override
  State<_TicketDetailsSheet> createState() => _TicketDetailsSheetState();
}

class _TicketDetailsSheetState extends State<_TicketDetailsSheet> {
  late Map<String, String> _ticket;
  late String _status;
  late String _assigneeName;
  late String _commentVisibility;
  final TextEditingController _commentController = TextEditingController();
  late List<Map<String, String>> _comments;
  late List<Map<String, String>> _activities;

  @override
  void initState() {
    super.initState();
    _ticket = Map<String, String>.from(widget.ticket);
    _status = _ticket['status'] ?? 'Open';
    _assigneeName = _ticket['assigneeName']?.isNotEmpty == true
        ? _ticket['assigneeName']!
        : 'Unassigned';
    _commentVisibility = _isPrivilegedRole(widget.currentRole)
        ? 'Internal Only'
        : 'Public';
    _comments = _loadComments(_ticket);
    _activities = _loadActivities(_ticket, _comments);
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final priority = _ticket['priority'] ?? '';
    final department = _ticket['department'] ?? 'General';
    final visibility = _ticket['visibility'] ?? 'Standard';
    final createdAt = _formatReadableDateTime(_ticket['createdAt']);
    final updatedAt = _formatReadableDateTime(_ticket['updatedAt']);
    final reporter = _ticket['reporterName'] ?? _ticket['reporter'] ?? '';
    final slaStatus = _ticket['slaStatus'] ?? 'On Track';
    final isPrivileged = _isPrivilegedRole(widget.currentRole);
    final isCreator = reporter == widget.currentUserName;
    final isAssigned = _assigneeName == widget.currentUserName;
    final canAct = isPrivileged || isCreator || isAssigned;

    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 12,
        ),
        child: Container(
          margin: const EdgeInsets.fromLTRB(12, 36, 12, 12),
          child: SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.92,
            child: GlassCard(
              padding: const EdgeInsets.all(20),
              radius: 30,
              child: Column(
                children: [
                  Container(
                    width: 44,
                    height: 5,
                    decoration: BoxDecoration(
                      color: OsColors.line,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                BadgeLabel(
                                  label: _ticket['id'] ?? '',
                                  color: OsColors.slate,
                                ),
                                BadgeLabel(
                                  label: _status,
                                  color: OsUtils.getStatusColor(_status),
                                ),
                                BadgeLabel(
                                  label: priority,
                                  color: OsUtils.getPriorityColor(priority),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            Text(
                              _ticket['title'] ?? '',
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _ticket['description'] ?? '',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    height: 1.5,
                                    color: OsColors.muted,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      IconButton.filledTonal(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close_rounded),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  GlassCard(
                    padding: const EdgeInsets.all(16),
                    radius: 24,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _DetailStat(
                                label: 'Department',
                                value: department,
                                icon: Icons.business_center_outlined,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _DetailStat(
                                label: 'Visibility',
                                value: visibility,
                                icon: Icons.lock_outline_rounded,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: _DetailStat(
                                label: 'Created',
                                value: createdAt,
                                icon: Icons.event_outlined,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _DetailStat(
                                label: 'Updated',
                                value: updatedAt,
                                icon: Icons.history_rounded,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: _DetailStat(
                                label: 'Reporter',
                                value: reporter,
                                icon: Icons.person_outline_rounded,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _DetailStat(
                                label: 'SLA',
                                value: slaStatus,
                                icon: Icons.schedule_rounded,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  if (canAct) ...[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Quick actions',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        if (_status == 'Open' && (isAssigned || isPrivileged))
                          FilledActionButton(
                            label: 'Start Progress',
                            icon: Icons.play_arrow_rounded,
                            onPressed: _startProgress,
                          ),
                        if (_status == 'In Progress' &&
                            (isAssigned || isPrivileged))
                          FilledActionButton(
                            label: 'Mark Resolved',
                            icon: Icons.check_circle_rounded,
                            onPressed: _markResolved,
                          ),
                        if (_status == 'Resolved' && isCreator)
                          FilledActionButton(
                            label: 'Close Ticket',
                            icon: Icons.task_alt_rounded,
                            onPressed: _closeTicket,
                            color: OsColors.green,
                          ),
                        if (_status == 'Closed' && (isCreator || isPrivileged))
                          FilledActionButton(
                            label: 'Reopen',
                            icon: Icons.refresh_rounded,
                            onPressed: _reopenTicket,
                            color: OsColors.orange,
                          ),
                      ],
                    ),
                    const SizedBox(height: 14),
                  ],
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (isPrivileged) ...[
                            _SectionTitle(
                              title: 'Ticket controls',
                              subtitle:
                                  'Update the live status and change the assigned person.',
                            ),
                            const SizedBox(height: 10),
                            LayoutBuilder(
                              builder: (context, constraints) {
                                final wide = constraints.maxWidth >= 500;
                                final selectWidth = wide
                                    ? (constraints.maxWidth - 10) / 2
                                    : constraints.maxWidth;
                                return Wrap(
                                  spacing: 10,
                                  runSpacing: 10,
                                  children: [
                                    SizedBox(
                                      width: selectWidth,
                                      child: AppSelect(
                                        label: 'Status',
                                        value: _status,
                                        options: const [
                                          'Open',
                                          'In Progress',
                                          'Resolved',
                                          'Closed',
                                          'Reopened',
                                        ],
                                        onChanged: (value) {
                                          setState(() => _status = value);
                                          _recordActivity(
                                            action: 'Status updated',
                                            details:
                                                'Changed status to $value.',
                                          );
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      width: selectWidth,
                                      child: AppSelect(
                                        label: 'Assign To',
                                        value: _assigneeName,
                                        options: [
                                          'Unassigned',
                                          ...MockData.ticketUsers.map(
                                            (user) => user['name']!,
                                          ),
                                        ],
                                        onChanged: (value) {
                                          setState(() {
                                            if (value == 'Unassigned') {
                                              _assigneeName = 'Unassigned';
                                            } else {
                                              final user = MockData.ticketUsers
                                                  .firstWhere(
                                                    (user) =>
                                                        user['name'] == value,
                                                    orElse: () => const {
                                                      'id': '',
                                                      'name': 'Unassigned',
                                                    },
                                                  );
                                              _assigneeName =
                                                  user['name'] ?? 'Unassigned';
                                              _persistTicket(
                                                assigneeId: user['id'] ?? '',
                                                assigneeName: _assigneeName,
                                              );
                                            }
                                          });
                                          _recordActivity(
                                            action: 'Assigned ticket',
                                            details:
                                                'Assigned to $_assigneeName.',
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                            const SizedBox(height: 16),
                          ],
                          _SectionTitle(
                            title: 'Comments',
                            subtitle:
                                'Updates are stored with the ticket and remain visible after saving.',
                          ),
                          const SizedBox(height: 10),
                          if (_comments.isEmpty)
                            GlassCard(
                              padding: const EdgeInsets.all(18),
                              radius: 22,
                              child: Text(
                                'No comments yet.',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(color: OsColors.muted),
                              ),
                            )
                          else
                            Column(
                              children: [
                                for (final comment in _comments) ...[
                                  _CommentCard(
                                    comment: comment,
                                    allowInternal: isPrivileged,
                                  ),
                                  const SizedBox(height: 10),
                                ],
                              ],
                            ),
                          const SizedBox(height: 12),
                          AppTextField(
                            label: 'Add comment',
                            hint: 'Write an update, note or next step...',
                            icon: Icons.message_outlined,
                            controller: _commentController,
                            maxLines: 3,
                          ),
                          const SizedBox(height: 10),
                          if (isPrivileged)
                            Row(
                              children: [
                                _FilterPill(
                                  label: 'Public',
                                  selected: _commentVisibility == 'Public',
                                  onTap: () {
                                    setState(
                                      () => _commentVisibility = 'Public',
                                    );
                                  },
                                ),
                                const SizedBox(width: 8),
                                _FilterPill(
                                  label: 'Internal Note',
                                  selected:
                                      _commentVisibility == 'Internal Only',
                                  onTap: () {
                                    setState(
                                      () =>
                                          _commentVisibility = 'Internal Only',
                                    );
                                  },
                                ),
                              ],
                            ),
                          const SizedBox(height: 12),
                          FilledActionButton(
                            label: 'Post Comment',
                            icon: Icons.send_rounded,
                            onPressed: _addComment,
                          ),
                          const SizedBox(height: 18),
                          _SectionTitle(
                            title: 'Activity timeline',
                            subtitle:
                                'A compact history of the ticket lifecycle, including changes and updates.',
                          ),
                          const SizedBox(height: 10),
                          if (_activities.isEmpty)
                            Text(
                              'No activity captured yet.',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: OsColors.muted),
                            )
                          else
                            Column(
                              children: [
                                for (final activity in _activities) ...[
                                  _ActivityCard(activity: activity),
                                  const SizedBox(height: 10),
                                ],
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool _isPrivilegedRole(String role) {
    final normalized = role.toLowerCase();
    return normalized.contains('admin') ||
        normalized.contains('manager') ||
        normalized.contains('hr');
  }

  List<Map<String, String>> _loadComments(Map<String, String> ticket) {
    final encoded = ticket['commentsJson'];
    if (encoded != null && encoded.isNotEmpty) {
      final decoded = _decodeList(encoded);
      if (decoded.isNotEmpty) {
        return decoded;
      }
    }

    return MockData.ticketComments
        .where((comment) => comment['ticketId'] == ticket['id'])
        .map((comment) => Map<String, String>.from(comment))
        .toList();
  }

  List<Map<String, String>> _loadActivities(
    Map<String, String> ticket,
    List<Map<String, String>> comments,
  ) {
    final encoded = ticket['activitiesJson'];
    if (encoded != null && encoded.isNotEmpty) {
      final decoded = _decodeList(encoded);
      if (decoded.isNotEmpty) {
        return decoded;
      }
    }

    final activities = <Map<String, String>>[
      {
        'id': 'created-${ticket['id']}',
        'timestamp': _formatReadableDateTime(ticket['createdAt']),
        'user': ticket['reporterName'] ?? ticket['reporter'] ?? '',
        'action': 'Created ticket',
        'details': ticket['description'] ?? '',
      },
    ];

    final assignee = ticket['assigneeName'] ?? '';
    final assignedDate = ticket['assignedDate'];
    if (assignee.isNotEmpty &&
        assignee != 'Unassigned' &&
        assignedDate != null &&
        assignedDate.isNotEmpty) {
      activities.add({
        'id': 'assigned-${ticket['id']}',
        'timestamp': assignedDate,
        'user': ticket['assignedBy'] ?? 'System',
        'action': 'Assigned ticket',
        'details': 'Assigned to $assignee',
      });
    }

    for (final comment in comments) {
      activities.add({
        'id': 'comment-${comment['id']}',
        'timestamp': _formatReadableDateTime(comment['createdAt']),
        'user': comment['authorName'] ?? '',
        'action': comment['visibility'] == 'Internal Only'
            ? 'Internal note'
            : 'Comment posted',
        'details': comment['content'] ?? '',
      });
    }

    final updatedAt = ticket['updatedAt'];
    if (updatedAt != null &&
        updatedAt.isNotEmpty &&
        updatedAt != ticket['createdAt']) {
      activities.add({
        'id': 'updated-${ticket['id']}',
        'timestamp': _formatReadableDateTime(updatedAt),
        'user': ticket['assignedBy'] ?? ticket['reporterName'] ?? '',
        'action': 'Ticket updated',
        'details': 'Latest status and assignment details saved.',
      });
    }

    return activities.reversed.toList();
  }

  List<Map<String, String>> _decodeList(String encoded) {
    final decoded = jsonDecode(encoded);
    if (decoded is! List) {
      return [];
    }

    return decoded
        .whereType<Map<String, dynamic>>()
        .map(
          (entry) =>
              entry.map((key, value) => MapEntry(key, value?.toString() ?? '')),
        )
        .toList();
  }

  void _persistTicket({
    String? status,
    String? assigneeId,
    String? assigneeName,
    List<Map<String, String>>? comments,
    List<Map<String, String>>? activities,
    String? activityAction,
    String? activityDetails,
  }) {
    final now = DateTime.now().toUtc().toIso8601String();
    final nextComments = comments ?? _comments;
    final nextActivities = activities ?? _activities;

    final updatedTicket = {
      ...widget.ticket,
      ..._ticket,
      if (status != null) 'status': status,
      if (assigneeId != null) 'assigneeId': assigneeId,
      if (assigneeName != null) 'assigneeName': assigneeName,
      'updatedAt': now,
      'commentsJson': jsonEncode(nextComments),
      'activitiesJson': jsonEncode(nextActivities),
    };

    if (status != null) {
      updatedTicket['status'] = status;
    }
    if (assigneeId != null) {
      updatedTicket['assigneeId'] = assigneeId;
    }
    if (assigneeName != null) {
      updatedTicket['assigneeName'] = assigneeName;
    }

    widget.onSave(updatedTicket);
    setState(() {
      _ticket = Map<String, String>.from(updatedTicket);
      if (status != null) {
        _status = status;
      }
      if (assigneeName != null) {
        _assigneeName = assigneeName;
      }
      _comments = nextComments;
      _activities = nextActivities;
    });
  }

  void _recordActivity({required String action, required String details}) {
    final now = DateTime.now().toUtc().toIso8601String();
    final updated = [
      {
        'id': 'a-${DateTime.now().microsecondsSinceEpoch}',
        'timestamp': _formatActivityTime(now),
        'user': widget.currentUserName,
        'action': action,
        'details': details,
      },
      ..._activities,
    ];
    _persistTicket(
      activities: updated,
      activityAction: action,
      activityDetails: details,
    );
  }

  void _startProgress() {
    _recordActivity(
      action: 'Status changed',
      details: 'Moved the ticket from Open to In Progress.',
    );
    _persistTicket(status: 'In Progress');
  }

  void _markResolved() {
    _recordActivity(
      action: 'Resolved ticket',
      details: 'Marked the ticket as resolved and ready for verification.',
    );
    _persistTicket(status: 'Resolved');
  }

  void _closeTicket() {
    _recordActivity(
      action: 'Closed ticket',
      details: 'Creator accepted the resolution and closed the case.',
    );
    _persistTicket(status: 'Closed');
  }

  void _reopenTicket() {
    _recordActivity(
      action: 'Reopened ticket',
      details: 'Ticket reopened for further action.',
    );
    _persistTicket(status: 'Reopened');
  }

  void _addComment() {
    final text = _commentController.text.trim();
    if (text.isEmpty) {
      return;
    }

    final comment = {
      'id': 'c-${DateTime.now().millisecondsSinceEpoch}',
      'ticketId': _ticket['id'] ?? '',
      'authorId': 'u-mobile',
      'authorName': widget.currentUserName,
      'content': text,
      'createdAt': DateTime.now().toUtc().toIso8601String(),
      'visibility': _commentVisibility,
    };

    final updatedComments = [..._comments, comment];
    final updatedActivities = [
      {
        'id': 'a-${DateTime.now().microsecondsSinceEpoch}',
        'timestamp': _formatActivityTime(comment['createdAt']),
        'user': widget.currentUserName,
        'action': _commentVisibility == 'Internal Only'
            ? 'Internal note'
            : 'Comment posted',
        'details': text,
      },
      ..._activities,
    ];

    _commentController.clear();
    _persistTicket(
      comments: updatedComments,
      activities: updatedActivities,
      activityAction: 'Comment posted',
      activityDetails: text,
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: OsColors.muted),
        ),
      ],
    );
  }
}

class _DetailStat extends StatelessWidget {
  const _DetailStat({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.42),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.6)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: OsColors.blue),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(
                    context,
                  ).textTheme.labelSmall?.copyWith(color: OsColors.muted),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: OsColors.ink,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CommentCard extends StatelessWidget {
  const _CommentCard({required this.comment, required this.allowInternal});

  final Map<String, String> comment;
  final bool allowInternal;

  @override
  Widget build(BuildContext context) {
    final isInternal = comment['visibility'] == 'Internal Only';
    if (isInternal && !allowInternal) {
      return const SizedBox.shrink();
    }

    final author = comment['authorName'] ?? '';
    final createdAt = _formatReadableDateTime(comment['createdAt']);

    return GlassCard(
      padding: const EdgeInsets.all(16),
      radius: 22,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: OsColors.blue,
                ),
                child: Text(
                  author.isNotEmpty
                      ? author.characters.first.toUpperCase()
                      : 'T',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(author, style: Theme.of(context).textTheme.labelLarge),
                    const SizedBox(height: 2),
                    Text(
                      createdAt,
                      style: Theme.of(
                        context,
                      ).textTheme.labelSmall?.copyWith(color: OsColors.muted),
                    ),
                  ],
                ),
              ),
              if (isInternal)
                BadgeLabel(label: 'Internal', color: OsColors.purple),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            comment['content'] ?? '',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(height: 1.45),
          ),
        ],
      ),
    );
  }
}

class _ActivityCard extends StatelessWidget {
  const _ActivityCard({required this.activity});

  final Map<String, String> activity;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.42),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.6)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: OsColors.blue,
            ),
            child: const Icon(
              Icons.timeline_rounded,
              color: Colors.white,
              size: 18,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        activity['action'] ?? '',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ),
                    Text(
                      activity['timestamp'] ?? '',
                      style: Theme.of(
                        context,
                      ).textTheme.labelSmall?.copyWith(color: OsColors.muted),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  activity['details'] ?? '',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: OsColors.muted,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

String _formatShortDate(String? iso) {
  final parsed = DateTime.tryParse(iso ?? '');
  if (parsed == null) return '';
  final local = parsed.toLocal();
  return '${_monthName(local.month)} ${local.day}, ${local.year}';
}

String _formatReadableDateTime(String? iso) {
  final parsed = DateTime.tryParse(iso ?? '');
  if (parsed == null) return '';
  final local = parsed.toLocal();
  return '${local.day} ${_monthName(local.month)} ${local.year}, '
      '${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}';
}

String _formatActivityTime(String? iso) {
  final parsed = DateTime.tryParse(iso ?? '');
  if (parsed == null) return '';
  final local = parsed.toLocal();
  return '${local.day} ${_monthName(local.month)} ${local.year}, '
      '${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}';
}

List<Map<String, String>> _ticketCommentsFor(Map<String, String> ticket) {
  final encoded = ticket['commentsJson'];
  if (encoded != null && encoded.isNotEmpty) {
    final decoded = _decodeTicketMapList(encoded);
    if (decoded.isNotEmpty) {
      return decoded;
    }
  }

  return MockData.ticketComments
      .where((comment) => comment['ticketId'] == ticket['id'])
      .map((comment) => Map<String, String>.from(comment))
      .toList();
}

List<Map<String, String>> _decodeTicketMapList(String encoded) {
  final decoded = jsonDecode(encoded);
  if (decoded is! List) {
    return [];
  }

  return decoded
      .whereType<Map<String, dynamic>>()
      .map(
        (entry) =>
            entry.map((key, value) => MapEntry(key, value?.toString() ?? '')),
      )
      .toList();
}

String _formatDueDate(DateTime base, String priority) {
  final due = base.add(switch (priority) {
    'Critical' => const Duration(hours: 4),
    'High' => const Duration(hours: 24),
    'Medium' => const Duration(days: 3),
    _ => const Duration(days: 5),
  });
  return _formatReadableDateTime(due.toUtc().toIso8601String());
}

String _slaTargetForPriority(String priority) {
  return switch (priority) {
    'Critical' => '4 hours',
    'High' => '24 hours',
    'Medium' => '3 business days',
    _ => '5 business days',
  };
}

String _monthName(int month) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return months[month - 1];
}
