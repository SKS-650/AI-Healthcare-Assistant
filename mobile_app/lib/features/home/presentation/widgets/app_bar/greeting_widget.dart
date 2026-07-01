import 'package:flutter/material.dart';

class GreetingWidget extends StatelessWidget {
  const GreetingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 20,
          backgroundColor: Colors.blueAccent,
          child: Text('JD', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Good Morning,',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600, fontWeight: FontWeight.w400),
            ),
            const Text(
              'John Doe',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, height: 1.2),
            ),
          ],
        ),
      ],
    );
  }
}
