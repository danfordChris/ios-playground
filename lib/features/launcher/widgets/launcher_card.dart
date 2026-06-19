import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/theme/os_colors.dart';
import '../models/launcher_app.dart';

class LauncherCard extends StatelessWidget {
  const LauncherCard({
    super.key,
    required this.app,
    required this.onTap,
  });

  final LauncherApp app;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final radius = 30.0;

    return SizedBox(
      child: Material(
        color: Colors.transparent,
        child: InkWell(

          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.74),
              borderRadius: BorderRadius.circular(radius),
              border: Border.all(
                color: app.badgeLabel == null
                    ? app.color.withValues(alpha: 0.14)
                    : OsColors.orange.withValues(alpha: 0.22),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 28,
                  offset: const Offset(0, 16),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                // vertical: compact ? 16 : 20,
              ),
              child: Column(
                children: [
                  _IconBadge(
                    color: app.color,
                    assetPath: app.assetPath,
                    // size: iconSize,
                  ),
                  Text(
                    app.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium
                        ?.copyWith(

                      color: OsColors.ink,
                    ),
                  ),
                  // Expanded(
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: [
                  //       Text(
                  //         app.name,
                  //         maxLines: 1,
                  //         overflow: TextOverflow.ellipsis,
                  //         style: Theme.of(context).textTheme.titleMedium
                  //             ?.copyWith(
                  //               fontSize: compact ? 21 : 23,
                  //               fontWeight: FontWeight.w800,
                  //               color: OsColors.ink,
                  //             ),
                  //       ),
                  //       const SizedBox(height: 8),
                  //       Text(
                  //         app.description,
                  //         maxLines: 2,
                  //         overflow: TextOverflow.ellipsis,
                  //         style: Theme.of(context).textTheme.bodyMedium
                  //             ?.copyWith(
                  //               color: OsColors.muted,
                  //               fontSize: compact ? 14 : 15,
                  //               height: 1.25,
                  //             ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  const SizedBox(width: 14),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _IconBadge extends StatelessWidget {
  const _IconBadge({
    required this.color,
    required this.assetPath,
    // required this.size,
  });

  final Color color;
  final String assetPath;
  // final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: SvgPicture.asset(
        assetPath,
        // width: size,
        // height: size ,
        fit: BoxFit.cover,
      ),
    );
  }
}
