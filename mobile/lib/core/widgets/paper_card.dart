import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class PaperCard extends StatelessWidget {
  const PaperCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.backgroundColor = AppColors.surface,
    this.rotation = 0,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color backgroundColor;
  final double rotation;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: rotation * 0.0174533,
      child: Stack(
        children: [
          Positioned(
            left: 5,
            top: 5,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceSecondary,
                borderRadius: BorderRadius.circular(18),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: padding,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.divider, width: 1),
              boxShadow: [
                BoxShadow(
                  color: AppColors.brown.withValues(alpha: 0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: child,
          ),
        ],
      ),
    );
  }
}
