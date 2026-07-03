import 'package:flutter/material.dart';
import '../../domain/entities/prediction.dart';
import 'risk_indicator.dart';
import '../../../../../themes/app_colors.dart';
import '../../../../../themes/text_styles.dart';
import '../../../../../themes/app_spacing.dart';

class PredictionCard extends StatefulWidget {
  const PredictionCard({required this.prediction, super.key});

  final Prediction prediction;

  @override
  State<PredictionCard> createState() => _PredictionCardState();
}

class _PredictionCardState extends State<PredictionCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _progressAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _progressAnim = Tween<double>(
      begin: 0,
      end: widget.prediction.confidence,
    ).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _riskColor(RiskLevel level) => switch (level) {
        RiskLevel.low => AppColors.accent,
        RiskLevel.moderate => AppColors.warning,
        RiskLevel.high => AppColors.emergency,
      };

  @override
  Widget build(BuildContext context) {
    final color = _riskColor(widget.prediction.riskLevel);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        border: Border.all(color: color.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.12),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header gradient banner ───────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(AppSpacing.cardPaddingLg),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  color.withValues(alpha: 0.18),
                  color.withValues(alpha: 0.04),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppSpacing.radiusXl)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                            color: color.withValues(alpha: 0.3)),
                      ),
                      child: Icon(Icons.biotech_rounded,
                          color: color, size: 24),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text('AI Diagnosis',
                              style: AppTextStyles.caption.copyWith(
                                  color: color,
                                  letterSpacing: 0.8,
                                  fontWeight: FontWeight.w600)),
                          Text(widget.prediction.condition,
                              style: AppTextStyles.headlineSmall,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                    RiskIndicator(
                        riskLevel: widget.prediction.riskLevel),
                  ],
                ),
              ],
            ),
          ),

          // ── Body ────────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(AppSpacing.cardPaddingLg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Confidence meter
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Confidence Level',
                        style: AppTextStyles.titleSmall),
                    AnimatedBuilder(
                      animation: _progressAnim,
                      builder: (_, __) => Text(
                        '${(_progressAnim.value * 100).round()}%',
                        style: AppTextStyles.titleSmall
                            .copyWith(color: color),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                AnimatedBuilder(
                  animation: _progressAnim,
                  builder: (_, __) => ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: _progressAnim.value,
                      backgroundColor: AppColors.surfaceVariant,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(color),
                      minHeight: 8,
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                const Divider(
                    color: AppColors.border, height: 1),
                const SizedBox(height: 20),

                // Recommendation
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: AppColors.primary
                            .withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                          Icons.recommend_rounded,
                          color: AppColors.primary,
                          size: 18),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text('Recommendation',
                              style: AppTextStyles.titleSmall
                                  .copyWith(
                                      color: AppColors.primary)),
                          const SizedBox(height: 4),
                          Text(widget.prediction.recommendation,
                              style: AppTextStyles.bodyMedium),
                        ],
                      ),
                    ),
                  ],
                ),

                // Matched symptoms chips
                if (widget.prediction.matchedSymptoms
                    .isNotEmpty) ...[
                  const SizedBox(height: 20),
                  const Divider(
                      color: AppColors.border, height: 1),
                  const SizedBox(height: 16),
                  Text('Matched Symptoms',
                      style: AppTextStyles.titleSmall),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: widget.prediction.matchedSymptoms
                        .map((s) => _SymptomChip(symptom: s))
                        .toList(),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SymptomChip extends StatelessWidget {
  const _SymptomChip({required this.symptom});
  final String symptom;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius:
            BorderRadius.circular(AppSpacing.radiusFull),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.circle,
              size: 6, color: AppColors.primary),
          const SizedBox(width: 6),
          Text(symptom,
              style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
