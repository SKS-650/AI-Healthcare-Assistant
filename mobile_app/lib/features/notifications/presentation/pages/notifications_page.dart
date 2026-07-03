import 'package:flutter/material.dart';
import '../../../../../themes/app_colors.dart';
import '../../../../../themes/text_styles.dart';
import '../../../../../themes/app_spacing.dart';
import '../../../../../shared/widgets/animated_press.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});
  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final List<_Notification> _notifications = [
    _Notification('High Risk Alert', 'Your recent symptom check shows high fever risk. Please consult a doctor.', '2 min ago', Icons.gpp_bad_rounded, AppColors.emergency, false),
    _Notification('Medication Reminder', 'Time to take your Paracetamol 500mg – 1 tablet.', '30 min ago', Icons.medication_rounded, AppColors.warning, false),
    _Notification('Health Tip', 'Drink at least 8 glasses of water today to stay hydrated.', '1 hour ago', Icons.lightbulb_rounded, AppColors.accent, true),
    _Notification('Prediction Complete', 'Your AI disease prediction for today is ready. Tap to view.', '3 hours ago', Icons.biotech_rounded, AppColors.primary, true),
    _Notification('Nearby Hospital', 'City General Hospital is 1.2 km away and open 24/7.', 'Yesterday', Icons.local_hospital_rounded, AppColors.primary, true),
    _Notification('New Article', 'New article: Understanding Malaria Prevention in Rural Areas.', 'Yesterday', Icons.article_rounded, const Color(0xFF8B5CF6), true),
    _Notification('Emergency Alert', 'Dengue outbreak reported in your area. Take precautions.', '2 days ago', Icons.warning_amber_rounded, AppColors.emergency, true),
  ];

  @override
  Widget build(BuildContext context) {
    final unread = _notifications.where((n) => !n.isRead).length;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 130,
            backgroundColor: AppColors.background,
            foregroundColor: AppColors.textPrimary,
            elevation: 0,
            scrolledUnderElevation: 0,
            leading: IconButton(
              icon: Container(
                width: 36, height: 36,
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
            actions: [
              if (unread > 0)
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: AnimatedPress(
                    onTap: () => setState(() {
                      for (final n in _notifications) {
                        n.isRead = true;
                      }
                    }),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Text('Mark all read',
                          style: AppTextStyles.labelMedium
                              .copyWith(color: AppColors.primary)),
                    ),
                  ),
                ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: AppColors.background,
                padding: const EdgeInsets.fromLTRB(20, 90, 20, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(children: [
                      Text('Notifications',
                          style: AppTextStyles.headlineLarge),
                      if (unread > 0) ...[
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.emergency,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text('$unread new',
                              style: AppTextStyles.caption
                                  .copyWith(color: Colors.white,
                                      fontWeight: FontWeight.w700)),
                        ),
                      ],
                    ]),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: _notifications.isEmpty
                ? _emptyState()
                : Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
                    child: Column(
                      children: _notifications
                          .map((n) => _NotifCard(
                                notif: n,
                                onTap: () =>
                                    setState(() => n.isRead = true),
                                onDismiss: () =>
                                    setState(
                                        () => _notifications.remove(n)),
                              ))
                          .toList(),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _emptyState() => Center(
        child: Padding(
          padding: const EdgeInsets.all(60),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80, height: 80,
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Icon(Icons.notifications_none_rounded,
                    size: 38, color: AppColors.textTertiary),
              ),
              const SizedBox(height: 16),
              Text('All caught up!',
                  style: AppTextStyles.headlineMedium,
                  textAlign: TextAlign.center),
              Text('No new notifications',
                  style: AppTextStyles.bodyMedium,
                  textAlign: TextAlign.center),
            ],
          ),
        ),
      );
}

class _Notification {
  final String title, body, time;
  final IconData icon;
  final Color color;
  bool isRead;
  _Notification(this.title, this.body, this.time,
      this.icon, this.color, this.isRead);
}

class _NotifCard extends StatelessWidget {
  const _NotifCard({
    required this.notif,
    required this.onTap,
    required this.onDismiss,
  });
  final _Notification notif;
  final VoidCallback onTap;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismiss(),
      background: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: AppColors.emergency.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete_outline_rounded,
            color: AppColors.emergency, size: 22),
      ),
      child: AnimatedPress(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(AppSpacing.cardPaddingMd),
          decoration: BoxDecoration(
            color: notif.isRead
                ? AppColors.surface
                : AppColors.primary.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            border: Border.all(
              color: notif.isRead
                  ? AppColors.border
                  : AppColors.primary.withValues(alpha: 0.25),
            ),
            boxShadow: AppColors.shadowCard,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42, height: 42,
                decoration: BoxDecoration(
                  color: notif.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(13),
                  border: Border.all(
                      color: notif.color.withValues(alpha: 0.25)),
                ),
                child: Icon(notif.icon, color: notif.color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Expanded(
                        child: Text(notif.title,
                            style: AppTextStyles.titleSmall.copyWith(
                              color: notif.isRead
                                  ? AppColors.textPrimary
                                  : AppColors.primary,
                            )),
                      ),
                      if (!notif.isRead)
                        Container(
                          width: 8, height: 8,
                          decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle),
                        ),
                    ]),
                    const SizedBox(height: 4),
                    Text(notif.body,
                        style: AppTextStyles.bodySmall,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 6),
                    Text(notif.time, style: AppTextStyles.caption),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
