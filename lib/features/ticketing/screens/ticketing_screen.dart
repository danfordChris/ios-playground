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
    required this.onCreateTicket,
    required this.onUpdateTicket,
  });

  final int activeIndex;
  final List<Map<String, String>> tickets;
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
        onPriorityChanged: (value) => setState(() => _priority = value),
        onCategoryChanged: (value) => setState(() => _category = value),
        onSubmit: _createTicket,
      );
    }

    return _TicketListView(
      title: _listTitleFor(widget.activeIndex),
      subtitle: _listSubtitleFor(widget.activeIndex),
      summaryTickets: _tabTickets(),
      tickets: _filteredTickets(),
      searchController: _searchController,
      emptyLabel: _emptyLabelFor(widget.activeIndex),
      onTicketTap: _openTicketDetails,
    );
  }

  void _onSearchChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  List<Map<String, String>> _tabTickets() {
    return widget.tickets.where((ticket) {
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
    final base = _tabTickets().where((ticket) {
      if (query.isEmpty) return true;

      final searchable = [
        ticket['id'],
        ticket['title'],
        ticket['description'],
        ticket['category'],
        ticket['reporterName'] ?? ticket['reporter'],
      ].whereType<String>().join(' ').toLowerCase();
      return searchable.contains(query);
    }).toList();

    return base;
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
      0 => 'Manage and track support requests and issues.',
      1 => 'Active items that still need attention.',
      2 => 'Closed requests and completed fixes.',
      _ => 'Manage and track support requests and issues.',
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

    final now = DateTime.now().toUtc().toIso8601String();
    widget.onCreateTicket({
      'id': 't-${DateTime.now().millisecondsSinceEpoch}',
      'title': title,
      'description': description,
      'priority': _priority,
      'status': 'Open',
      'category': _category,
      'reporter': 'Erick',
      'reporterId': 'u-1',
      'reporterName': 'Erick',
      'assigneeId': '',
      'assigneeName': '',
      'createdAt': now,
      'updatedAt': now,
    });

    _titleController.clear();
    _descriptionController.clear();
    _priority = 'Medium';
    _category = 'Bug';
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
      builder: (_) {
        return _TicketDetailsSheet(
          ticket: ticket,
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
    required this.emptyLabel,
    required this.onTicketTap,
  });

  final String title;
  final String subtitle;
  final List<Map<String, String>> summaryTickets;
  final List<Map<String, String>> tickets;
  final TextEditingController searchController;
  final String emptyLabel;
  final ValueChanged<Map<String, String>> onTicketTap;

  @override
  Widget build(BuildContext context) {
    return ScrollableSection(
      children: [
        SectionHeader(title: title, subtitle: subtitle),
        Row(
          children: [
            Expanded(
              child: MetricTile(
                label: 'Open',
                value: '${_openCount(summaryTickets)}',
                color: OsColors.orange,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: MetricTile(
                label: 'Resolved',
                value: '${_resolvedCount(summaryTickets)}',
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
        const SizedBox(height: 16),
        AppTextField(
          label: 'Search Tickets',
          hint: 'Search by title, id, reporter...',
          icon: Icons.search_rounded,
          controller: searchController,
          trailingLabel: '${tickets.length}',
        ),
        const SizedBox(height: 18),
        if (tickets.isEmpty)
          GlassCard(
            padding: const EdgeInsets.all(24),
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
                  'There are no tickets matching the current filter.',
                  textAlign: TextAlign.center,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: OsColors.muted),
                ),
              ],
            ),
          )
        else
          for (final ticket in tickets) ...[
            _TicketCard(ticket: ticket, onTap: () => onTicketTap(ticket)),
            const SizedBox(height: 12),
          ],
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
}

class _TicketCard extends StatelessWidget {
  const _TicketCard({required this.ticket, required this.onTap});

  final Map<String, String> ticket;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final status = ticket['status'] ?? '';
    final priority = ticket['priority'] ?? '';
    final createdAt = _formatDate(ticket['createdAt']);
    final assignee = ticket['assigneeName']?.isNotEmpty == true
        ? ticket['assigneeName']!
        : 'Unassigned';
    final statusColor = OsUtils.getStatusColor(status);

    return StatusCard(
      icon: _statusIcon(status),
      color: statusColor,
      title: ticket['title'] ?? '',
      subtitle:
          '${ticket['id'] ?? ''} • ${ticket['reporterName'] ?? ticket['reporter'] ?? ''} • $createdAt',
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BadgeLabel(
            label: priority,
            color: OsUtils.getPriorityColor(priority),
          ),
          const SizedBox(height: 8),
          Text(
            assignee,
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(color: OsColors.muted),
          ),
        ],
      ),
      onTap: onTap,
    );
  }

  IconData _statusIcon(String status) {
    return switch (status) {
      'Open' => Icons.error_outline_rounded,
      'In Progress' => Icons.schedule_rounded,
      'Resolved' => Icons.check_circle_outline_rounded,
      'Closed' => Icons.task_alt_rounded,
      _ => Icons.confirmation_number_outlined,
    };
  }
}

class _TicketComposer extends StatefulWidget {
  const _TicketComposer({
    required this.titleController,
    required this.descriptionController,
    required this.priority,
    required this.category,
    required this.onPriorityChanged,
    required this.onCategoryChanged,
    required this.onSubmit,
  });

  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final String priority;
  final String category;
  final ValueChanged<String> onPriorityChanged;
  final ValueChanged<String> onCategoryChanged;
  final Future<void> Function() onSubmit;

  @override
  State<_TicketComposer> createState() => _TicketComposerState();
}

class _TicketComposerState extends State<_TicketComposer> {
  @override
  Widget build(BuildContext context) {
    return ScrollableSection(
      children: [
        const SectionHeader(
          title: 'Create Ticket',
          subtitle: 'Report an issue to IT, HR or Facilities.',
        ),
        GlassCard(
          padding: const EdgeInsets.all(22),
          child: Column(
            children: [
              AppTextField(
                label: 'Title',
                hint: 'Brief summary of the issue',
                icon: Icons.title_rounded,
                controller: widget.titleController,
              ),
              const SizedBox(height: 18),
              AppTextField(
                label: 'Description',
                hint: 'Provide detailed information...',
                icon: Icons.description_outlined,
                controller: widget.descriptionController,
                maxLines: 4,
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: AppSelect(
                      label: 'Priority',
                      value: widget.priority,
                      options: const ['Low', 'Medium', 'High', 'Critical'],
                      onChanged: widget.onPriorityChanged,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: AppSelect(
                      label: 'Category',
                      value: widget.category,
                      options: const [
                        'Bug',
                        'Feature',
                        'Support',
                        'IT',
                        'Other',
                      ],
                      onChanged: widget.onCategoryChanged,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              FilledActionButton(
                label: 'Create Ticket',
                icon: Icons.send_rounded,
                onPressed: widget.onSubmit,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TicketDetailsSheet extends StatefulWidget {
  const _TicketDetailsSheet({required this.ticket, required this.onSave});

  final Map<String, String> ticket;
  final ValueChanged<Map<String, String>> onSave;

  @override
  State<_TicketDetailsSheet> createState() => _TicketDetailsSheetState();
}

class _TicketDetailsSheetState extends State<_TicketDetailsSheet> {
  late Map<String, String> _ticket;
  late String _status;
  late String _assigneeId;
  late String _assigneeName;
  final TextEditingController _commentController = TextEditingController();
  late List<Map<String, String>> _comments;

  @override
  void initState() {
    super.initState();
    _ticket = Map<String, String>.from(widget.ticket);
    _status = _ticket['status'] ?? 'Open';
    _assigneeId = _ticket['assigneeId'] ?? '';
    _assigneeName = _ticket['assigneeName'] ?? '';
    _comments = MockData.ticketComments
        .where((comment) => comment['ticketId'] == _ticket['id'])
        .map((comment) => Map<String, String>.from(comment))
        .toList();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final category = _ticket['category'] ?? '';
    final priority = _ticket['priority'] ?? '';
    final createdAt = _formatFullDate(_ticket['createdAt']);
    final updatedAt = _formatFullDate(_ticket['updatedAt']);
    final reporter = _ticket['reporterName'] ?? _ticket['reporter'] ?? '';

    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 12,
        ),
        child: Container(
          margin: const EdgeInsets.fromLTRB(12, 40, 12, 12),
          child: GlassCard(
            padding: const EdgeInsets.all(20),
            radius: 28,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Container(
                      width: 46,
                      height: 5,
                      decoration: BoxDecoration(
                        color: OsColors.line,
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      BadgeLabel(
                        label: _ticket['id'] ?? '',
                        color: OsColors.slate,
                      ),
                      const SizedBox(width: 8),
                      BadgeLabel(
                        label: priority,
                        color: OsUtils.getPriorityColor(priority),
                      ),
                      const Spacer(),
                      IconButton.filledTonal(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close_rounded),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    _ticket['title'] ?? '',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _ticket['description'] ?? '',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(height: 1.55),
                  ),
                  const SizedBox(height: 20),
                  InfoRow(
                    label: 'Status',
                    value: _status,
                    trailing: SizedBox(
                      width: 170,
                      child: AppSelect(
                        label: 'Update',
                        value: _status,
                        options: const [
                          'Open',
                          'In Progress',
                          'Resolved',
                          'Closed',
                        ],
                        onChanged: (value) {
                          setState(() => _status = value);
                          _persistTicket();
                        },
                      ),
                    ),
                  ),
                  InfoRow(
                    label: 'Assignee',
                    value: _assigneeName.isEmpty ? 'Unassigned' : _assigneeName,
                    trailing: SizedBox(
                      width: 170,
                      child: AppSelect(
                        label: 'Assign To',
                        value: _assigneeName.isEmpty
                            ? 'Unassigned'
                            : _assigneeName,
                        options: [
                          'Unassigned',
                          ...MockData.ticketUsers.map((user) => user['name']!),
                        ],
                        onChanged: (value) {
                          setState(() {
                            if (value == 'Unassigned') {
                              _assigneeId = '';
                              _assigneeName = '';
                            } else {
                              final user = MockData.ticketUsers.firstWhere(
                                (user) => user['name'] == value,
                              );
                              _assigneeId = user['id'] ?? '';
                              _assigneeName = user['name'] ?? '';
                            }
                          });
                          _persistTicket();
                        },
                      ),
                    ),
                  ),
                  InfoRow(label: 'Reporter', value: reporter),
                  InfoRow(label: 'Category', value: category),
                  InfoRow(label: 'Created', value: createdAt),
                  InfoRow(label: 'Updated', value: updatedAt),
                  const SizedBox(height: 20),
                  Text(
                    'Activity',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  for (final comment in _comments) ...[
                    _CommentBubble(comment: comment),
                    const SizedBox(height: 12),
                  ],
                  if (_comments.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        'No comments yet.',
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(color: OsColors.muted),
                      ),
                    ),
                  const SizedBox(height: 12),
                  AppTextField(
                    label: 'Add Comment',
                    hint: 'Write a reply...',
                    icon: Icons.message_outlined,
                    controller: _commentController,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 14),
                  FilledActionButton(
                    label: 'Post Comment',
                    icon: Icons.send_rounded,
                    onPressed: _addComment,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _persistTicket() {
    widget.onSave({
      ...widget.ticket,
      'status': _status,
      'assigneeId': _assigneeId,
      'assigneeName': _assigneeName,
      'updatedAt': DateTime.now().toUtc().toIso8601String(),
    });
    setState(() {
      _ticket = {
        ..._ticket,
        'status': _status,
        'assigneeId': _assigneeId,
        'assigneeName': _assigneeName,
        'updatedAt': DateTime.now().toUtc().toIso8601String(),
      };
    });
  }

  void _addComment() {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _comments.add({
        'id': 'c-${DateTime.now().millisecondsSinceEpoch}',
        'ticketId': _ticket['id'] ?? '',
        'authorId': 'u-1',
        'authorName': 'Erick',
        'content': text,
        'createdAt': DateTime.now().toUtc().toIso8601String(),
      });
      _commentController.clear();
    });
    _persistTicket();
  }
}

class _CommentBubble extends StatelessWidget {
  const _CommentBubble({required this.comment});

  final Map<String, String> comment;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 38,
          height: 38,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: OsColors.blue,
          ),
          child: Text(
            (comment['authorName'] ?? 'E').characters.first.toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white.withValues(alpha: 0.7)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        comment['authorName'] ?? '',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ),
                    Text(
                      _formatCommentDate(comment['createdAt']),
                      style: Theme.of(
                        context,
                      ).textTheme.labelSmall?.copyWith(color: OsColors.muted),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  comment['content'] ?? '',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

String _formatDate(String? iso) {
  if (iso == null || iso.isEmpty) return '';
  final parsed = DateTime.tryParse(iso);
  if (parsed == null) return '';
  final local = parsed.toLocal();
  return '${local.year}-${local.month.toString().padLeft(2, '0')}-${local.day.toString().padLeft(2, '0')}';
}

String _formatFullDate(String? iso) {
  if (iso == null || iso.isEmpty) return '';
  final parsed = DateTime.tryParse(iso);
  if (parsed == null) return '';
  final local = parsed.toLocal();
  return '${local.year}-${local.month.toString().padLeft(2, '0')}-${local.day.toString().padLeft(2, '0')}';
}

String _formatCommentDate(String? iso) {
  if (iso == null || iso.isEmpty) return '';
  final parsed = DateTime.tryParse(iso);
  if (parsed == null) return '';
  final local = parsed.toLocal();
  return '${local.month}/${local.day} ${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}';
}
