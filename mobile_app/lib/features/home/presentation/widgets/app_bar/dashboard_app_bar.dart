import 'package:flutter/material.dart';
import '../../../../../../routing/route_names.dart';
import '../../../../../../themes/app_colors.dart';
import 'greeting_widget.dart';
import 'notification_button.dart';

class DashboardAppBar extends StatelessWidget implements PreferredSizeWidget {
  const DashboardAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            children: [
              const Expanded(child: GreetingWidget()),
              const SizedBox(width: 12),
              // Emergency quick-access
              GestureDetector(
                onTap: () => Navigator.of(context)
                    .pushNamed(RouteNames.emergency),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.emergency.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.emergency.withValues(alpha: 0.25),
                    ),
                  ),
                  child: const Icon(
                    Icons.emergency_outlined,
                    size: 18,
                    color: AppColors.emergency,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Notification button
              GestureDetector(
                onTap: () => Navigator.of(context)
                    .pushNamed(RouteNames.notifications),
                child: const NotificationButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70);
}
