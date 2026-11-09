import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class ScenicHeader extends StatelessWidget {
  const ScenicHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.height = 110,
    this.trailingBadge,
    this.child,
  });

  final String title;
  final String? subtitle;
  final double height;
  final Widget? trailingBadge;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final subtitleText = subtitle;

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: height),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.divider),
        boxShadow: [
          BoxShadow(
            color: AppColors.brownDark.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(19),
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(painter: _MountainLandscapePainter()),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: const TextStyle(
                                color: AppColors.brownDark,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                letterSpacing: -0.5,
                              ),
                            ),
                            if (subtitleText != null) ...[
                              const SizedBox(height: 2),
                              Text(
                                subtitleText,
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      ?trailingBadge,
                    ],
                  ),
                  ?child,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MountainLandscapePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    final skyPaint = Paint()..color = const Color(0xFFF2EAD8);
    canvas.drawRect(rect, skyPaint);

    final sunPaint = Paint()..color = const Color(0xFFD49A4B);
    canvas.drawCircle(
      Offset(size.width * 0.82, size.height * 0.38),
      size.height * 0.26,
      sunPaint,
    );

    final backMountainPaint = Paint()..color = const Color(0xFFDCD1BD);
    final backPath = Path()
      ..moveTo(0, size.height * 0.7)
      ..quadraticBezierTo(
        size.width * 0.25,
        size.height * 0.35,
        size.width * 0.5,
        size.height * 0.6,
      )
      ..quadraticBezierTo(
        size.width * 0.75,
        size.height * 0.85,
        size.width,
        size.height * 0.5,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(backPath, backMountainPaint);

    final midMountainPaint = Paint()..color = const Color(0xFF7A9A7B);
    final midPath = Path()
      ..moveTo(0, size.height * 0.8)
      ..quadraticBezierTo(
        size.width * 0.3,
        size.height * 0.55,
        size.width * 0.65,
        size.height * 0.75,
      )
      ..quadraticBezierTo(
        size.width * 0.85,
        size.height * 0.85,
        size.width,
        size.height * 0.65,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(midPath, midMountainPaint);

    final foreMountainPaint = Paint()..color = const Color(0xFF3E6241);
    final forePath = Path()
      ..moveTo(0, size.height * 0.88)
      ..quadraticBezierTo(
        size.width * 0.4,
        size.height * 0.68,
        size.width * 0.8,
        size.height * 0.9,
      )
      ..quadraticBezierTo(
        size.width * 0.92,
        size.height * 0.95,
        size.width,
        size.height * 0.82,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(forePath, foreMountainPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
