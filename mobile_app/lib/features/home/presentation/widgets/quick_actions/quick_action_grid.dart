import 'package:flutter/material.dart';
import '../../../domain/entities/quick_action.dart';
import '../../../../../../routing/route_names.dart';
import '../../../../../../themes/app_colors.dart';
import '../../../../../../themes/text_styles.dart';
import '../../../../../../themes/app_spacing.dart';
import '../../../../../../shared/widgets/animated_press.dart';

class QuickActionGrid extends StatelessWidget {
  final List<QuickAction> actions;
  const QuickActionGrid({super.key, required this.actions});

  IconData _iconForAction(String id) => switch (id) {
        'symptom'    => Icons.medical_information_rounded,
        'prediction' => Icons.biotech_rounded,
        'chatbot'    => Icons.smart_toy_rounded,
        'emergency'  => Icons.emergency_rounded,
        'records'    => Icons.folder_shared_rounded,
        'hospitals'  => Icons.local_hospital_rounded,
        'education'  => Icons.menu_book_rounded,
        'profile'    => Icons.person_rounded,
        _            => Icons.grid_view_rounded,
      };

  String? _routeForAction(String id) => switch (id) {
        'symptom'    => RouteNames.symptomChecker,
        'prediction' => RouteNames.diseasePrediction,
        'chatbot'    => RouteNames.chatbot,
        'emergency'  => RouteNames.emergency,
        'records'    => RouteNames.records,
        'hospitals'  => RouteNames.hospitals,
        'education'  => RouteNames.education,
        'profile'    => RouteNames.profile,
        _            => null,
      };

  _ActionStyle _styleForAction(String id) => switch (id) {
        'emergency' => const _ActionStyle(
            gradient: AppColors.gradientEmergency,
            iconColor: Colors.white,
            glowColor: AppColors.emergency,
          ),
        'chatbot' => const _ActionStyle(
            gradient: AppColors.gradientPurple,
            iconColor: Colors.white,
            glowColor: Color(0xFF8B5CF6),
          ),
        'prediction' => const _ActionStyle(
            gradient: AppColors.gradientCool,
            iconColor: Colors.white,
            glowColor: Color(0xFF06B6D4),
          ),
        'hospitals' => const _ActionStyle(
            gradient: AppColors.gradientAccent,
            iconColor: Colors.white,
            glowColor: AppColors.accent,
          ),
        'education' => const _ActionStyle(
            gradient: AppColors.gradientWarm,
            iconColor: Colors.white,
            glowColor: AppColors.warning,
          ),
        _ => const _ActionStyle(
            gradient: AppColors.gradientPrimary,
            iconColor: Colors.white,
            glowColor: AppColors.primary,
          ),
      };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 16,
          crossAxisSpacing: 12,
          childAspectRatio: 0.78,
        ),
        itemCount: actions.length,
        itemBuilder: (context, index) {
          final action = actions[index];
          return _QuickActionItem(
            action: action,
            icon: _iconForAction(action.id),
            style: _styleForAction(action.id),
            route: _routeForAction(action.id),
            delay: Duration(milliseconds: 60 * index),
          );
        },
      ),
    );
  }
}

// ── Internal helpers ──────────────────────────────────────────────────────────

class _ActionStyle {
  final Gradient gradient;
  final Color iconColor;
  final Color glowColor;
  const _ActionStyle({
    required this.gradient,
    required this.iconColor,
    required this.glowColor,
  });
}

class _QuickActionItem extends StatefulWidget {
  const _QuickActionItem({
    required this.action,
    required this.icon,
    required this.style,
    required this.delay,
    this.route,
  });

  final QuickAction action;
  final IconData icon;
  final _ActionStyle style;
  final Duration delay;
  final String? route;

  @override
  State<_QuickActionItem> createState() => _QuickActionItemState();
}

class _QuickActionItemState extends State<_QuickActionItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));

    Future.delayed(widget.delay, () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _handleTap() {
    final route = widget.route;
    if (route != null) {
      Navigator.of(context).pushNamed(route);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${widget.action.title} coming soon.'),
          backgroundColor: AppColors.surfaceVariant,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: AnimatedPress(
          onTap: _handleTap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  gradient: widget.style.gradient,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: widget.style.glowColor.withValues(alpha: 0.3),
                      blurRadius: 14,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Icon(widget.icon,
                    color: widget.style.iconColor, size: 24),
              ),
              const SizedBox(height: 8),
              Text(
                widget.action.title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
