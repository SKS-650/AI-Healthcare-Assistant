import 'package:flutter/material.dart';
import '../../domain/entities/symptom.dart';
import '../../../../../themes/app_colors.dart';
import '../../../../../themes/text_styles.dart';
import '../../../../../themes/app_spacing.dart';
import '../../../../../shared/widgets/animated_press.dart';

class SymptomCard extends StatelessWidget {
  const SymptomCard({
    required this.symptom,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  final Symptom symptom;
  final bool isSelected;
  final VoidCallback onTap;

  Color _categoryColor(String category) {
    return switch (category.toLowerCase()) {
      'general' => AppColors.accent,
      'respiratory' => AppColors.primary,
      'neurological' => const Color(0xFF8B5CF6),
      'emergency' => AppColors.emergency,
      _ => AppColors.primary,
    };
  }

  IconData _categoryIcon(String category) {
    return switch (category.toLowerCase()) {
      'general' => Icons.thermostat_rounded,
      'respiratory' => Icons.air_rounded,
      'neurological' => Icons.psychology_rounded,
      'emergency' => Icons.emergency_rounded,
      _ => Icons.medical_services_rounded,
    };
  }

  @override
  Widget build(BuildContext context) {
    final catColor = _categoryColor(symptom.category);

    return AnimatedPress(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(AppSpacing.cardPaddingMd),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.12)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          border: Border.all(
            color: isSelected
                ? AppColors.primary.withValues(alpha: 0.5)
                : AppColors.border,
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: isSelected
              ? AppColors.shadowPrimary
              : AppColors.shadowCard,
        ),
        child: Row(
          children: [
            // Icon
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary.withValues(alpha: 0.2)
                    : catColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary.withValues(alpha: 0.4)
                      : catColor.withValues(alpha: 0.25),
                ),
              ),
              child: Icon(
                _categoryIcon(symptom.category),
                color: isSelected ? AppColors.primary : catColor,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    symptom.name,
                    style: AppTextStyles.titleMedium.copyWith(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    symptom.description,
                    style: AppTextStyles.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Category badge
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: catColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                  ),
                  child: Text(
                    symptom.category,
                    style: AppTextStyles.caption.copyWith(
                      color: catColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.surfaceVariant,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.border,
                    ),
                  ),
                  child: Icon(
                    isSelected ? Icons.check_rounded : Icons.add_rounded,
                    color: isSelected
                        ? Colors.white
                        : AppColors.textTertiary,
                    size: 13,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
