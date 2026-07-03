import 'package:flutter/material.dart';
import '../../../domain/entities/weather.dart';
import '../../../../../../themes/app_colors.dart';
import '../../../../../../themes/text_styles.dart';
import '../../../../../../themes/app_spacing.dart';

class WeatherCard extends StatelessWidget {
  final Weather weather;
  const WeatherCard({super.key, required this.weather});

  Color _aqiColor(int aqi) {
    if (aqi <= 50) return AppColors.accent;
    if (aqi <= 100) return AppColors.warning;
    return AppColors.emergency;
  }

  String _aqiLabel(int aqi) {
    if (aqi <= 50) return 'Good';
    if (aqi <= 100) return 'Moderate';
    return 'Unhealthy';
  }

  IconData _weatherIcon(String condition) {
    final lower = condition.toLowerCase();
    if (lower.contains('sun') || lower.contains('clear')) {
      return Icons.wb_sunny_rounded;
    }
    if (lower.contains('cloud')) return Icons.cloud_rounded;
    if (lower.contains('rain')) return Icons.water_drop_rounded;
    if (lower.contains('snow')) return Icons.ac_unit_rounded;
    return Icons.wb_cloudy_rounded;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A3A6E), Color(0xFF0F2A54)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.2),
        ),
        boxShadow: AppColors.shadowCard,
      ),
      child: Stack(
        children: [
          // Background decorative circles
          Positioned(
            right: -20,
            top: -20,
            child: Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(alpha: 0.08),
              ),
            ),
          ),
          Positioned(
            right: 30,
            bottom: -30,
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(alpha: 0.06),
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(AppSpacing.cardPaddingLg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Location row
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_rounded,
                      color: AppColors.primaryLight,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      weather.location,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.primaryLight,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Temperature
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${weather.temperature.toStringAsFixed(0)}°',
                          style: AppTextStyles.temperature,
                        ),
                        Text(
                          weather.condition,
                          style: AppTextStyles.titleSmall.copyWith(
                            color: AppColors.primaryLight,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    // Weather icon + stats
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Icon(
                          _weatherIcon(weather.condition),
                          size: 40,
                          color: AppColors.primaryLight,
                        ),
                        const SizedBox(height: 12),
                        // AQI badge
                        _StatBadge(
                          label: 'AQI ${weather.aqi}',
                          sublabel: _aqiLabel(weather.aqi),
                          color: _aqiColor(weather.aqi),
                          icon: Icons.air_rounded,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                // Bottom stats row
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.08),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _WeatherStat(
                        icon: Icons.water_drop_outlined,
                        label: '${weather.humidity}%',
                        sublabel: 'Humidity',
                      ),
                      Container(
                        width: 1,
                        height: 30,
                        color: Colors.white.withValues(alpha: 0.12),
                      ),
                      _WeatherStat(
                        icon: Icons.thermostat_outlined,
                        label: 'Feels ${(weather.temperature - 2).toStringAsFixed(0)}°',
                        sublabel: 'Feels Like',
                      ),
                      Container(
                        width: 1,
                        height: 30,
                        color: Colors.white.withValues(alpha: 0.12),
                      ),
                      _WeatherStat(
                        icon: Icons.health_and_safety_outlined,
                        label: _aqiLabel(weather.aqi),
                        sublabel: 'Air Quality',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WeatherStat extends StatelessWidget {
  const _WeatherStat({
    required this.icon,
    required this.label,
    required this.sublabel,
  });

  final IconData icon;
  final String label;
  final String sublabel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primaryLight, size: 14),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTextStyles.titleSmall.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        Text(
          sublabel,
          style: AppTextStyles.caption,
        ),
      ],
    );
  }
}

class _StatBadge extends StatelessWidget {
  const _StatBadge({
    required this.label,
    required this.sublabel,
    required this.color,
    required this.icon,
  });

  final String label;
  final String sublabel;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 12),
          const SizedBox(width: 4),
          Text(
            '$label · $sublabel',
            style: AppTextStyles.caption.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
