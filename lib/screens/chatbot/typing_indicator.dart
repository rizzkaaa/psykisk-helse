import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class TypingIndicator extends StatelessWidget {
  const TypingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF2B303A),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _dot(0),
          const SizedBox(width: 4),
          _dot(200),
          const SizedBox(width: 4),
          _dot(400),
        ],
      ),
    );
  }

  Widget _dot(int delay) {
    return Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            color: Colors.grey,
            shape: BoxShape.circle,
          ),
        )
        .animate(onPlay: (controller) => controller.repeat(reverse: true))
        .scaleXY(begin: 0.5, end: 1.0, duration: 600.ms, delay: delay.ms)
        .tint(color: Color(0xFFacc990), duration: 600.ms);
  }
}
