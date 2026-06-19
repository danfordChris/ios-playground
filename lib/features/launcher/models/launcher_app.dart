import 'package:flutter/material.dart';
import '../../../core/enum/workspace.dart';

class LauncherApp {
  const LauncherApp({
    required this.workspace,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.assetPath,
    this.badgeLabel,
    this.badgeIcon,
  });

  final Workspace workspace;
  final String name;
  final String description;
  final IconData icon;
  final Color color;
  final String assetPath;
  final String? badgeLabel;
  final IconData? badgeIcon;
}
