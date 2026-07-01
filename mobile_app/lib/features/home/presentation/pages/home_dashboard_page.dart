import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controller/dashboard_state.dart';
import '../providers/dashboard_provider.dart';
import '../widgets/app_bar/dashboard_app_bar.dart';
import '../widgets/articles/article_card.dart';
import '../widgets/bottom_navigation/home_bottom_navigation.dart';
import '../widgets/common/loading_widget.dart';
import '../widgets/common/section_title.dart';
import '../widgets/emergency/emergency_card.dart';
import '../widgets/health_score/health_score_card.dart';
import '../widgets/health_tips/tips_slider.dart';
import '../widgets/hospitals/hospital_card.dart';
import '../widgets/predictions/recent_prediction_card.dart';
import '../widgets/quick_actions/quick_action_grid.dart';
import '../widgets/weather/weather_card.dart';

class HomeDashboardPage extends ConsumerWidget {
  const HomeDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dashboardControllerProvider);

    return Scaffold(
      appBar: const DashboardAppBar(),
      bottomNavigationBar: const HomeBottomNavigation(),
      body: SafeArea(
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
      return Center(
        key: const ValueKey('error'),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.wifi_off_rounded, size: 48, color: Colors.grey),
              const SizedBox(height: 12),
              Text(
                'We could not load your dashboard right now.',
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                state.errorMessage ?? 'Please try again in a moment.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () => ref.read(dashboardControllerProvider.notifier).loadDashboardData(),
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      key: const ValueKey('loaded'),
      onRefresh: () => ref.read(dashboardControllerProvider.notifier).loadDashboardData(),
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
                    if (state.weather != null) WeatherCard(weather: state.weather!),
                    if (state.healthScore != null) HealthScoreCard(healthScore: state.healthScore!),
                    const SectionTitle(title: 'Quick Actions'),
                    QuickActionGrid(actions: state.quickActions),
                    const EmergencyCard(),
                    if (state.recentPredictions.isNotEmpty) ...[
                      const SectionTitle(title: 'Recent Diagnostic Profiles'),
                      RecentPredictionsList(predictions: state.recentPredictions),
                    ],
                    if (state.healthTips.isNotEmpty) ...[
                      const SectionTitle(title: 'Daily Health Optimization'),
                      TipsSlider(tips: state.healthTips),
                    ],
                    if (state.nearbyHospitals.isNotEmpty) ...[
                      const SectionTitle(title: 'Nearby Medical Support'),
                      NearbyHospitalsList(hospitals: state.nearbyHospitals),
                    ],
                    if (state.latestArticles.isNotEmpty) ...[
                      const SectionTitle(title: 'Curated Medical Intelligence'),
                      LatestArticlesList(articles: state.latestArticles),
                    ],
                    const SizedBox(height: 24),
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