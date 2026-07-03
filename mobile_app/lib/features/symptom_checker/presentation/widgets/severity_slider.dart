import 'package:flutter/material.dart';
import '../../../../../themes/app_colors.dart';
import '../../../../../themes/text_styles.dart';
import '../../../../../themes/app_spacing.dart';

class SeveritySlider extends StatelessWidget {
  const SeveritySlider({
    required this.value,
    required this.onChanged,
    super.key,
  });

  final double value;
  final ValueChanged<double> onChanged;

  Color _severityColor(double v) {
    if (v <= 3) return AppColors.accent;
    if (v <= 6) return AppColors.warning;
    return AppColors.emergency;
  }

  String _severityLabel(double v) {
    if (v <= 3) return 'Mild';
    if (v <= 6) return 'Moderate';
    if (v <= 8) return 'Severe';
    return 'Critical';
  }

  @override
  Widget build(BuildContext context) {
    final color = _severityColor(value);
    final label = _severityLabel(value);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPaddingMd),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.border),
        boxShadow: AppColors.shadowCard,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: color.withValues(alpha: 0.25)),
                    ),
                    child: Icon(Icons.thermostat_rounded,
                        color: color, size: 18),
                  ),
                  const SizedBox(width: 10),
                  Text('Severity Level',
                      style: AppTextStyles.titleMedium),
                ],
              ),
              // Score badge
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius:
                      BorderRadius.circular(AppSpacing.radiusFull),
                  border:
                      Border.all(color: color.withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${value.round()}/10',
                      style: AppTextStyles.labelLarge
                          .copyWith(color: color),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '· $label',
                      style: AppTextStyles.caption
                          .copyWith(color: color),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: color,
              inactiveTrackColor:
                  AppColors.surfaceVariant,
              thumbColor: color,
              overlayColor: color.withValues(alpha: 0.15),
              trackHeight: 5,
              thumbShape:
                  const RoundSliderThumbShape(enabledThumbRadius: 10),
              overlayShape:
                  const RoundSliderOverlayShape(overlayRadius: 20),
              valueIndicatorColor: color,
              valueIndicatorTextStyle:
                  AppTextStyles.labelLarge.copyWith(color: Colors.white),
              showValueIndicator: ShowValueIndicator.onDrag,
            ),
            child: Slider(
              value: value,
              min: 1,
              max: 10,
              divisions: 9,
              label: value.round().toString(),
              onChanged: onChanged,
            ),
          ),
          // Severity bar labels
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                Text('Mild',
                    style: AppTextStyles.caption
                        .copyWith(color: AppColors.accent)),
                Text('Moderate',
                    style: AppTextStyles.caption
                        .copyWith(color: AppColors.warning)),
                Text('Severe',
                    style: AppTextStyles.caption
                        .copyWith(color: AppColors.emergency)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
