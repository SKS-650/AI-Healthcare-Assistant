import 'package:flutter/material.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_spacing.dart';

/// Animated shimmer skeleton box
class ShimmerBox extends StatefulWidget {
  const ShimmerBox({
    super.key,
    this.width,
    this.height = 16,
    this.borderRadius = AppSpacing.radiusMd,
  });

  final double? width;
  final double height;
  final double borderRadius;

  @override
  State<ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<ShimmerBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
    _animation = Tween<double>(begin: -2, end: 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, __) => Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          gradient: LinearGradient(
            begin: Alignment(_animation.value - 1, 0),
            end: Alignment(_animation.value + 1, 0),
            colors: const [
              AppColors.surfaceVariant,
              AppColors.border,
              AppColors.surfaceVariant,
            ],
          ),
        ),
      ),
    );
  }
}

/// Full dashboard skeleton loader
class DashboardSkeletonLoader extends StatelessWidget {
  const DashboardSkeletonLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Weather card skeleton
          const ShimmerBox(height: 120, borderRadius: AppSpacing.radiusLg),
          const SizedBox(height: 12),
          // Health score
          const ShimmerBox(height: 100, borderRadius: AppSpacing.radiusLg),
          const SizedBox(height: 20),
          // Section title
          const ShimmerBox(width: 140, height: 14),
          const SizedBox(height: 16),
          // Quick actions grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 16,
              crossAxisSpacing: 12,
              childAspectRatio: 0.82,
            ),
            itemCount: 8,
            itemBuilder: (_, __) => const Column(
              children: [
                ShimmerBox(
                  width: 56,
                  height: 56,
                  borderRadius: 28,
                ),
                SizedBox(height: 8),
                ShimmerBox(width: 44, height: 10),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Emergency card
          const ShimmerBox(height: 80, borderRadius: AppSpacing.radiusLg),
          const SizedBox(height: 20),
          // Section title
          const ShimmerBox(width: 180, height: 14),
          const SizedBox(height: 12),
          // Prediction cards
          const ShimmerBox(height: 90, borderRadius: AppSpacing.radiusLg),
          const SizedBox(height: 10),
          const ShimmerBox(height: 90, borderRadius: AppSpacing.radiusLg),
        ],
      ),
    );
  }
}
