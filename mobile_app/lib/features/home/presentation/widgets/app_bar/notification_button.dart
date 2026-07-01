import 'package:flutter/material.dart';

class NotificationButton extends StatelessWidget {
  const NotificationButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        IconButton(
          icon: const Icon(Icons.notifications_none_rounded, size: 24),
          onPressed: () {},
        ),
        Container(
          margin: const EdgeInsets.only(top: 8, right: 8),
          width: 9,
          height: 9,
          decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
        ),
      ],
    );
  }
}
