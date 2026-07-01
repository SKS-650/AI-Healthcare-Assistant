// lib/features/home/presentation/widgets/health_tips/tips_slider.dart
import 'package:flutter/material.dart';

class TipsSlider extends StatelessWidget {
  final List<String> tips;
  const TipsSlider({super.key, required this.tips});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      child: PageView.builder(
        itemCount: tips.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.amber.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.amber.shade200, width: 0.5),
            ),
            child: Row(
              children: [
                Icon(Icons.lightbulb_outline_rounded, color: Colors.amber.shade800, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    tips[index],
                    style: TextStyle(fontSize: 13, color: Colors.amber.shade900, height: 1.3, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}