import 'package:flutter/material.dart';

import '../../../../constants/app_strings.dart';
import '../../domain/entities/prediction.dart';
import '../widgets/prediction_card.dart';
import '../../../../../themes/app_colors.dart';
import '../../../../../themes/text_styles.dart';
import '../../../../../themes/app_spacing.dart';
import '../../../../../shared/widgets/animated_press.dart';

class PredictionPage extends StatelessWidget {
  const PredictionPage({required this.prediction, super.key});

  final Prediction prediction;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ── Premium SliverAppBar ──────────────────────────────────────
          SliverAppBar(
            pinned: true,
            backgroundColor: AppColors.background,
            foregroundColor: AppColors.textPrimary,
            elevation: 0,
            scrolledUnderElevation: 0,
            leading: IconButton(
              icon: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.border),
                ),
                child: const Icon(Icons.arrow_back_rounded,
                    size: 18, color: AppColors.textPrimary),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(AppStrings.prediction,
                style: AppTextStyles.titleLarge),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: const Icon(Icons.share_outlined,
                      size: 18, color: AppColors.textPrimary),
                ),
              ),
            ],
          ),

          // ── Body ────────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Timestamp row
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 9),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius:
                          BorderRadius.circular(AppSpacing.radiusMd),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.schedule_rounded,
                            size: 14,
                            color: AppColors.textTertiary),
                        const SizedBox(width: 6),
                        Text(
                          'Analyzed on ${prediction.createdAt.day}/${prediction.createdAt.month}/${prediction.createdAt.year} at ${prediction.createdAt.hour.toString().padLeft(2, '0')}:${prediction.createdAt.minute.toString().padLeft(2, '0')}',
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Main prediction card
                  PredictionCard(prediction: prediction),

                  const SizedBox(height: 16),

                  // Disclaimer card
                  Container(
                    padding:
                        const EdgeInsets.all(AppSpacing.cardPaddingMd),
                    decoration: BoxDecoration(
                      color: AppColors.warning
                          .withValues(alpha: 0.06),
                      borderRadius:
                          BorderRadius.circular(AppSpacing.radiusLg),
                      border: Border.all(
                          color: AppColors.warning
                              .withValues(alpha: 0.2)),
                    ),
                    child: Row(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        const Icon(
                            Icons.info_outline_rounded,
                            color: AppColors.warning,
                            size: 18),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'This result is AI-assisted educational support only and is not a medical diagnosis. Always consult a licensed healthcare professional.',
                            style: AppTextStyles.bodySmall
                                .copyWith(
                                    color: AppColors.warning
                                        .withValues(
                                            alpha: 0.85)),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Action buttons row
                  Row(
                    children: [
                      Expanded(
                        child: AnimatedPress(
                          onTap: () =>
                              Navigator.of(context).pop(),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 15),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius:
                                  BorderRadius.circular(
                                      AppSpacing.radiusFull),
                              border: Border.all(
                                  color: AppColors.border),
                            ),
                            child: Center(
                              child: Text('New Check',
                                  style: AppTextStyles.titleSmall
                                      .copyWith(
                                          color:
                                              AppColors.textSecondary)),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: AnimatedPress(
                          onTap: () {},
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 15),
                            decoration: BoxDecoration(
                              gradient:
                                  AppColors.gradientPrimary,
                              borderRadius:
                                  BorderRadius.circular(
                                      AppSpacing.radiusFull),
                              boxShadow:
                                  AppColors.shadowPrimary,
                            ),
                            child: Center(
                              child: Row(
                                mainAxisSize:
                                    MainAxisSize.min,
                                children: [
                                  const Icon(
                                      Icons
                                          .local_hospital_rounded,
                                      color: Colors.white,
                                      size: 16),
                                  const SizedBox(width: 8),
                                  Text('Find a Doctor',
                                      style: AppTextStyles
                                          .titleSmall
                                          .copyWith(
                                              color:
                                                  Colors.white)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
