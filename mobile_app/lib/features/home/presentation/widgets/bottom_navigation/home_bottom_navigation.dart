import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/dashboard_provider.dart';
import '../../../../../../routing/route_names.dart';
import '../../../../../../themes/app_colors.dart';
import '../../../../../../themes/text_styles.dart';

class HomeBottomNavigation extends ConsumerWidget {
  const HomeBottomNavigation({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIdx = ref.watch(dashboardTabProvider);

    void onTap(int index) {
      ref.read(dashboardTabProvider.notifier).state = index;
      switch (index) {
        case 1:
          Navigator.of(context).pushNamed(RouteNames.records);
        case 2:
          Navigator.of(context).pushNamed(RouteNames.chatbot);
        case 3:
          Navigator.of(context).pushNamed(RouteNames.profile);
      }
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: const Border(
          top: BorderSide(color: AppColors.border, width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            children: [
              _NavItem(icon: Icons.home_rounded,
                  outlineIcon: Icons.home_outlined,
                  label: 'Home', index: 0,
                  currentIndex: currentIdx, onTap: () => onTap(0)),
              _NavItem(icon: Icons.folder_shared_rounded,
                  outlineIcon: Icons.folder_shared_outlined,
                  label: 'Records', index: 1,
                  currentIndex: currentIdx, onTap: () => onTap(1)),
              _NavItem(icon: Icons.smart_toy_rounded,
                  outlineIcon: Icons.smart_toy_outlined,
                  label: 'AI Chat', index: 2,
                  currentIndex: currentIdx, onTap: () => onTap(2)),
              _NavItem(icon: Icons.person_rounded,
                  outlineIcon: Icons.person_outlined,
                  label: 'Profile', index: 3,
                  currentIndex: currentIdx, onTap: () => onTap(3)),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon, required this.outlineIcon,
    required this.label, required this.index,
    required this.currentIndex, required this.onTap,
  });

  final IconData icon, outlineIcon;
  final String label;
  final int index, currentIndex;
  final VoidCallback onTap;

  bool get _isSelected => index == currentIndex;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
              decoration: BoxDecoration(
                color: _isSelected
                    ? AppColors.primary.withValues(alpha: 0.15)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                _isSelected ? icon : outlineIcon,
                color: _isSelected
                    ? AppColors.primary
                    : AppColors.textTertiary,
                size: 22,
              ),
            ),
            const SizedBox(height: 3),
            Text(label,
                style: AppTextStyles.caption.copyWith(
                  color: _isSelected
                      ? AppColors.primary
                      : AppColors.textTertiary,
                  fontWeight:
                      _isSelected ? FontWeight.w600 : FontWeight.w400,
                )),
          ],
        ),
      ),
    );
  }
}
