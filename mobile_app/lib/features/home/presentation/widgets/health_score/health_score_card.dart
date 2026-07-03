import 'package:flutter/material.dart';
import '../../../domain/entities/health_score.dart';
import '../../../../../../themes/app_colors.dart';
import '../../../../../../themes/text_styles.dart';
import '../../../../../../themes/app_spacing.dart';

class HealthScoreCard extends StatefulWidget {
  final HealthScore healthScore;
  const HealthScoreCard({super.key, required this.healthScore});

  @override
  State<HealthScoreCard> createState() => _HealthScoreCardState();
}

class _HealthScoreCardState extends State<HealthScoreCard>
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
      end: widget.healthScore.score / 100,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _scoreColor(int score) {
    if (score >= 80) return AppColors.accent;
    if (score >= 60) return AppColors.warning;
    return AppColors.emergency;
  }

  @override
  Widget build(BuildContext context) {
    final color = _scoreColor(widget.healthScore.score);

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      padding: const EdgeInsets.all(AppSpacing.cardPaddingLg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        border: Border.all(color: AppColors.border),
        boxShadow: AppColors.shadowCard,
      ),
      child: Row(
        children: [
          // Animated circular score gauge
          SizedBox(
            width: 80,
            height: 80,
            child: AnimatedBuilder(
              animation: _progressAnim,
              builder: (_, __) => Stack(
                fit: StackFit.expand,
                children: [
                  CircularProgressIndicator(
                    value: _progressAnim.value,
                    strokeWidth: 7,
                    backgroundColor:
                        AppColors.surfaceVariant,
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                    strokeCap: StrokeCap.round,
                  ),
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${(widget.healthScore.score * _progressAnim.value).round()}',
                          style: AppTextStyles.scoreMedium.copyWith(
                            color: color,
                          ),
                        ),
                        Text(
                          'Score',
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Health Score',
                      style: AppTextStyles.titleMedium,
                    ),
                    const SizedBox(width: 8),
                    // AI badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(
                          AppSpacing.radiusFull,
                        ),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.25),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.auto_awesome_rounded,
                            size: 10,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            'AI',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                // Status chip
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                  ),
                  child: Text(
                    widget.healthScore.status,
                    style: AppTextStyles.labelSmall.copyWith(
                      color: color,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.healthScore.description,
                  style: AppTextStyles.bodySmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
