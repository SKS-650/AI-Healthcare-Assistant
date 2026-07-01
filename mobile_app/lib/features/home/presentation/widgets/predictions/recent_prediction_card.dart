// lib/features/home/presentation/widgets/predictions/recent_prediction_card.dart
import 'package:flutter/material.dart';
import '../../../domain/entities/prediction.dart';

class RecentPredictionsList extends StatelessWidget {
  final List<Prediction> predictions;
  const RecentPredictionsList({super.key, required this.predictions});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: predictions.length,
      itemBuilder: (context, index) {
        final item = predictions[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.withValues(alpha: 0.12)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.diseaseName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 4),
                  Text('Analyzed on: ${item.date.day}/${item.date.month}/${item.date.year}', style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(color: Colors.teal.shade50, borderRadius: BorderRadius.circular(8)),
                child: Text('${(item.confidence * 100).toStringAsFixed(0)}% Match', style: TextStyle(color: Colors.teal.shade700, fontWeight: FontWeight.bold, fontSize: 13)),
              )
            ],
          ),
        );
      },
    );
  }
}