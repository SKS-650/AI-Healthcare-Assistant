import 'package:flutter/material.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_spacing.dart';

/// Premium glassmorphism-inspired card with soft shadow and border
class PremiumCard extends StatelessWidget {
  const PremiumCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.gradient,
    this.borderRadius,
    this.border,
    this.shadows,
    this.color,
    this.onTap,
    this.clipBehavior = Clip.antiAlias,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Gradient? gradient;
  final BorderRadiusGeometry? borderRadius;
  final BoxBorder? border;
  final List<BoxShadow>? shadows;
  final Color? color;
  final VoidCallback? onTap;
  final Clip clipBehavior;

  @override
  Widget build(BuildContext context) {
    final effectiveBorderRadius =
        borderRadius ?? BorderRadius.circular(AppSpacing.radiusLg);

    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: effectiveBorderRadius as BorderRadius?,
          splashColor: AppColors.primary.withValues(alpha: 0.08),
          highlightColor: AppColors.primary.withValues(alpha: 0.04),
          child: Ink(
            decoration: BoxDecoration(
              color: gradient == null ? (color ?? AppColors.surface) : null,
              gradient: gradient,
              borderRadius: effectiveBorderRadius,
              border: border ??
                  Border.all(color: AppColors.border, width: 1),
              boxShadow: shadows ?? AppColors.shadowCard,
            ),
            child: ClipRRect(
              borderRadius: effectiveBorderRadius as BorderRadius,
              child: Padding(
                padding: padding ??
                    const EdgeInsets.all(AppSpacing.cardPaddingMd),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Gradient card wrapper
class GradientCard extends StatelessWidget {
  const GradientCard({
    super.key,
    required this.child,
    required this.gradient,
    this.padding,
    this.margin,
    this.borderRadius,
    this.onTap,
    this.shadows,
  });

  final Widget child;
  final Gradient gradient;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;
  final List<BoxShadow>? shadows;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      gradient: gradient,
      padding: padding,
      margin: margin,
      borderRadius: borderRadius,
      border: Border.all(color: Colors.transparent),
      shadows: shadows ?? AppColors.shadowCard,
      onTap: onTap,
      child: child,
    );
  }
}
