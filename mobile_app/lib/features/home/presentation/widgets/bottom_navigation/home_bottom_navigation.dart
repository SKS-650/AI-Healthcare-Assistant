// lib/features/home/presentation/widgets/bottom_navigation/home_bottom_navigation.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/dashboard_provider.dart';

class HomeBottomNavigation extends ConsumerWidget {
  const HomeBottomNavigation({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIdx = ref.watch(dashboardTabProvider);

    return BottomNavigationBar(
      currentIndex: currentIdx,
      onTap: (index) => ref.read(dashboardTabProvider.notifier).state = index,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.blue.shade700,
      unselectedItemColor: Colors.grey.shade500,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
      unselectedLabelStyle: const TextStyle(fontSize: 12),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.dashboard_rounded), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.folder_shared_rounded), label: 'Records'),
        BottomNavigationBarItem(icon: Icon(Icons.forum_rounded), label: 'Chat'),
        BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Profile'),
      ],
    );
  }
}