import 'package:flutter/material.dart';

import '../../../../constants/app_strings.dart';
import '../controllers/prediction_controller.dart';
import '../widgets/prediction_card.dart';
import '../../../../../themes/app_colors.dart';
import '../../../../../themes/text_styles.dart';
import '../../../../../themes/app_spacing.dart';
import '../../../../../shared/widgets/shimmer_loader.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late final PredictionController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PredictionController()..loadHistory();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: CustomScrollView(
            slivers: [
              // ── SliverAppBar ─────────────────────────────────────────
              SliverAppBar(
                pinned: true,
                expandedHeight: 120,
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
                        size: 18,
                        color: AppColors.textPrimary),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    color: AppColors.background,
                    padding: const EdgeInsets.fromLTRB(
                        20, 90, 20, 14),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Text(AppStrings.history,
                                style: AppTextStyles
                                    .headlineLarge),
                            const SizedBox(width: 10),
                            if (!_controller.isLoading &&
                                _controller.history.isNotEmpty)
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.primary
                                      .withValues(alpha: 0.15),
                                  borderRadius:
                                      BorderRadius.circular(20),
                                  border: Border.all(
                                      color: AppColors.primary
                                          .withValues(
                                              alpha: 0.3)),
                                ),
                                child: Text(
                                  '${_controller.history.length} records',
                                  style: AppTextStyles.caption
                                      .copyWith(
                                          color:
                                              AppColors.primary,
                                          fontWeight:
                                              FontWeight.w700),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ── Content ──────────────────────────────────────────────
              if (_controller.isLoading)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: List.generate(
                          3,
                          (_) => Padding(
                                padding:
                                    const EdgeInsets.only(
                                        bottom: 14),
                                child: ShimmerBox(
                                    height: 180,
                                    borderRadius:
                                        AppSpacing.radiusXl),
                              )),
                    ),
                  ),
                )
              else if (_controller.history.isEmpty)
                const SliverFillRemaining(
                  child: _EmptyHistoryState(),
                )
              else
                SliverPadding(
                  padding:
                      const EdgeInsets.fromLTRB(20, 4, 20, 40),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return Padding(
                          padding:
                              const EdgeInsets.only(bottom: 16),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              // Date separator
                              _DateChip(
                                  date: _controller
                                      .history[index].createdAt),
                              const SizedBox(height: 10),
                              PredictionCard(
                                  prediction: _controller
                                      .history[index]),
                            ],
                          ),
                        );
                      },
                      childCount: _controller.history.length,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _DateChip extends StatelessWidget {
  const _DateChip({required this.date});
  final DateTime date;

  String _formatDate(DateTime d) {
    final now = DateTime.now();
    final diff = now.difference(d);
    if (diff.inDays == 0) return 'Today';
    if (diff.inDays == 1) return 'Yesterday';
    return '${d.day}/${d.month}/${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.calendar_today_rounded,
              size: 11, color: AppColors.textTertiary),
          const SizedBox(width: 5),
          Text(_formatDate(date), style: AppTextStyles.caption),
        ],
      ),
    );
  }
}

class _EmptyHistoryState extends StatelessWidget {
  const _EmptyHistoryState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(26),
                border: Border.all(color: AppColors.border),
              ),
              child: const Icon(Icons.history_rounded,
                  size: 42, color: AppColors.textTertiary),
            ),
            const SizedBox(height: 20),
            Text('No Predictions Yet',
                style: AppTextStyles.headlineMedium,
                textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(
              'Run a symptom check to see your AI-powered diagnosis history here.',
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
