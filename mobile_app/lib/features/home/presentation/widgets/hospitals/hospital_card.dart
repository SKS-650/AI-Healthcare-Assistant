// lib/features/home/presentation/widgets/hospitals/hospital_card.dart
import 'package:flutter/material.dart';
import '../../../domain/entities/hospital.dart';

class NearbyHospitalsList extends StatelessWidget {
  final List<Hospital> hospitals;
  const NearbyHospitalsList({super.key, required this.hospitals});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: hospitals.length,
      itemBuilder: (context, index) {
        final hospital = hospitals[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.withValues(alpha: 0.12)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(10)),
                child: Icon(Icons.local_hospital, color: Colors.blue.shade700, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(hospital.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 2),
                    Text(hospital.address, style: TextStyle(color: Colors.grey.shade500, fontSize: 12), overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('${hospital.distance} km', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Colors.blue)),
                  const SizedBox(height: 2),
                  const Text('Open 24/7', style: TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.w600)),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}