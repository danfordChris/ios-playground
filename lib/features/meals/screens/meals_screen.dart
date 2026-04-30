import 'package:flutter/material.dart';
import '../../../core/theme/os_colors.dart';
import '../../../core/utils/os_utils.dart';
import '../../../shared/data/mock_data.dart';
import '../../../shared/widgets/shared_widgets.dart';

class MealsScreen extends StatelessWidget {
  const MealsScreen({super.key, required this.activeIndex});

  final int activeIndex;

  @override
  Widget build(BuildContext context) {
    switch (activeIndex) {
      case 1:
        return const _MealSelections();
      case 2:
        return const _MealPlan();
      case 3:
        return const _MealLibrary();
      case 4:
        return const _TeamMeals();
      case 5:
        return const _MealSettings();
      default:
        return const _MealsHome();
    }
  }
}

class _MealsHome extends StatefulWidget {
  const _MealsHome({super.key});
  @override
  State<_MealsHome> createState() => _MealsHomeState();
}

class _MealsHomeState extends State<_MealsHome> {
  int _activeTab = 0; // 0 for This Week, 1 for Next Week

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  Map<String, dynamic>? getTodaySelection() {
    final now = DateTime.now();
    final days = [
      'Sunday',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
    ];
    final todayName = days[now.weekday % 7];
    final selections =
        ((MockData.currentPlan as Map<String, dynamic>)['selections'] as List);
    try {
      return selections.firstWhere((s) => (s as Map<String, dynamic>)['day'] == todayName) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  Map<String, dynamic>? getMeal(String? id) {
    if (id == null) return null;
    try {
      if (id.startsWith('m')) {
        return (MockData.mains as List<Map<String, dynamic>>).firstWhere((m) => m['id'] == id);
      } else {
        return (MockData.sides as List<Map<String, dynamic>>).firstWhere((s) => s['id'] == id);
      }
    } catch (_) {
      return null;
    }
  }

  bool isLocked() {
    final now = DateTime.now();
    // Lock on Sunday (7) starting at 6:00 PM (18:00)
    return now.weekday == DateTime.sunday && now.hour >= 18;
  }

  @override
  Widget build(BuildContext context) {
    final todaySelection = getTodaySelection();
    final todayMain = getMeal(todaySelection?['mainId'] as String?);
    final todaySide = getMeal(todaySelection?['sideId'] as String?);
    final locked = isLocked();

    return ScrollableSection(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${getGreeting()}, Erick',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: OsColors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Welcome to iPF Meals.',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(color: OsColors.muted),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white),
              ),
              child: Row(
                children: [
                  const Icon(Icons.access_time_filled, size: 16, color: OsColors.blue),
                  const SizedBox(width: 6),
                  Text(
                    'Today',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: GlassCard(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.restaurant_menu, size: 18, color: OsColors.orange),
                            SizedBox(width: 8),
                            Text(
                              'TODAY\'S LUNCH',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.2,
                                color: OsColors.orange,
                              ),
                            ),
                          ],
                        ),
                        Icon(Icons.chevron_right, size: 18, color: OsColors.muted.withValues(alpha: 0.5)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    if (todaySelection != null) ...[
                      _MealItemSmall(label: 'MAIN COURSE', value: todayMain?['name'] as String? ?? 'None'),
                      const SizedBox(height: 12),
                      _MealItemSmall(label: 'SIDE DISH', value: todaySide?['name'] as String? ?? 'None'),
                      const SizedBox(height: 20),
                      BadgeLabel(
                        label: todaySelection['status'] as String,
                        color: todaySelection['status'] == 'Consumed' ? OsColors.green : OsColors.blue,
                      ),
                    ] else
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Text('No meal scheduled for today'),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        GlassCard(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: locked ? OsColors.red.withValues(alpha: 0.1) : OsColors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  locked ? Icons.lock : Icons.lock_open,
                  color: locked ? OsColors.red : OsColors.green,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Next Week\'s Plan', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(
                      locked ? 'Locked' : 'Open for Edits',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: locked ? OsColors.red : OsColors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('My Meal Plans', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F0F0).withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
              ),
              child: Row(
                children: [
                  _TabButton(
                    label: 'This Week',
                    isActive: _activeTab == 0,
                    onTap: () => setState(() => _activeTab = 0),
                  ),
                  _TabButton(
                    label: 'Next Week',
                    isActive: _activeTab == 1,
                    onTap: () => setState(() => _activeTab = 1),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (_activeTab == 0)
          ...(_buildWeeklyList(MockData.currentPlan as Map<String, dynamic>))
        else
          ...(_buildWeeklyList(MockData.nextWeekPlan as Map<String, dynamic>)),
        const SizedBox(height: 100),
      ],
    );
  }

  List<Widget> _buildWeeklyList(Map<String, dynamic> plan) {
    final selections = plan['selections'] as List;
    return selections.map((s) {
      final selection = s as Map<String, dynamic>;
      final mainId = selection['mainId'] as String?;
      final sideId = selection['sideId'] as String?;
      final main = getMeal(mainId);
      final side = getMeal(sideId);
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: GlassCard(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          radius: 20,
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: OsColors.muted.withValues(alpha: 0.1)),
                ),
                child: Text(
                  (selection['day'] as String).substring(0, 3),
                  style: const TextStyle(fontWeight: FontWeight.bold, color: OsColors.muted),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(main?['name'] as String? ?? 'No Selection', style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(side?['name'] as String? ?? '---', style: const TextStyle(fontSize: 12, color: OsColors.muted)),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }
}

class _MealItemSmall extends StatelessWidget {
  const _MealItemSmall({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: OsColors.muted, letterSpacing: 1)),
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({required this.label, required this.isActive, required this.onTap});
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? OsColors.black : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          boxShadow: isActive
              ? [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4, offset: const Offset(0, 2))]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: isActive ? Colors.white : OsColors.muted,
          ),
        ),
      ),
    );
  }
}

class _MealSelections extends StatefulWidget {
  const _MealSelections({super.key});
  @override
  State<_MealSelections> createState() => _MealSelectionsState();
}

class _MealSelectionsState extends State<_MealSelections> {
  Map<String, dynamic>? getMeal(String? id) {
    if (id == null) return null;
    try {
      if (id.startsWith('m')) {
        return (MockData.mains as List<Map<String, dynamic>>).firstWhere((m) => m['id'] == id);
      } else {
        return (MockData.sides as List<Map<String, dynamic>>).firstWhere((s) => s['id'] == id);
      }
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final currentDayIndex = now.weekday - 1; // 0 = Monday

    return ScrollableSection(
      children: [
        const SectionHeader(
          title: 'My Selections',
          subtitle: 'Your active meal plan for this week.',
        ),
        ...List.generate(((MockData.currentPlan as Map<String, dynamic>)['selections'] as List).length, (index) {
          final selection = ((MockData.currentPlan as Map<String, dynamic>)['selections'] as List)[index] as Map<String, dynamic>;
          final isPast = index < currentDayIndex;
          final isToday = index == currentDayIndex;
          final mainId = selection['mainId'] as String?;
          final sideId = selection['sideId'] as String?;
          final main = getMeal(mainId);
          final side = getMeal(sideId);

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: GlassCard(
              padding: const EdgeInsets.all(20),
              radius: 24,
              child: Opacity(
                opacity: isPast ? 0.6 : 1.0,
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: isToday ? OsColors.blue.withValues(alpha: 0.1) : OsColors.muted.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isPast ? Icons.check_circle : (isToday ? Icons.restaurant : Icons.circle_outlined),
                        color: isPast ? OsColors.green : (isToday ? OsColors.blue : OsColors.muted),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                selection['day'] as String,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  decoration: isPast ? TextDecoration.lineThrough : null,
                                ),
                              ),
                              const SizedBox(width: 8),
                              if (isToday)
                                const BadgeLabel(label: 'TODAY', color: OsColors.blue)
                              else if (isPast)
                                const BadgeLabel(label: 'CONSUMED', color: OsColors.green),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${main?['name'] ?? 'Not Selected'} • ${side?['name'] ?? 'Not Selected'}',
                            style: const TextStyle(color: OsColors.muted, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
        const SizedBox(height: 100),
      ],
    );
  }
}

class _MealPlan extends StatelessWidget {
  const _MealPlan({super.key});
  Map<String, dynamic>? getMeal(String? id) {
    if (id == null) return null;
    try {
      if (id.startsWith('m')) {
        return (MockData.mains as List<Map<String, dynamic>>).firstWhere((m) => m['id'] == id);
      } else {
        return (MockData.sides as List<Map<String, dynamic>>).firstWhere((s) => s['id'] == id);
      }
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScrollableSection(
      children: [
        const SectionHeader(
          title: 'My Plan History',
          subtitle: 'Archive of all your previous weekly selections.',
        ),
        for (final plan in MockData.historicalPlans as List<Map<String, dynamic>>) ...[
          GlassCard(
            padding: EdgeInsets.zero,
            radius: 28,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  color: OsColors.muted.withValues(alpha: 0.05),
                  child: Row(
                    children: [
                      const IconBubble(icon: Icons.history, color: OsColors.muted, size: 40),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Week of ${plan['weekStartDate']}',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const Text('ARCHIVED', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: OsColors.muted)),
                          ],
                        ),
                      ),
                      const Icon(Icons.copy, size: 18, color: OsColors.blue),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (final s in plan['selections'] as List)
                          () {
                            final sel = s as Map<String, dynamic>;
                            final mainId = sel['mainId'] as String?;
                            return Container(
                              width: 120,
                              margin: const EdgeInsets.only(right: 12),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.4),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: OsColors.muted.withValues(alpha: 0.1)),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    (sel['day'] as String).substring(0, 3).toUpperCase(),
                                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: OsColors.muted),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    getMeal(mainId)?['name'] as String? ?? 'None',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            );
                          }(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
        const SizedBox(height: 100),
      ],
    );
  }
}

class _MealLibrary extends StatelessWidget {
  const _MealLibrary({super.key});
  @override
  Widget build(BuildContext context) {
    return ScrollableSection(
      children: [
        const SectionHeader(
          title: 'Meal Library',
          subtitle: 'Standard recipes and nutritional guidelines.',
        ),
        const Text('MAINS', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: OsColors.muted, letterSpacing: 1.2)),
        const SizedBox(height: 12),
        for (final m in MockData.mains as List<Map<String, dynamic>>) ...[
          StatusCard(
            icon: Icons.restaurant_menu_rounded,
            color: OsColors.orange,
            title: m['name'] as String,
            subtitle: 'Popularity: ${m['popularity']}',
            trailing: const Icon(Icons.chevron_right_rounded, color: OsColors.muted),
          ),
          const SizedBox(height: 12),
        ],
        const SizedBox(height: 24),
        const Text('SIDES', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: OsColors.muted, letterSpacing: 1.2)),
        const SizedBox(height: 12),
        for (final s in MockData.sides as List<Map<String, dynamic>>) ...[
          StatusCard(
            icon: Icons.flatware_rounded,
            color: OsColors.green,
            title: s['name'] as String,
            subtitle: 'Popularity: ${s['popularity']}',
            trailing: const Icon(Icons.chevron_right_rounded, color: OsColors.muted),
          ),
          const SizedBox(height: 12),
        ],
        const SizedBox(height: 100),
      ],
    );
  }
}

class _TeamMeals extends StatelessWidget {
  const _TeamMeals({super.key});
  Map<String, dynamic>? getMeal(String? id) {
    if (id == null) return null;
    try {
      if (id.startsWith('m')) {
        return (MockData.mains as List<Map<String, dynamic>>).firstWhere((m) => m['id'] == id);
      } else {
        return (MockData.sides as List<Map<String, dynamic>>).firstWhere((s) => s['id'] == id);
      }
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScrollableSection(
      children: [
        const SectionHeader(
          title: 'Team Selections',
          subtitle: 'Real-time submission status for all employees.',
        ),
        for (final t in MockData.teamMeals as List<Map<String, dynamic>>) ...[
          StatusCard(
            icon: Icons.person_outline_rounded,
            color: t['status'] == 'Submitted' ? OsColors.green : OsColors.orange,
            title: t['name'] as String,
            subtitle: '${t['day']} - ${getMeal(t['mainId'] as String?)?['name']} + ${getMeal(t['sideId'] as String?)?['name']}',
            trailing: BadgeLabel(
              label: t['status'] as String,
              color: t['status'] == 'Submitted' ? OsColors.green : OsColors.orange,
            ),
          ),
          const SizedBox(height: 12),
        ],
        const SizedBox(height: 100),
      ],
    );
  }
}

class _MealSettings extends StatelessWidget {
  const _MealSettings({super.key});
  @override
  Widget build(BuildContext context) {
    return ScrollableSection(
      children: [
        const SectionHeader(
          title: 'Preferences',
          subtitle: 'Manage your dietary profile.',
        ),
        const GlassCard(
          padding: EdgeInsets.all(18),
          child: Column(
            children: [
              InfoRow(
                label: 'Dietary Type',
                value: 'Non-Vegetarian',
                trailing: Icon(Icons.edit_outlined, size: 18, color: OsColors.blue),
              ),
              Divider(color: OsColors.line, height: 24),
              InfoRow(
                label: 'Allergies',
                value: 'None reported',
                trailing: Icon(Icons.add_circle_outline_rounded, size: 18, color: OsColors.blue),
              ),
              Divider(color: OsColors.line, height: 24),
              InfoRow(
                label: 'Auto-Selection',
                value: 'Disabled',
                trailing: Icon(Icons.toggle_off_outlined, size: 24, color: OsColors.muted),
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        Text('Quick actions', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        const Column(
          children: [
            StatusCard(
              icon: Icons.notifications_active_outlined,
              color: OsColors.blue,
              title: 'Reminders',
              subtitle: 'Daily 10:00 AM selection nudge',
            ),
            SizedBox(height: 12),
            StatusCard(
              icon: Icons.no_food_outlined,
              color: OsColors.red,
              title: 'Dietary controls',
              subtitle: 'Vegetarian, gluten-free and allergy tags',
            ),
          ],
        ),
      ],
    );
  }
}
