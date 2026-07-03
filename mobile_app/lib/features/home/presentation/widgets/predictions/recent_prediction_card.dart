import 'package:flutter/material.dart';
import '../../../domain/entities/prediction.dart';
import '../../../../../../routing/route_names.dart';
import '../../../../../../themes/app_colors.dart';
import '../../../../../../themes/text_styles.dart';
import '../../../../../../themes/app_spacing.dart';
import '../../../../../../shared/widgets/animated_press.dart';

class RecentPredictionsList extends StatelessWidget {
  final List<Prediction> predictions;
  const RecentPredictionsList({super.key, required this.predictions});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      itemCount: predictions.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final item = predictions[index];
        return _PredictionCard(prediction: item, index: index);
      },
    );
  }
}

class _PredictionCard extends StatefulWidget {
  const _PredictionCard({required this.prediction, required this.index});
  final Prediction prediction;
  final int index;

  @override
  State<_PredictionCard> createState() => _PredictionCardState();
}

class _PredictionCardState extends State<_PredictionCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.25),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    Future.delayed(Duration(milliseconds: 100 * widget.index), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pct = (widget.prediction.confidence * 100).toStringAsFixed(0);
    final int score = int.tryParse(pct) ?? 0;

    Color scoreColor;
    if (score >= 80) {
      scoreColor = AppColors.emergency;
    } else if (score >= 60) {
      scoreColor = AppColors.warning;
    } else {
      scoreColor = AppColors.accent;
    }

    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: AnimatedPress(
          onTap: () => Navigator.of(context)
              .pushNamed(RouteNames.records),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.cardPaddingMd),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
              border: Border.all(color: AppColors.border),
              boxShadow: AppColors.shadowCard,
            ),
            child: Row(
              children: [
                // Icon container
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: scoreColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: scoreColor.withValues(alpha: 0.25),
                    ),
                  ),
                  child: Icon(
                    Icons.biotech_rounded,
                    color: scoreColor,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.prediction.diseaseName,
                        style: AppTextStyles.titleMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      // Progress bar
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: widget.prediction.confidence,
                          backgroundColor:
                              AppColors.surfaceVariant,
                          valueColor: AlwaysStoppedAnimation<Color>(scoreColor),
                          minHeight: 4,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${widget.prediction.date.day}/${widget.prediction.date.month}/${widget.prediction.date.year}',
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // Confidence badge
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: scoreColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(
                          AppSpacing.radiusFull,
                        ),
                        border: Border.all(
                          color: scoreColor.withValues(alpha: 0.25),
                        ),
                      ),
                      child: Text(
                        '$pct%',
                        style: AppTextStyles.labelLarge.copyWith(
                          color: scoreColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text('Match', style: AppTextStyles.caption),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
