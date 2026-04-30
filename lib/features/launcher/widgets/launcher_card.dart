import 'package:flutter/material.dart';
import '../../../core/theme/os_colors.dart';
import '../../../shared/widgets/shared_widgets.dart';
import '../models/launcher_app.dart';

class LauncherCard extends StatelessWidget {
  const LauncherCard({super.key, required this.app, required this.onTap});

  final LauncherApp app;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: onTap,
      child: GlassCard(
        padding: const EdgeInsets.all(22),
        child: Row(
          children: [
            IconBubble(icon: app.icon, color: app.color, size: 64),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    app.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    app.description,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: OsColors.muted),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_rounded, color: OsColors.blue),
          ],
        ),
      ),
    );
  }
}
