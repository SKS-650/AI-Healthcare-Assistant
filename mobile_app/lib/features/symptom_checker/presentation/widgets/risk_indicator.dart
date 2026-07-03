import 'package:flutter/material.dart';
import '../../domain/entities/prediction.dart';
import '../../../../../themes/app_colors.dart';
import '../../../../../themes/text_styles.dart';
import '../../../../../themes/app_spacing.dart';

class RiskIndicator extends StatelessWidget {
  const RiskIndicator({required this.riskLevel, super.key});

  final RiskLevel riskLevel;

  @override
  Widget build(BuildContext context) {
    final (label, color, icon) = switch (riskLevel) {
      RiskLevel.low => (
          'Low Risk',
          AppColors.accent,
          Icons.check_circle_rounded,
        ),
      RiskLevel.moderate => (
          'Moderate Risk',
          AppColors.warning,
          Icons.warning_amber_rounded,
        ),
      RiskLevel.high => (
          'High Risk',
          AppColors.emergency,
          Icons.gpp_bad_rounded,
        ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 5),
          Text(
            label,
            style: AppTextStyles.labelMedium.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
