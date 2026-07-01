// lib/features/home/presentation/widgets/emergency/emergency_card.dart
import 'package:flutter/material.dart';

class EmergencyCard extends StatelessWidget {
  const EmergencyCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.shade200, width: 1),
      ),
      child: Row(
        children: [
          Icon(Icons.gpp_maybe_rounded, color: Colors.red.shade700, size: 36),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Medical Emergency Crisis?', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.red.shade900)),
                const SizedBox(height: 2),
                Text('Press the broadcast button to signal medical units instantly.', style: TextStyle(fontSize: 12, color: Colors.red.shade700)),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade700,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              elevation: 0,
            ),
            onPressed: () {},
            child: const Text('SOS', style: TextStyle(fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }
}