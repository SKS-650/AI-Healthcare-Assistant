import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controller/dashboard_state.dart';
import '../providers/dashboard_provider.dart';
import '../widgets/app_bar/dashboard_app_bar.dart';
import '../widgets/articles/article_card.dart';
import '../widgets/bottom_navigation/home_bottom_navigation.dart';
import '../widgets/common/loading_widget.dart';
import '../widgets/emergency/emergency_card.dart';
import '../widgets/health_score/health_score_card.dart';
import '../widgets/health_tips/tips_slider.dart';
import '../widgets/hospitals/hospital_card.dart';
import '../widgets/predictions/recent_prediction_card.dart';
import '../widgets/quick_actions/quick_action_grid.dart';
import '../widgets/weather/weather_card.dart';
import '../../../../../../themes/app_colors.dart';
import '../../../../../../themes/text_styles.dart';
import '../../../../../../themes/app_spacing.dart';
import '../../../../../../shared/widgets/section_header.dart';

class HomeDashboardPage extends ConsumerWidget {
  const HomeDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dashboardControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const DashboardAppBar(),
      bottomNavigationBar: const HomeBottomNavigation(),
      body: SafeArea(
        top: false,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 350),
          child: _buildBody(context, ref, state),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, WidgetRef ref, DashboardState state) {
    if (state.status == DashboardStatus.loading) {
      return const DashboardSkeletonLoader(key: ValueKey('loading'));
    }

    if (state.status == DashboardStatus.error) {
      return _ErrorView(
        key: const ValueKey('error'),
        errorMessage: state.errorMessage,
        onRetry: () =>
            ref.read(dashboardControllerProvider.notifier).loadDashboardData(),
      );
    }

    return RefreshIndicator(
      key: const ValueKey('loaded'),
      color: AppColors.primary,
      backgroundColor: AppColors.surface,
      onRefresh: () =>
          ref.read(dashboardControllerProvider.notifier).loadDashboardData(),
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppSpacing.sm),

                    // ── Weather ─────────────────────────────────────────────
                    if (state.weather != null)
                      WeatherCard(weather: state.weather!),

                    const SizedBox(height: AppSpacing.sm),

                    // ── Health Score ─────────────────────────────────────────
                    if (state.healthScore != null)
                      HealthScoreCard(healthScore: state.healthScore!),

                    const SizedBox(height: AppSpacing.xl),

                    // ── Quick Actions ────────────────────────────────────────
                    const SectionHeader(
                      title: 'Quick Actions',
                      icon: Icons.grid_view_rounded,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    QuickActionGrid(actions: state.quickActions),

                    const SizedBox(height: AppSpacing.xl),

                    // ── Emergency ────────────────────────────────────────────
                    const EmergencyCard(),

                    const SizedBox(height: AppSpacing.xl),

                    // ── Recent Diagnostics ───────────────────────────────────
                    if (state.recentPredictions.isNotEmpty) ...[
                      SectionHeader(
                        title: 'Recent Diagnostics',
                        subtitle: 'Your latest AI-powered analysis',
                        icon: Icons.analytics_rounded,
                        onSeeAll: () {},
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      RecentPredictionsList(
                          predictions: state.recentPredictions),
                      const SizedBox(height: AppSpacing.xl),
                    ],

                    // ── Daily Health Tips ────────────────────────────────────
                    if (state.healthTips.isNotEmpty) ...[
                      SectionHeader(
                        title: 'Daily Health Tips',
                        icon: Icons.lightbulb_rounded,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      TipsSlider(tips: state.healthTips),
                      const SizedBox(height: AppSpacing.xl),
                    ],

                    // ── Nearby Hospitals ─────────────────────────────────────
                    if (state.nearbyHospitals.isNotEmpty) ...[
                      SectionHeader(
                        title: 'Nearby Medical Support',
                        subtitle: 'Hospitals in your area',
                        icon: Icons.local_hospital_rounded,
                        onSeeAll: () {},
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      NearbyHospitalsList(hospitals: state.nearbyHospitals),
                      const SizedBox(height: AppSpacing.xl),
                    ],

                    // ── Articles ─────────────────────────────────────────────
                    if (state.latestArticles.isNotEmpty) ...[
                      SectionHeader(
                        title: 'Medical Intelligence',
                        subtitle: 'Curated health articles',
                        icon: Icons.library_books_rounded,
                        onSeeAll: () {},
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      LatestArticlesList(articles: state.latestArticles),
                      const SizedBox(height: AppSpacing.xl),
                    ],

                    const SizedBox(height: AppSpacing.massive),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Premium error view
class _ErrorView extends StatelessWidget {
  const _ErrorView({super.key, this.errorMessage, required this.onRetry});

  final String? errorMessage;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.emergency.withValues(alpha: 0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.emergency.withValues(alpha: 0.25),
                ),
              ),
              child: const Icon(
                Icons.wifi_off_rounded,
                size: 36,
                color: AppColors.emergency,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Connection Error',
              style: AppTextStyles.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              errorMessage ?? 'Could not load your dashboard. Please try again.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium,
            ),
            const SizedBox(height: 28),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
