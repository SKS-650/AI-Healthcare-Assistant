import 'package:flutter/material.dart';
import '../../../../../../themes/app_colors.dart';

class NotificationButton extends StatelessWidget {
  const NotificationButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: IconButton(
            icon: const Icon(
              Icons.notifications_outlined,
              size: 20,
              color: AppColors.textPrimary,
            ),
            onPressed: () {},
            padding: EdgeInsets.zero,
          ),
        ),
        // Red dot badge
        Positioned(
          top: 8,
          right: 8,
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: AppColors.emergency,
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.background,
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
