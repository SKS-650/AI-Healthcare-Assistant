// lib/features/home/presentation/widgets/quick_actions/quick_action_grid.dart
import 'package:flutter/material.dart';

import '../../../domain/entities/quick_action.dart';

class QuickActionGrid extends StatelessWidget {
  final List<QuickAction> actions;

  const QuickActionGrid({super.key, required this.actions});

  IconData _getFallbackIcon(String id) {
    switch (id) {
      case 'symptom':
        return Icons.medication_outlined;
      case 'prediction':
        return Icons.analytics_outlined;
      case 'chatbot':
        return Icons.smart_toy_outlined;
      case 'emergency':
        return Icons.emergency_outlined;
      case 'records':
        return Icons.folder_shared_outlined;
      case 'hospitals':
        return Icons.local_hospital_outlined;
      case 'education':
        return Icons.school_outlined;
      default:
        return Icons.grid_view_rounded;
    }
  }

  Color _getIconColor(String id) {
    if (id == 'emergency') return Colors.red.shade600;
    return Colors.blue.shade600;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth >= 700 ? 4 : 4;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 16,
            crossAxisSpacing: 12,
            childAspectRatio: 0.82,
          ),
          itemCount: actions.length,
          itemBuilder: (context, index) {
            final action = actions[index];
            return GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${action.title} is under construction.')),
                );
              },
              child: Column(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: action.id == 'emergency' ? Colors.red.shade50 : Colors.blue.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(_getFallbackIcon(action.id), color: _getIconColor(action.id), size: 26),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    action.title,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, height: 1.1),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}