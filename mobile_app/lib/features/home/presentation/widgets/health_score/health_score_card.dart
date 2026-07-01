// lib/features/home/presentation/widgets/health_score/health_score_card.dart
import 'package:flutter/material.dart';
import '../../../domain/entities/health_score.dart';

class HealthScoreCard extends StatelessWidget {
  final HealthScore healthScore;
  const HealthScoreCard({super.key, required this.healthScore});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.15)),
      ),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 65,
                height: 65,
                child: CircularProgressIndicator(
                  value: healthScore.score / 100,
                  strokeWidth: 6,
                  backgroundColor: Colors.green.shade50,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green.shade600),
                ),
              ),
              Text('${healthScore.score}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Health Score: ${healthScore.status}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green.shade700)),
                const SizedBox(height: 4),
                Text(healthScore.description, style: TextStyle(fontSize: 13, color: Colors.grey.shade600, height: 1.3)),
              ],
            ),
          )
        ],
      ),
    );
  }
}